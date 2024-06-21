{ nushell-defaultConfig, ... }:
let
  theme = builtins.readFile ./theme.nu;
  extraConfig = builtins.readFile ./configExtra.nu;
  ROOT = builtins.toString ./.;
in {
  programs.nushell = {
    enable = true;
    configFile.source =
      "${nushell-defaultConfig}/crates/nu-utils/src/sample_config/default_config.nu";
    envFile.source =
      "${ROOT}/env.nu";
    extraConfig = ''
      ${theme}
      ${extraConfig}
    '';
    extraEnv = builtins.readFile ./envExtra.nu;
  };
}

