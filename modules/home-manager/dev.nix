{ config, pkgs, ... }:

{
  home.packages =
    with pkgs;
    [
      # toolchains and compilers
      llvmPackages.llvm
      llvmPackages.clang-tools
      llvmPackages.clang
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
      texlab
      marksman

      # formatters
      prettierd
      black
      isort
      nixfmt
      stylua
      tex-fmt

      # linters
      eslint_d
      markdownlint-cli

      # debuggers
      lldb
      delve
      vscode-extensions.vadimcn.vscode-lldb

      # other tools
      (lib.hiPrio tree-sitter)
      ghidra
      antigravity-cli
      codex
      texliveFull
      hyperfine
      mermaid-cli
      ghostscript
    ]
    ++ lib.optionals pkgs.stdenv.isLinux [
      # runtimes and package managers
      python3

      # debuggers
      gdb
      gef

      # other tools
      wireshark
      valgrind
      perf
      flamegraph
      zathura
      chromium
    ];

  home.sessionPath = [
    "${config.home.homeDirectory}/.local/bin"
    "${config.home.homeDirectory}/.local/scripts"
    "${config.home.homeDirectory}/.cargo/bin"
    "${pkgs.vscode-extensions.vadimcn.vscode-lldb}/share/vscode/extensions/vadimcn.vscode-lldb/adapter"
  ];
}
