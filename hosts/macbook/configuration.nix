{
  pkgs,
  config,
  inputs,
  ...
}:

{
  nix.gc = {
    automatic = true;
    interval = {
      Weekday = 0;
      Hour = 19;
      Minute = 0;
    };
    options = "--delete-older-than 30d";
  };
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    wget
    mkalias
    libiconv
    man-db
  ];

  environment.variables = {
  };

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
  ];

  # Necessary for using flakes on this system.
  nix.settings.experimental-features = "nix-command flakes";

  nixpkgs.config.allowUnfree = true;

  security.pam.services.sudo_local.touchIdAuth = true;
  security.pam.services.sudo_local.reattach = true;

  homebrew = {
    enable = true;
    brews = [
      "imagemagick"
      "python3"
      "llvm"
      "wireshark"
    ];
    casks = [
      "iina"
      "karabiner-elements"
      "aerospace"
      "leader-key"
      "firefox"
      "ghostty"
      "whatsapp"
      "google-chrome"
      "todoist-app"
      "zen"
      "yellowdot"
      "jordanbaird-ice"
      "keepassxc"
      "calibre"
      "wireshark-app"
      "skim"
    ];

    taps = [
      {
        name = "nikitabobko/homebrew-tap";
      }
    ];

    onActivation.cleanup = "zap";
    onActivation.upgrade = true;
    onActivation.autoUpdate = true;
  };

  # Enable alternative shell support in nix-darwin.
  # programs.fish.enable = true;

  # Set Git commit hash for darwin-version.
  # system.configurationRevision = self.rev or self.dirtyRev or null;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 5;

  system.defaults.NSGlobalDomain.InitialKeyRepeat = 15;
  system.defaults.NSGlobalDomain.KeyRepeat = 2;

  system.primaryUser = "raiyankataria";

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";

  users.users.raiyankataria.home = "/Users/raiyankataria";
  users.users.raiyankataria.shell = pkgs.zsh;

  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    useGlobalPkgs = true;
    useUserPackages = true;
    users.raiyankataria = import ./home.nix;
  };

  system.activationScripts.applications.text =
    let
      env = pkgs.buildEnv {
        name = "system-applications";
        paths = config.environment.systemPackages;
        pathsToLink = [ "/Applications" ];
      };
    in
    pkgs.lib.mkForce ''
      # Set up applications.
      echo "setting up /Applications..." >&2
      rm -rf /Applications/Nix\ Apps
      mkdir -p /Applications/Nix\ Apps
      find ${env}/Applications -maxdepth 1 -type l -exec readlink '{}' + |
      while read -r src; do
        app_name=$(basename "$src")
        echo "copying $src" >&2
        ${pkgs.mkalias}/bin/mkalias "$src" "/Applications/Nix Apps/$app_name"
      done
    '';
}
