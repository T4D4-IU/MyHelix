{ pkgs, config, ... }:

let
  myhx-mobile = pkgs.writeShellScriptBin "myhx-mobile" ''
    #!/usr/bin/env bash
    # スマホ向けに省スペース設定のHelixを起動するスクリプト
    exec hx -c ''${XDG_CONFIG_HOME:-$HOME/.config}/helix/config-mobile.toml "$@"
  '';
in
{
  programs.helix = {
    enable = true;
    defaultEditor = true;
    
    # ---------------------------------------------------------
    # PC向け（通常）設定 - 外部TOMLから読み込み
    # ---------------------------------------------------------
    settings = pkgs.lib.importTOML ../config/helix/config.toml;

    # 各種言語のLSPやフォーマッターを自動インストールする場合はここに追加
    extraPackages = with pkgs; [
      nil # Nix LSP
      nodePackages.typescript-language-server
      nodePackages.vscode-langservers-extracted
      rust-analyzer
    ];
  };

  # ---------------------------------------------------------
  # スマホ向け（省スペース）設定ファイルを手動生成 - 外部TOMLから読み込み
  # ---------------------------------------------------------
  xdg.configFile."helix/config-mobile.toml".text = builtins.readFile ../config/helix/config-mobile.toml;

  # 起動用スクリプトをパスに追加
  home.packages = [ myhx-mobile ];
}

