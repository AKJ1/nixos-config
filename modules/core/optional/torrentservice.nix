{ pkgs, ... }:
{
  services.qbittorrent = {
    enable = true;
    webuiPort = 8080;
    package = pkgs.qbittorrent;

    serverConfig = {
      LegalNotice = {
        Accepted = true;
      };
      Preferences = {
        WebUI = {
          LocalHostAuth = true;
          Username = "admin";
          # Password_PBKDF2 hash (generate via tool or qBittorrent web UI)
          Password_PBKDF2 = "$pbkdf2-sha256$i=600000,l=32$Y0Ou+b4BEoUYHZ5UPuOhDg$fvctPU4siwEnqQ0Aq8dAirF+l30bv7P0CGyzCjNFtOw";
        };
      };
    };
    extraArgs = "--confirm-legal-notice";
  };
}
