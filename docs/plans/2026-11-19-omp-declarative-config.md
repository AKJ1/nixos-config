# Declarative omp Configuration Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Move omp settings, provider credentials, custom agents, and the superpowers plugin into the NixOS repo, with secrets in sops and nothing secret in the store or environment.

**Architecture:** A shell wrapper sets `PI_CONFIG_FILES` to a generated read-only overlay so repo settings outrank the writable global config. `models.yml` is symlinked from the repo and resolves both provider keys by running `cat` against sops-nix secret files. Custom agents are per-file symlinks into omp's agent dir. The plugin is a pinned flake input referenced from the overlay's `extensions` array.

**Tech Stack:** Nix flakes, Home Manager, sops-nix, omp 18.8.9 (`pkgs.omp`).

**Spec:** `docs/specs/2026-11-19-omp-declarative-config-design.md`

## Global Constraints

- Target host: `PrimeIncarnon`; user `ace`; home `/home/ace`.
- Never print, `echo`, `set -x`, or write a plaintext secret value. Read keys only into pipes; verify with byte counts.
- New files must be `git add`ed before any `nix build`; the flake reads the git tree.
- Commit style: `feat(omp):` or `chore(omp):`.
- Overlay file is strict: a missing or unparsable file must abort omp startup.
- `modelRoles` is a record setting and merges per key. `extensions` is an array setting and replaces wholesale.
- Secret paths: `~/.config/sops-nix/secrets/{openrouter,opencode}_api_key`, mode `0400`.
- Do not touch `~/.omp/agent/agent.db` or `~/.omp/agent/config.yml` in this change.

## Review Focus

- A missing or malformed overlay makes every omp launch fail, including `omp --help`. Task 2 tests the failure and the wrapper's normal path.
- A failing `!cat` silently falls back to the stored `agent.db` key while those rows exist. Task 5 tests that config-level failure is visible.
- sops decrypt failure on a host that lacks a recipient breaks activation. Task 4 verifies decryption locally; foreign hosts get eval only.
- Interactive edits to keys declared in the overlay appear accepted but are shadowed. Task 5 checks provenance and an undeclared-key control.
- The marketplace copy and the pinned plugin both expose the same agent and skill names while the marketplace copy remains installed. Task 5 checks for duplicate names.

---

### Task 1: Pin the superpowers plugin input

**Files:**
- Modify: `flake.nix:34-35`
- Modify: `flake.lock`

**Interfaces:**
- Produces: `inputs.omp-superpowers` — source tree at tag `v7.0.2-omp.3`, `flake = false`.
- Consumes: nothing.

- [ ] **Step 1: Add the input**

After the `oh-my-pi` line in `flake.nix`:

```nix
    omp-superpowers = {
      url = "github:LoneExile/omp-superpowers/v7.0.2-omp.3";
      flake = false;
    };
```

- [ ] **Step 2: Update only that lock entry**

Inspect `git diff flake.lock` first: the file already has local modifications
that are not part of this plan. Decide whether to commit or stash them before
continuing.

Run: `nix flake update omp-superpowers`
Expected: exit 0; `flake.lock` gains an `omp-superpowers` node. If the command
rejects an unknown input, run `nix flake lock` instead.

- [ ] **Step 3: Verify the locked revision matches the tag**

Run:

```bash
nix flake metadata --json | python3 -c 'import json,sys; n=json.load(sys.stdin)["locks"]["nodes"]["omp-superpowers"]; print(n["locked"]["rev"], n["locked"]["type"])'
```

Expected: `fad5b9e7ec578fbac11c7dbe1b251ceb1d7f19a9 github`.

- [ ] **Step 4: Commit**

```bash
git add flake.nix flake.lock
git commit -m "feat(omp): pin superpowers plugin input"
```

---

### Task 2: Replace the module with wrapper and overlay

**Files:**
- Create: `modules/home/opencode/omp/default.nix`
- Delete: `modules/home/opencode/omp.nix`
- Modify: `modules/home/opencode/default.nix:2-5`

**Interfaces:**
- Consumes: `inputs.omp-superpowers` from Task 1.
- Produces: `home.packages` contains a derivation named `omp` whose script exports `PI_CONFIG_FILES=<store path>` and execs `${pkgs.omp}/bin/omp "$@"`; `overlayFile` is the generated YAML store path.

- [ ] **Step 1: Write the module**

`modules/home/opencode/omp/default.nix`:

```nix
{
  pkgs,
  inputs,
  lib,
  ...
}:
let
  yaml = pkgs.formats.yaml { };

  overlaySettings = {
    modelRoles.default = "opencode-go/deepseek-v4.1-flash";
    symbolPreset = "unicode";
    composer.shape = "band";
    theme = {
      dark = "titanium";
      light = "dark-forest";
    };
    memory.backend = "local";
    autolearn.enabled = false;
    defaultThinkingLevel = "auto";
    extensions = [ "${inputs.omp-superpowers}" ];
  };

  overlayFile = yaml.generate "omp-config.yml" overlaySettings;

  omp = pkgs.writeShellScriptBin "omp" ''
    export PI_CONFIG_FILES=${overlayFile}
    exec ${pkgs.omp}/bin/omp "$@"
  '';
in
{
  home.packages = [ omp ];
}
```

- [ ] **Step 2: Repoint the aggregator and delete the old file**

In `modules/home/opencode/default.nix`, change `./omp.nix` to `./omp`, then
`git rm modules/home/opencode/omp.nix`.

- [ ] **Step 3: Evaluate the wrapper and overlay**

Run:

```bash
nix eval --json ".#nixosConfigurations.PrimeIncarnon.config.home-manager.users.ace.home.packages" \
  | python3 -c 'import json,sys; print([p["name"] for p in json.load(sys.stdin) if "omp" in p["name"].lower()])'
```

Expected: a list containing `omp` and no separate bare `omp-18.8.9` package entry
from this module.

Run:

```bash
nix build ".#nixosConfigurations.PrimeIncarnon.config.system.build.toplevel"
```

Expected: exit 0.

- [ ] **Step 4: Verify the overlay is strict**

Get the unwrapped binary and launch it with a missing overlay:

```bash
real=$(nix eval --raw ".#nixosConfigurations.PrimeIncarnon.pkgs.omp.outPath")
PI_CONFIG_FILES=/nix/store/does-not-exist-omp.yml "$real/bin/omp" -p "hi"
```

Expected: non-zero exit with a config-load error naming the missing overlay.
The wrapper itself is not tested this way because it overwrites the variable.

- [ ] **Step 5: Commit**

```bash
git add modules/home/opencode/omp/default.nix modules/home/opencode/default.nix
git commit -m "feat(omp): run omp with a declarative settings overlay"
```

---

### Task 3: Link models.yml and agent files

**Files:**
- Create: `modules/home/opencode/omp/models.yml`
- Create: `modules/home/opencode/omp/agents/` (kept empty; no placeholder)
- Modify: `modules/home/opencode/omp/default.nix`

**Interfaces:**
- Consumes: module `let` block from Task 2.
- Produces: `home.file.".omp/agent/models.yml"` and one
  `home.file.".omp/agent/agents/<basename>"` per path in `agents`.

- [ ] **Step 1: Write models.yml**

```yaml
providers:
  openrouter:
    apiKey: "!cat $HOME/.config/sops-nix/secrets/openrouter_api_key"
  opencode-go:
    apiKey: "!cat $HOME/.config/sops-nix/secrets/opencode_api_key"
```

- [ ] **Step 2: Add the links**

In the module's `let` block:

```nix
  agents = [ ];

  agentFiles = lib.listToAttrs (
    map (file: {
      name = ".omp/agent/agents/${baseNameOf file}";
      value.source = file;
    }) agents
  );
```

In the module body:

```nix
  home.file = {
    ".omp/agent/models.yml".source = ./models.yml;
  } // agentFiles;
```

- [ ] **Step 3: Verify YAML parses and the attributes evaluate**

Run: `nix run nixpkgs#yq -- -e '.' modules/home/opencode/omp/models.yml`
Expected: exits 0 and prints the two providers.

Run:

```bash
nix eval --json ".#nixosConfigurations.PrimeIncarnon.config.home-manager.users.ace.home.file" \
  | python3 -c 'import json,sys; print(sorted(json.load(sys.stdin)))'
```

Expected: the list contains `.omp/agent/models.yml` (and no `.omp/agent/agents/*`
entries while `agents = [ ]`).

- [ ] **Step 4: Build**

Run: `nix build ".#nixosConfigurations.PrimeIncarnon.config.system.build.toplevel"`
Expected: exit 0.

- [ ] **Step 5: Commit**

```bash
git add modules/home/opencode/omp/models.yml modules/home/opencode/omp/default.nix
git commit -m "feat(omp): link provider config into the agent dir"
```

---

### Task 4: Add sops secrets

**Review:** per-task — security

**Files:**
- Modify: `modules/home/ace/sops.nix`
- Modify: `secrets/ace-secrets.yaml` (encrypted only)

**Interfaces:**
- Produces: decrypted files at `~/.config/sops-nix/secrets/openrouter_api_key`
  and `opencode_api_key` on activation.
- Consumes: the two `agent.db` rows as the plaintext source.

- [ ] **Step 1: Declare the secrets**

Append to `modules/home/ace/sops.nix`, inside the existing attrset:

```nix
  sops.secrets.openrouter_api_key = { };
  sops.secrets.opencode_api_key = { };
```

- [ ] **Step 2: Encrypt each value from the database without echoing it**

Run, one provider at a time:

```bash
python3 - <<'PY' | SOPS_AGE_KEY_FILE="$HOME/.sops-nix/key.txt" \
  sops set --value-stdin --idempotent secrets/ace-secrets.yaml '["openrouter_api_key"]'
import json, sqlite3, sys
c = sqlite3.connect("file:/home/ace/.omp/agent/agent.db?mode=ro", uri=True)
(data,) = c.execute(
    "select data from auth_credentials where provider = 'openrouter'"
).fetchone()
sys.stdout.write(json.dumps(json.loads(data)["key"]))
PY
```

Replace `openrouter` with `opencode-go` and `openrouter_api_key` with
`opencode_api_key` for the second run. `--value-stdin` expects a JSON-encoded
string; this was verified against sops 3.13.3.

- [ ] **Step 3: Verify decryption and that no plaintext landed in the diff**

```bash
SOPS_AGE_KEY_FILE="$HOME/.sops-nix/key.txt" \
  sops decrypt --extract '["openrouter_api_key"]' secrets/ace-secrets.yaml | wc -c
SOPS_AGE_KEY_FILE="$HOME/.sops-nix/key.txt" \
  sops decrypt --extract '["opencode_api_key"]' secrets/ace-secrets.yaml | wc -c
SOPS_AGE_KEY_FILE="$HOME/.sops-nix/key.txt" \
  sops decrypt --extract '["syncthing_key_z13"]' secrets/ace-secrets.yaml | wc -c
git diff --stat
```

Expected: both counts greater than 10, the syncthing count unchanged and
non-zero, and `git diff --stat` lists only `secrets/ace-secrets.yaml` plus
`sops.nix`. No value appears in the diff, only key names and ciphertext.

- [ ] **Step 4: Build**

Run: `nix build ".#nixosConfigurations.PrimeIncarnon.config.system.build.toplevel"`
Expected: exit 0.

- [ ] **Step 5: Commit**

```bash
git add modules/home/ace/sops.nix secrets/ace-secrets.yaml
git commit -m "feat(omp): source provider keys from sops"
```

---

### Task 5: Apply and verify end to end

**Files:** none (verification only; adjust earlier files only if a check fails).

**Interfaces:**
- Consumes: all previous tasks.

- [ ] **Step 1: Apply the system**

Run: `sudo nixos-rebuild switch --flake .#PrimeIncarnon`
Expected: activation succeeds; sops writes both secret files.

- [ ] **Step 2: Verify links, modes, and the wrapper**

```bash
readlink -f ~/.omp/agent/models.yml
stat -c '%a %n' ~/.config/sops-nix/secrets/openrouter_api_key ~/.config/sops-nix/secrets/opencode_api_key
head -3 "$(command -v omp)"
```

Expected: the link resolves into `/nix/store`; modes are `400`; the script
contains `PI_CONFIG_FILES=` and `exec /nix/store/.../bin/omp`.

- [ ] **Step 3: Verify the overlay is the active layer**

Start `omp`, open `/settings`, and check that `modelRoles.default`,
`theme.dark`, and `extensions` report the overlay as their layer. Change an
undeclared setting (for example `display.showTokenUsage`), restart, and confirm
it persists. Then try changing `theme.dark`; it may appear accepted but reverts
on the next launch. That is the documented tradeoff, not a failure.

- [ ] **Step 4: Verify credentials resolve from models.yml**

```bash
omp models opencode-go
omp models openrouter
omp -p --model opencode-go/deepseek-v4.1-flash "reply with OK only"
```

Expected: both listings succeed and the prompt prints `OK`. Run the equivalent
one-liner on `openrouter/deepseek/deepseek-chat-v3.1` to exercise the
openrouter key.

- [ ] **Step 5: Negative test — config beats stored credentials**

With a new omp process, temporarily make the openrouter secret unreadable:

```bash
chmod 000 ~/.config/sops-nix/secrets/openrouter_api_key
omp -p --model openrouter/deepseek/deepseek-chat-v3.1 "reply with OK only"; echo "exit=$?"
chmod 400 ~/.config/sops-nix/secrets/openrouter_api_key
```

Expected: the request fails (non-zero, auth/key error) even though `agent.db`
still holds an openrouter key. Restoring `400` and retrying succeeds. If it
succeeds while `000`, the config layer is not being used — stop and investigate.

- [ ] **Step 6: Verify agents and plugin discovery**

Add a temporary agent file, rebuild, and check it appears:

```bash
printf -- '---\nname: probe\ndescription: probe\n---\nprobe\n' > modules/home/opencode/omp/agents/probe.md
# add ./agents/probe.md to `agents` in default.nix, then:
nixos-rebuild switch --flake .#PrimeIncarnon
```

Inside omp, `/agents` lists `probe` exactly once, and the superpowers agents
(`scout`, `reviewer`, `security-reviewer`, `task`, `sonic`) each appear once.
Then remove `probe.md`, revert the `agents` list, and switch again; `/agents` no
longer lists `probe`.

- [ ] **Step 7: Remove the temporary agent and confirm a clean tree**

Run: `git status --short`
Expected: only intentional changes; no `probe.md`.

- [ ] **Step 8: Commit any verification adjustments**

If a check required a change, commit it:

```bash
git add modules/home/opencode/omp docs
git commit -m "fix(omp): <what the check changed>"
```

If no change was needed, no commit.
