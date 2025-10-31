{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    # lsps
    clang
    clang-tools
    rust-analyzer
    vscode-langservers-extracted
    typescript-language-server
    emmet-language-server
    basedpyright
    nixd
    lua-language-server
    yaml-language-server

    # formatters
    rustfmt
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
    vscode-extensions.vadimcn.vscode-lldb

    # other tools
    ghidra
    gemini-cli
  ];

  home.sessionPath = [
    "${pkgs.vscode-extensions.vadimcn.vscode-lldb}/share/vscode/extensions/vadimcn.vscode-lldb/adapter"
  ];
}
