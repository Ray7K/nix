{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    # lsps
    clang
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
    vscode-extensions.vadimcn.vscode-lldb

    # other tools
    gemini-cli
  ];

  home.sessionPath = [
    "${pkgs.vscode-extensions.vadimcn.vscode-lldb}/share/vscode/extensions/vadimcn.vscode-lldb/adapter"
  ];
}
