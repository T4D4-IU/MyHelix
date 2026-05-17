# MyHelix

Helix と Zellij を組み合わせた、ポータブルで強力な開発環境（ターミナル IDE）の設定リポジトリです。
Nix（Home Manager / `nix run`）による管理だけでなく、Nix が入っていない一般の環境（macOS, Linux）でも設定を簡単に共有・適用できるように「設定ファイル一元管理」構成を採用しています。

---

## 📂 ディレクトリ構成

```text
MyHelix/
├── flake.nix             # Flake定義 (nix run や Home Managerモジュール)
├── config/               # 共通設定ファイル (唯一の正史・Source of Truth)
│   ├── helix/
│   │   ├── config.toml   # PC向け通常設定 (相対行番号、テーマ等)
│   │   └── config-mobile.toml # モバイル向け省スペース設定
│   └── zellij/
│       ├── config.kdl    # Zellij共通設定
│       └── layouts/
│           └── compact.kdl # モバイル用コンパクトレイアウト
├── modules/              # Home Manager モジュール定義 (config配下を自動読み込み)
│   ├── helix.nix
│   └── zellij.nix
├── scripts/
│   └── setup.sh          # 非Nix環境向けの自動シンボリックリンク生成スクリプト
└── docs/
    └── changed_log.md    # 変更履歴ログ
```

---

## 🚀 使い方

用途や環境に合わせて以下の 3 つの方法から選択して利用できます。

### 方法 1: `nix run .`（Nix環境で単体・一時的に起動する）
設定のインストールを行わず、本リポジトリの設定を適用した Zellij + Helix 環境をコマンド一つで一時的に立ち上げます。
既存の `~/.config/helix` や `~/.config/zellij` などの設定を汚すことはありません。

```bash
# MyHelixディレクトリ内で実行
nix run .
```

---

### 方法 2: Home Manager モジュールとして統合する
ご自身の Nix 設定（`dotfiles` など）にインポートして、システムに恒久的に適用します。

1. ご自身の `flake.nix` の `inputs` に `MyHelix` を追加します。
   ```nix
   inputs.myhelix.url = "git+file:///path/to/MyHelix"; # またはGitHubのURL
   ```
2. Home Manager 設定の `imports` にモジュールを追加します。
   ```nix
   imports = [
     inputs.myhelix.homeManagerModules.default
   ];
   ```

---

### 方法 3: `scripts/setup.sh`（Nixが使えない環境・会社PCなど）
会社用PCなど、Nix がインストールできない環境でも、すでにある `helix` や `zellij` のインストールに対してこの設定を適用します。

1. 事前に [Helix (公式インストールガイド)](https://docs.helix-editor.com/install.html) と [Zellij (公式サイト)](https://zellij.dev/) をインストールしておきます。
   - macOS の場合は `Homebrew` で簡単にインストール可能です。
     ```bash
     brew install helix zellij
     ```

2. 本リポジトリ内でセットアップスクリプトを実行します。
   ```bash
   ./scripts/setup.sh
   ```
   * ※ 既存の `~/.config/helix/config.toml` や `~/.config/zellij/config.kdl` がすでに存在する場合は、上書き防止のためスキップされます。


---

## 📱 モバイル（スマホ・Termux等）向け省スペース起動について
画面サイズが限られるスマートフォンやタブレットなどの環境向けに、画面スペースを最大限活用できる設定と起動スクリプトを用意しています。

### モバイル用 Helix
- **起動コマンド**: `myhx-mobile`
- **特徴**: 行番号 (`line-number`) を非表示にし、上部タブバー (`bufferline`) を消して画面の縦横スペースを広げます。

### モバイル用 Zellij
- **起動コマンド**: `mzj-mobile`
- **特徴**: 下部のヘルプバーやペインの枠線 (`borderless`) を消し、コンテンツ領域を最大化します。
