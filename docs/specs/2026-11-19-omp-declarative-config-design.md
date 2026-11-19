# Declarative omp Configuration in the NixOS Repo

**Date:** 2026-11-19
**Status:** Design, awaiting approval
**Host:** `PrimeIncarnon` (flake config name), user `ace`

## Intent

Make omp's configuration reproducible from this repository instead of imperative
per-machine state: settings, provider credentials, custom task agents, and the
superpowers plugin. Secrets stay in sops; nothing secret enters the Nix store,
git, or the process environment.

The user runs omp on several hosts and wants `home-manager switch` to produce the
same omp setup. Interactive edits (`/settings`, `/models`, `/agents`) must keep
working for anything the repo does not declare.

## Current State (verified)

| Item | Location | Value |
|---|---|---|
| omp | `pkgs.omp` (18.8.9) | package only; `programs.omp` block commented out in `modules/home/opencode/omp.nix` |
| Settings | `~/.omp/agent/config.yml` (241 B) | `modelRoles.default`, `symbolPreset`, `composer.shape`, `theme.{dark,light}`, `setupVersion`, `memory.backend`, `autolearn.enabled`, `defaultThinkingLevel` |
| Provider keys | `~/.omp/agent/agent.db`, table `auth_credentials` | `openrouter`, `opencode-go`, plaintext JSON `{key, source}` |
| Plugin | `~/.omp/plugins/` | `superpowers@superpowers-dev` 7.0.2-omp.3 (marketplace install) |
| Custom agents | `~/.omp/agent/agents/` | directory does not exist |
| sops | `modules/home/ace/sops.nix`, `secrets/ace-secrets.yaml` | HM sops-nix; secrets at `~/.config/sops-nix/secrets/<name>`, mode `0400`; age key `~/.sops-nix/key.txt` |
| Flake input | `flake.nix` | `oh-my-pi` exists but is unused |

Relevant omp behavior, verified in the installed 18.8.9 sources and docs:

- Settings layers, highest first: setting env vars, runtime overrides, config
  overlays (`PI_CONFIG_FILES`, then `--config`), project config, global
  `config.yml`, defaults. Overlays are read-only and strict (a missing or
  invalid file aborts startup). Record settings merge per key; array settings
  replace wholesale.
- omp rewrites `config.yml` at runtime under an advisory lock. A read-only store
  symlink at that path breaks startup, which is why the upstream HM module
  copies the file instead of linking it.
- Provider credential precedence: runtime `--api-key` > `models.yml` `apiKey` >
  stored OAuth > stored login key > extension fallback > env > other stored.
  A `models.yml` key therefore beats the two keys currently in `agent.db`.
- `models.yml` `providers.<id>.apiKey` values starting with `!` run through
  `/bin/sh -c` with a 10 s timeout, cwd = project dir. Stdout is trimmed,
  cached for the process lifetime, and re-resolved after a 401. Failure backs
  off 30 s. The key never enters an env var or the Nix store.
- omp never writes `models.yml`; it only migrates a legacy `models.json` when no
  YAML exists. A read-only store symlink is safe.
- A directory listed in the `extensions` setting is an extension root. omp
  scans `<root>/agents`, `<root>/skills`, `<root>/hooks`, `<root>/tools`,
  `<root>/commands`, `<root>/rules`, `<root>/prompts`, `.mcp.json`, and the
  package's `omp.extensions` / `pi.extensions` entry (installed-plugin
  precedence: CLI roots, settings roots, installed plugins).

## Goals

1. Settings declared in the repo, layered above the writable global config.
2. `openrouter` and `opencode-go` credentials from sops via `models.yml`
   command values; no env vars, no plaintext in the repo or store.
3. Custom task agents stored in the repo and symlinked into omp's agent dir.
4. superpowers pinned in `flake.lock`, loaded as an extension root, replacing
   the marketplace install.
5. One `home-manager switch` reproduces all of it on a host.

## Non-Goals

- Removing the existing `agent.db` credentials in this change. The session that
  produced this design is running under omp; removal is a documented follow-up.
- Managing sessions, history, `models.db`, blobs, or the marketplace registry.
- Per-host settings variants. One overlay for all hosts; split later if a host
  needs a different model role.
- Converting other plugins or installing more marketplaces.
- Declaring `setupVersion`; it is runtime onboarding state.

## Anti-Goals

- Secret material in git, the Nix store, or any process environment.
- Symlinking or otherwise making the whole `~/.omp/agent` directory read-only.
- Using `programs.omp.settings`, which overwrites runtime edits on every switch.
- Breaking `/settings`, `/models`, or `/agents` for undeclared keys.

## Approaches Considered

### Settings

- **A. `programs.omp.settings`** — first-party, writes `config.yml` at
  activation. Rejected: overwrites every interactive change on each switch and
  offers no place for credentials, agents, or plugins.
- **B. `PI_CONFIG_FILES` overlay through a wrapper (chosen)** — the repo file
  lives in the store and outranks global config. Declared keys win; undeclared
  keys stay editable. The wrapper guarantees the variable is present for
  shell, niri, and desktop launches without polluting the login environment.
- **C. Generate the whole `~/.omp/agent`** — rejected: sessions, DBs, and caches
  live there and must stay writable.

### Credentials

- **A. sops template to `~/.omp/agent/.env`** — rejected: omp loads `.env` into
  the process environment; every bash child inherits the key and
  `/proc/<pid>/environ` exposes it.
- **B. Wrapper exports env vars for the omp process** — rejected for the same
  inheritance and `/proc` exposure, plus wrapper complexity.
- **C. `models.yml` with `apiKey: "!cat <sops path>"` (chosen)** — key exists
  only as a resolver output in omp's memory. No env, no store copy, lazy and
  cached. Only the path appears in `/proc/<pid>/cmdline`.
- **D. Inline the plaintext into a generated `models.yml`** — rejected: adds a
  second plaintext copy on disk with no benefit over the sops file.

## Design

### File layout

```text
modules/home/opencode/omp/
  default.nix        # wrapper, overlay generation, models.yml + agent links
  models.yml         # provider apiKey command values (no secrets)
  agents/            # custom agent markdown (empty at first)
modules/home/opencode/default.nix   # import ./omp instead of ./omp.nix
modules/home/ace/sops.nix           # + two sops.secrets entries
secrets/ace-secrets.yaml            # + two encrypted keys
flake.nix + flake.lock              # + pinned omp-superpowers input
```

`modules/home/opencode/omp.nix` is removed and replaced by the directory above;
its aggregator import becomes `./omp`. `home.packages` gains the wrapper script
named `omp`; the bare `pkgs.omp` entry is dropped so PATH has one `omp`.

### Settings overlay

`default.nix` builds the overlay with `pkgs.formats.yaml` so the plugin store
path can be injected:

```nix
settings = {
  modelRoles.default = "opencode-go/deepseek-v4.1-flash";
  symbolPreset = "unicode";
  composer.shape = "band";
  theme = { dark = "titanium"; light = "dark-forest"; };
  memory.backend = "local";
  autolearn.enabled = false;
  defaultThinkingLevel = "auto";
  extensions = [ "${inputs.omp-superpowers}" ];
};
```

`modelRoles` is a record, so the overlay only overrides `default` and leaves
other roles from the global config intact. `extensions` is an array, so it
replaces any runtime list: extensions added from the UI will not stick. That is
the deliberate cost of pinning the plugin.

The wrapper:

```nix
omp = pkgs.writeShellScriptBin "omp" ''
  export PI_CONFIG_FILES=${overlayFile}
  exec ${pkgs.omp}/bin/omp "$@"
'';
```

Behavior: `--config` overlays passed on the command line still load after
`PI_CONFIG_FILES` and win. A named profile (`--profile`) still receives the
overlay, because overlays are process-scoped rather than profile-scoped; this
is acceptable and documented.

### Credentials

`models.yml`, symlinked to `~/.omp/agent/models.yml`:

```yaml
providers:
  openrouter:
    apiKey: "!cat $HOME/.config/sops-nix/secrets/openrouter_api_key"
  opencode-go:
    apiKey: "!cat $HOME/.config/sops-nix/secrets/opencode_api_key"
```

Both entries are valid override-only providers (`apiKey` alone is sufficient).
YAML quoting is required because a leading `!` is a tag indicator. `$HOME` is
left literal in the file and expanded by `/bin/sh`.

`sops.secrets.openrouter_api_key = {};` and
`sops.secrets.opencode_api_key = {};` are added to the existing
`modules/home/ace/sops.nix`, with matching encrypted entries in
`secrets/ace-secrets.yaml`. The secret files are mode `0400`, owned by `ace`,
and readable only by that user.

The plaintext source is the existing `agent.db` `auth_credentials` rows. Values
are extracted read-only with Python's `sqlite3`, piped into
`sops set --value-stdin`, and never echoed, written to a temp file, or placed on
a command line. `sops` re-encrypts to the recipients from `.sops.yaml`, which
already covers the hosts that decrypt today's syncthing secrets; omp is
installed on every host through `modules/home/default.nix`, so the new secrets
follow the same host scope as the existing ones.

Failure mode: a missing sops file makes the command fail, the provider resolves
no key, and omp reports the provider as unavailable. Because `models.yml` sits
above stored credentials, this stays visible even while `agent.db` still holds
the old keys. Once the follow-up removes those rows, there is no silent
fallback at all.

### Custom agents

`agents = [ ];` in `default.nix`, expanded with `lib.listToAttrs` into
`home.file` entries at `.omp/agent/agents/<basename>`. Adding an agent is one
path in that list plus the markdown file in `agents/`. Individual file symlinks
are chosen over a directory symlink so omp or the user can still create
untracked agents at runtime.

No placeholder agent is added; the mechanism is proven during verification with
a temporary file that is removed afterwards. The plugin's agents (from
`<extension-root>/agents`) exercise the same discovery path with real content.

### Plugin

Add a pinned flake input:

```nix
omp-superpowers.url = "github:LoneExile/omp-superpowers/v7.0.2-omp.3";
```

This is not a source switch. The marketplace currently installed on this host
was added from `loneexile/omp-superpowers` (verified: `marketplaces.json`
`sourceUri`, the cached clone's `origin`, and the installed plugin's
`package.json` all name LoneExile), at commit
`fad5b9e7ec578fbac11c7dbe1b251ceb1d7f19a9`, which is exactly tag
`v7.0.2-omp.3`. `obra/superpowers` is the upstream Claude Code skills library
by Jesse Vincent; the LoneExile repo is the omp adaptation that adds the
`pi.extensions` entry, omp task-agent definitions, and the skill mapping. The
catalog metadata still credits the upstream author because the fork preserves
it. Pinning the fork reproduces today's behavior; pinning upstream would load a
Claude-format plugin and lose the omp-specific agents.

The overlay's `extensions` list points at the input's store path. omp loads the
package's `pi.extensions` entry and scans its `agents/` and `skills/` siblings,
which replaces what `/marketplace install` did.

Cutover: uninstall the marketplace copy
(`omp plugin uninstall superpowers@superpowers-dev`) after the switch when it is
convenient. Until then both roots are discovered; names are deduplicated
first-wins and the content is identical, so behavior is unchanged. This is a
manual step, not part of the switch, and is safe to defer.

## Constraints

- Overlay files are strict: the store path must exist and parse, or omp exits.
- `PI_CONFIG_FILES` uses the platform path-list separator (`:` on Linux).
- `models.yml` and the overlay are read-only store paths; omp must never need to
  write them.
- New files must be `git add`ed before any `nix build`; the flake reads the git
  tree.
- `secrets/ace-secrets.yaml` edits require `sops` and the age key; no plaintext
  key may be written into the repo at any point, including test commands that
  echo output. Verification reads keys only into shell variables or checks
  non-empty length.
- The wrapper must be transparent: same argv, exit code, stdin/stdout/stderr,
  and environment except `PI_CONFIG_FILES`.

## Verification

1. `nix build ".#nixosConfigurations.PrimeIncarnon.config.system.build.toplevel"`
   succeeds.
2. After `home-manager switch`: `command -v omp` resolves to the wrapper;
   `omp --help` works; `~/.omp/agent/models.yml` is a symlink into the store;
   `~/.config/sops-nix/secrets/{openrouter,opencode}_api_key` exist with mode
   `0400`.
3. Overlay is active: inside omp, `/settings` reports the declared keys from the
   overlay layer, and a key not declared in the overlay remains editable.
4. Credentials: `omp models opencode-go` and `omp models openrouter` list
   models; a one-line prompt on an `opencode-go` model and on an `openrouter`
   model both succeed.
5. Negative test: `chmod 000` the openrouter secret (or move it), start a new
   omp process, and confirm an `openrouter` request fails while the stored
   `agent.db` key still exists; restore the mode and confirm recovery. This
   proves the config layer outranks storage.
6. Agents: `~/.omp/agent/agents/` contains exactly the symlinked repo files;
   `/agents` lists a temporary test agent after a switch and no longer lists it
   after removal.
7. Plugin: `/agents` lists superpowers agents and the skills are present with
   the marketplace copy still installed; repeat after `omp plugin uninstall`.

Rollback: revert the commit and switch; delete the symlinks if reverting
partially. `~/.omp/agent/config.yml` is never modified by this change, so
interactive settings survive.

## Decisions Settled During the Builder Check

- **Secret source and write path (our call):** extract from `agent.db` read-only
  and pipe into `sops set --value-stdin`. No rotation in this change; rotation
  remains a follow-up. The sops store is the owner's and is only re-encrypted to
  its existing recipients.
- **Host scope (our call):** secrets are declared in the same shared HM module
  as the existing syncthing secrets, so they materialize on every host that
  imports `modules/home/default.nix`. omp is installed on all of them today, and
  `.sops.yaml` already lists the recipient set those hosts use. No per-host
  conditional is added.
- **Named profiles (our call):** unsupported. No profile directories or
  `OMP_PROFILE` exist on this host. The overlay still applies inside a profile,
  but `models.yml` and `agents/` are linked only in the default-profile agent
  directory. Documented rather than worked around.

## Follow-Ups (outside this change)

- Remove the `openrouter` and `opencode-go` rows from `agent.db` when no running
  omp session depends on them, so no plaintext credentials remain at rest.
- Rotate both keys if the plaintext database was ever copied or synced.
- Add real custom agents to `agents/`.
- Uninstall the marketplace copy of superpowers.
- Consider per-host overlays if a host needs a different model role.
