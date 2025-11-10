{ config, pkgs, ... }:

{
  home.packages =
    with pkgs;
    [
      # toolchains and compilers
      rustup
      zig
      go

      # runtimes and package managers
      nodejs
      bun
      pnpm
      luarocks

      # build helpers
      gnumake
      ninja
      bear
      cmake
      meson

      # lsps
      vscode-langservers-extracted
      typescript-language-server
      emmet-language-server
      basedpyright
      nixd
      gopls
      zls
      lua-language-server
      yaml-language-server
      taplo

      # formatters
      prettierd
      black
      isort
      nixfmt-rfc-style
      stylua

      # linters
      eslint_d

      # debuggers
      lldb
      gdb
      gef
      delve
      vscode-extensions.vadimcn.vscode-lldb

      # other tools
      ghidra
      gemini-cli
    ]
    ++ lib.optionals pkgs.stdenv.isLinux [
      # toolchains and compilers
      llvmPackages.llvm
      llvmPackages.clang-tools
      llvmPackages.clang

      # runtimes and package managers
      python3

      # other tools
      wireshark
      wireshark-cli
    ];

  home.sessionPath = [
    "${config.home.homeDirectory}/.local/bin"
    "${config.home.homeDirectory}/.local/scripts"
    "${config.home.homeDirectory}/.cargo/bin"
    "${pkgs.vscode-extensions.vadimcn.vscode-lldb}/share/vscode/extensions/vadimcn.vscode-lldb/adapter"
  ];
}
