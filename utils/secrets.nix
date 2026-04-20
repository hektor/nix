{ lib }:

{
  mkSopsSecrets =
    sopsDir: owner: groups:
    let
      opts = lib.optionalAttrs (owner != null) { inherit owner; };
      mkGroup =
        group: names:
        let
          file = "${group}.yaml";
        in
        lib.foldl' lib.mergeAttrs { } (
          map (name: {
            "${group}/${name}" = {
              sopsFile = "${sopsDir}/${file}";
              key = name;
            }
            // opts;
          }) names
        );
    in
    lib.foldl' lib.mergeAttrs { } (lib.mapAttrsToList mkGroup groups);

  sopsAvailability =
    config: osConfig:
    let
      osSopsAvailable = osConfig != null && osConfig ? sops && osConfig.sops ? secrets;
      hmSopsAvailable = config ? sops && config.sops ? secrets;
      preferOs = osSopsAvailable;
    in
    {
      available = osSopsAvailable || hmSopsAvailable;
      secrets = if preferOs then osConfig.sops.secrets else config.sops.secrets;
      templates = if preferOs then osConfig.sops.templates else config.sops.templates;
    };
}
