{ config, pkgs, inputs, ... }:

{
  imports = [
    ../../modules/home-manager/hyprland.nix
  ];
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "ray";
  home.homeDirectory = "/home/ray";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.11"; # Please read the comment before changing.


  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    neovim
    hyprland
    hyprpaper
    waybar
    rofi-wayland
    kitty
    ghostty
    fzf
    ripgrep
    fd
    tmux
    zoxide
    eza
    lazygit
    delta
    bat
    unzip
    yazi
    imagemagick
    ghostscript
    pandoc
    ffmpeg
    sqlite
    pywal
    wl-clipboard
    xclip
    copyq
    jq
    inputs.zen-browser.packages.${pkgs.system}.default

    nerd-fonts.fira-code
    nerd-fonts.droid-sans-mono
    nerd-fonts.code-new-roman
    nerd-fonts.jetbrains-mono
  	noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji
    fira-code
    jetbrains-mono
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/ray/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    EDITOR = "nvim";
  };

  programs.home-manager.enable = true;

  home.pointerCursor = {
    gtk.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 20;
  };

  gtk = {
    enable = true;
    theme = {
      name = "Graphite-Dark";
      package = pkgs.graphite-gtk-theme;
    };

    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };

    cursorTheme = {
      name = "Bibata-Modern-Classic";
      package = pkgs.bibata-cursors;
      size = 20;
    };
  };

  programs.git = {
    enable = true;
    userName = "Ray7K";
    userEmail = "173786719+Ray7K@users.noreply.github.com";
  };

}
