{ config, pkgs, ... }:

{
  imports = [
  ];
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "raiyankataria";
  home.homeDirectory = "/Users/raiyankataria";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.11"; # Please read the comment before changing.

  home.sessionPath = [
    "${config.home.homeDirectory}/.local/bin"
    "${config.home.homeDirectory}/.local/scripts"
    "${config.home.homeDirectory}/.cargo/bin"
  ];

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    vim
    neovim
    tmux
    bat
    ripgrep
    btop
    htop
    fastfetch
    fd
    delta
    lazygit
    yazi

    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  home.shell.enableZshIntegration = true;

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    autosuggestion.enable = true;

    shellAliases = {
      ls = "eza";
    };

    initContent =
      ''
        BLOCK='\e[2 q'
        BEAM='\e[6 q'

        function zle-line-init zle-keymap-select {
          if [[ $KEYMAP == vicmd ]] || [[ $1 = 'block' ]]; then
            echo -ne $BLOCK
          elif [[ $KEYMAP == main ]] || [[ $KEYMAP == viins ]] ||
               [[ $KEYMAP = '''''' ]] || [[ $1 = 'beam' ]]; then
            echo -ne $BEAM
          fi
        }

        export KEYTIMEOUT=1

        zle -N zle-line-init
        zle -N zle-keymap-select

        bindkey -v
        bindkey -s ^f "tmux-sessionizer\n"
        bindkey -M vicmd '^e' edit-command-line

        bindkey '^H' backward-delete-char  # Backspace (often ^H) key
        bindkey '^?' backward-delete-char  # For some terminals, backspace sends ^?

        autoload -Uz add-zle-hook-widget
        add-zle-hook-widget line-init vi-cmd-mode
        '';
  };

  # programs.ghostty = {
  #   enable = true;
  #   enableZshIntegration = true;
  # };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.eza = {
    enable = true;
    git = true;
    icons = "auto";
    theme = "tokyonight";
  };

  programs.oh-my-posh = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      schema = "https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/schema.json";

      # Palette
      palette = {
        blue = "#7aa2f7";
        closer = "p:os";
        cyan = "#b4f9f8";
        green = "#c3e88d";
        os = "#a9b1d6";
      };

      # Secondary Prompt
      secondary_prompt = {
        template = "❯❯ ";
        foreground = "#c0cef5";
        background = "transparent";
      };

      # Transient Prompt
      transient_prompt = {
        template = "❯ ";
        background = "transparent";
        foreground_templates = [
          "{{if gt .Code 0}}#cfcef5{{end}}"
          "{{if eq .Code 0}}#c0cef5{{end}}"
        ];
      };

      # Console Title Template
      console_title_template = "{{ .Shell }} in {{ .Folder }}";

      # Blocks (you may want to change this structure if it becomes more complex)
      blocks = [
        {
          type = "prompt";
          alignment = "left";
          segments = [
            {
              properties = {
                cache_duration = "none";
              };
              template = "{{.Icon}} ";
              foreground = "p:os";
              type = "os";
              style = "plain";
            }
            {
              properties = {
                cache_duration = "none";
              };
              template = "{{ .UserName }}@{{ .HostName }} ";
              foreground = "p:blue";
              type = "session";
              style = "plain";
            }
            {
              properties = {
                cache_duration = "none";
                folder_icon = "  ";
                home_icon = "~";
                style = "agnoster_short";
                max_depth = 2;
              };
              template = "{{ .Path }} ";
              foreground = "p:cyan";
              type = "path";
              style = "plain";
            }
            {
              properties = {
                cache_duration = "none";
                branch_icon = "  ";
                cherry_pick_icon = "  ";
                commit_icon = "  ";
                fetch_status = true;
                fetch_upstream_icon = true;
                merge_icon = "  ";
                no_commits_icon = "  ";
                rebase_icon = "  ";
                revert_icon = "  ";
                tag_icon = "  ";
              };
              template = "{{ .HEAD }}{{if .BranchStatus }} {{ .BranchStatus }}{{ end }}{{ if .Working.Changed }}   {{ .Working.String }}{{ end }}{{ if and (.Staging.Changed) (.Working.Changed) }} |{{ end }}{{ if .Staging.Changed }}   {{ .Staging.String }}{{ end }}";
              foreground = "p:green";
              type = "git";
              style = "plain";
            }
          ];
          newline = true;
        }
        {
          type = "rprompt";
          overflow = "#6fb9e3";
          segments = [
            {
              properties = {
                cache_duration = "none";
                threshold = 2500;
              };
              template = "{{ .FormattedMs }}";
              foreground = "#cde4fa";
              background = "transparent";
              type = "executiontime";
              style = "plain";
            }
          ];
        }
        {
          type = "prompt";
          alignment = "left";
          segments = [
            {
              properties = {
                cache_duration = "none";
              };
              template = "❯";
              background = "transparent";
              type = "text";
              style = "plain";
              foreground_templates = [
                "{{if gt .Code 0}}#cfcef5{{end}}"
                "{{if eq .Code 0}}#c0cef5{{end}}"
              ];
            }
          ];
          newline = true;
        }
      ];

      version = 3;
      final_space = true;
    };
  };

  programs.fastfetch.enable = true;
  programs.fd.enable = true;
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

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.git = {
    enable = true;
    userName = "Ray7K";
    userEmail = "173786719+Ray7K@users.noreply.github.com";
  };
}
