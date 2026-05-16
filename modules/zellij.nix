{ pkgs, ... }:

let
  mzj-mobile = pkgs.writeShellScriptBin "mzj-mobile" ''
    #!/usr/bin/env bash
    # スマホ向けに省スペース設定のZellijを起動するスクリプト
    # --layout compact で下部のヘルプバーを消し、枠線も消します
    
    # 枠線を消す環境変数（Zellijの設定を一時的にオーバーライド可能）
    export ZELLIJ_CONFIG_DIR="''${XDG_CONFIG_HOME:-$HOME/.config}/zellij"
    
    # Zellij本体を起動
    exec zellij --layout compact "$@"
  '';
in
{
  programs.zellij = {
    enable = true;
  };

  # ---------------------------------------------------------
  # 既存の個人設定を取り込み
  # ---------------------------------------------------------
  xdg.configFile."zellij/config.kdl".source = ../config/zellij/config.kdl;

  # 必要に応じてスマホ専用のZellijレイアウトを定義（内蔵のcompactレイアウトに枠線なし設定を追加したもの）
  xdg.configFile."zellij/layouts/compact.kdl".text = builtins.readFile ../config/zellij/layouts/compact.kdl;

  # 起動用スクリプトをパスに追加
  home.packages = [ mzj-mobile ];
}

