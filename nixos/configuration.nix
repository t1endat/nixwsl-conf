{ pkgs, inputs, ... }: {
  environment = {
    sessionVariables = {
      # source: https://github.com/vimjoyer/nix-helper-video?tab=readme-ov-file#defining-flake
      FLAKE = "/home/nixos/nixwsl-conf";
    };
    # List packages installed in system profile. To search, run:
    # $ nix search wget
    systemPackages = with pkgs; [ 
      vim 
      wget 
      curl 
      inputs.home-manager.packages.${pkgs.system}.default
    ];
  };

  nix.settings = {
    # Enable flakes and new 'nix' command
    experimental-features = "nix-command flakes";
    # Deduplicate and optimize nix store
    auto-optimise-store = true;
  };
}
