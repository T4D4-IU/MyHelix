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
    # PC向け（通常）設定
    # ---------------------------------------------------------
    settings = {
      theme = "catppuccin_mocha";
      editor = {
        line-number = "relative";
        cursorline = true;
        color-modes = true;
        bufferline = "multiple";
        lsp.display-messages = true;
      };
    };

    # 各種言語のLSPやフォーマッターを自動インストールする場合はここに追加
    extraPackages = with pkgs; [
      nil # Nix LSP
      nodePackages.typescript-language-server
      nodePackages.vscode-langservers-extracted
      rust-analyzer
    ];
  };

  # ---------------------------------------------------------
  # スマホ向け（省スペース）設定ファイルを手動生成
  # ---------------------------------------------------------
  xdg.configFile."helix/config-mobile.toml".text = ''
    theme = "catppuccin_mocha"
    
    [editor]
    # 行番号を消して横幅を確保
    line-number = "none"
    
    # ガター（左側の余白）を最小限にする
    gutters = ["diagnostics"]
    
    # バッファライン（上部のタブバー）を消して縦幅を確保
    bufferline = "never"
    
    cursorline = true
    color-modes = true
    
    [editor.statusline]
    # ステータスラインも必要最小限に
    left = ["mode", "spinner", "file-name"]
    center = []
    right = ["diagnostics", "selections", "position"]
  '';

  # 起動用スクリプトをパスに追加
  home.packages = [ myhx-mobile ];
}
