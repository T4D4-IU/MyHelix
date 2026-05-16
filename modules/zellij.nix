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
    
    # ---------------------------------------------------------
    # PC向け（通常）設定
    # ---------------------------------------------------------
    settings = {
      default_layout = "default";
      pane_frames = true; # 枠線あり
    };
  };

  # 必要に応じてスマホ専用のZellijレイアウトを定義（内蔵のcompactレイアウトに枠線なし設定を追加したもの）
  xdg.configFile."zellij/layouts/compact.kdl".text = ''
    layout {
        pane size=1 borderless=true {
            plugin location="zellij:compact-bar"
        }
        pane borderless=true
    }
  '';

  # 起動用スクリプトをパスに追加
  home.packages = [ mzj-mobile ];
}
