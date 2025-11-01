{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    # toolchains and compilers
    clang
    clang-tools
    llvmPackages.llvm
    rustup
    zig
    go

    # runtimes and package managers
    python3
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
    gdb
    lldb
    gef
    delve
    vscode-extensions.vadimcn.vscode-lldb

    # other tools
    ghidra
    gemini-cli
  ];

  home.sessionPath = [
    "${pkgs.vscode-extensions.vadimcn.vscode-lldb}/share/vscode/extensions/vadimcn.vscode-lldb/adapter"
  ];
}
