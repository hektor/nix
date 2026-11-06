{ lib }:

{
  mkSopsSecrets =
    sopsDir: owner: groups:
    let
      opts = lib.optionalAttrs (owner != null) { inherit owner; };
      mkGroup =
        group: names:
        lib.listToAttrs (
          map (name: {
            name = "${group}/${name}";
            value = {
              sopsFile = "${sopsDir}/${group}.yaml";
              key = name;
            }
            // opts;
          }) names
        );
    in
    lib.mergeAttrsList (lib.mapAttrsToList mkGroup groups);

  sopsAvailability =
    config: osConfig:
    let
      osSopsAvailable = osConfig != null && osConfig ? sops && osConfig.sops ? secrets;
      hmSopsAvailable = config ? sops && config.sops ? secrets;
    in
    {
      available = osSopsAvailable || hmSopsAvailable;
      secrets = if osSopsAvailable then osConfig.sops.secrets else config.sops.secrets;
      templates = if osSopsAvailable then osConfig.sops.templates else config.sops.templates;
    };
}
