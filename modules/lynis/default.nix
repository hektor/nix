{
  lib,
  config,
  pkgs,
  ...
}:

let
  serverRoles = [
    "server"
    "embedded"
  ];
  server = lib.elem config.host.role serverRoles;
  role = if server then "server" else "personal";
  forwarding = lib.elem (config.boot.kernel.sysctl."net.ipv4.conf.all.forwarding" or false) [
    true
    1
    "1"
  ];
in
{
  options.lynis = {
    enable = lib.mkOption {
      default = false;
      type = lib.types.bool;
    };
    skipTests = lib.mkOption {
      default = [
        "AUTH-9230"
        "AUTH-9262"
        "AUTH-9284"
        "AUTH-9286"
        "FILE-6310"
        "FILE-6410"
        "FINT-4350"
        "KRNL-5830"
        "NAME-4028"
        "PKGS-7398"
        "SSH-7408"
        "TOOL-5002"
      ]
      ++ lib.optionals (!server) [
        "ACCT-9622"
        "ACCT-9626"
        "ACCT-9628"
        "HRDN-7222"
        "HRDN-7230"
        "KRNL-6000:kernel.modules_disabled"
        "LOGG-2154"
        "USB-1000"
      ]
      ++ lib.optional forwarding "KRNL-6000:net.ipv4.conf.all.forwarding";
      type = lib.types.listOf lib.types.str;
    };
  };

  config = lib.mkIf config.lynis.enable {
    environment.systemPackages = [ pkgs.lynis ];
    environment.etc."lynis/custom.prf".text = lib.concatLines (
      [ "machine-role=${role}" ] ++ map (t: "skip-test=${t}") config.lynis.skipTests
    );
  };
}
