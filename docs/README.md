# BattleOfRunteq ドキュメント

## 📚 概要
BattleOfRunteq の**ローカル開発環境**とClaude Code + Gemini CLI 連携システムに関する包括的なドキュメント集です。

## 🏠 ローカル開発環境セットアップ

### 🔧 必要な環境
- **Docker & Docker Compose**: コンテナ環境でのRails開発
- **Claude Code CLI**: ローカルでの分析・計画立案ツール
- **Gemini CLI**: 大規模実装・コード生成ツール
- **Google API Key**: Gemini CLI使用のため

### 🚀 開発環境起動手順

#### 1. Docker環境の起動
```bash
# プロジェクトルートで実行
docker-compose up

# バックグラウンド実行の場合
docker-compose up -d
```

#### 2. データベースセットアップ（初回のみ）
```bash
# データベース作成・マイグレーション
docker-compose exec web rails db:create
docker-compose exec web rails db:migrate

# シードデータ投入（オプション）
docker-compose exec web rails db:seed
```

#### 3. 開発サーバーアクセス
- **Rails アプリケーション**: http://localhost:3000
- **PostgreSQL**: localhost:5432

## 🤖 AI連携開発システム

### 📖 Claude-Gemini自律連携フロー

CLAUDE.mdで詳細設計された連携システム：

1. **Claude Code (ローカル)**: 分析・計画立案 → 検証・統合・最適化
2. **Gemini CLI**: 大規模実装・コード生成
3. **ユーザー**: 要件定義・最終判断

### 🔄 開発ワークフロー例

#### Phase 1: 分析・計画 (Claude Code)
```bash
# ローカルでClaude Codeを起動
claude_code

# 要件分析・実装計画立案
# → Gemini向けの詳細実装指示を作成
```

#### Phase 2: 実装 (Gemini CLI)
```bash
# Gemini CLIで実装実行
gemini -p "BattleOfRunteqプロジェクトで以下の計画で実装してください:

タスク: [具体的なタスク説明]
実装手順:
1. [詳細ステップ1]
2. [詳細ステップ2]

技術要件:
- Rails 8 + PostgreSQL + Bootstrap対応
- RSpec テスト実装必須
- セキュリティ考慮
- 初学者理解しやすい日本語コメント

対象ファイル: [作成・修正ファイルリスト]"
```

#### Phase 3: 検証・統合 (Claude Code)
```bash
# 実装結果の品質検証
claude_code

# コードレビュー・改善指摘
# → LGTM達成まで改善ループ継続
```

## 📖 ドキュメント一覧

### 🔧 開発環境・設定
- **[CLAUDE.md](../CLAUDE.md)** - Claude-Gemini自律連携システムの詳細仕様
- **[Docker設定](../docker-compose.yml)** - Rails + PostgreSQL開発環境
- **[AI連携ガイド](./AI_SYSTEM_GUIDE.md)** - AI開発システムの活用法

### 🚀 開発ワークフロー
- **[ディレクトリ構造ガイド](./DIRECTORY_STRUCTURE_GUIDE.md)** - プロジェクト構造の理解
- **[GitHub統合](./GITHUB_INTEGRATION.md)** - バージョン管理・協業手順

### 🧪 テスト・品質管理
- **[統合テスト手順](./INTEGRATION_TEST.md)** - 機能テスト・品質確認
- **RSpecテスト**: `bundle exec rspec`
- **Lint・コード品質**: `bundle exec rubocop`

## 🎯 目的別クイックガイド

### 🏗️ 初回セットアップ時
1. **Docker環境構築**: `docker-compose up`
2. **データベース初期化**: `rails db:create db:migrate`
3. **AI連携準備**: Claude Code + Gemini CLI設定
4. **[CLAUDE.md](../CLAUDE.md)読了**: 連携システム理解

### 💻 日常的な開発時
1. **開発サーバー起動**: `docker-compose up`
2. **Claude分析**: 要件・計画立案
3. **Gemini実装**: コード生成・テスト作成
4. **Claude検証**: 品質確認・統合

### 🛠️ 新機能開発時
1. **ブランチ作成**: `git checkout -b feature/機能名`
2. **AI連携開発**: Claude → Gemini → Claude
3. **テスト実行**: `docker-compose exec web bundle exec rspec`
4. **PR作成**: レビュー・マージ

### 🚨 トラブル発生時
- **Docker関連**: `docker-compose down && docker-compose up`
- **データベース**: `docker-compose exec web rails db:reset`
- **Gemの依存関係**: `docker-compose exec web bundle install`
- **AI連携エラー**: [CLAUDE.md](../CLAUDE.md)のトラブルシューティング参照

## 🔧 コマンドリファレンス

### Docker操作
```bash
# 開発環境起動
docker-compose up

# コンテナ内でコマンド実行
docker-compose exec web [コマンド]

# ログ確認
docker-compose logs web

# 環境停止・削除
docker-compose down
```

### Rails操作
```bash
# データベース操作
docker-compose exec web rails db:create
docker-compose exec web rails db:migrate
docker-compose exec web rails db:seed

# テスト実行
docker-compose exec web bundle exec rspec

# コード品質チェック
docker-compose exec web bundle exec rubocop

# Rails console
docker-compose exec web rails console
```

### AI連携開発
```bash
# ローカルClaude Code起動
claude_code

# Gemini CLI実行例
gemini -p "Rails 8でイベント管理機能を実装したい。最適なアプローチは？"

# コードレビュー依頼
gemini -p "以下のRailsコードをレビューしてください: [コード内容]"
```

## 📞 サポート・質問

### 🤖 AI連携について
- **CLAUDE.md**: 詳細な連携システム仕様
- **Gemini活用例**: CLAUDE.mdの実例集参照
- **効果的な質問**: 具体的で明確な要求を

### 🔧 技術的な問題
- **Docker**: ログ確認 (`docker-compose logs`)
- **Rails**: エラーログ確認 (`log/development.log`)
- **データベース**: 接続確認 (`rails db:migrate:status`)

## 💡 開発のコツ

### 🎓 初学者向けガイドライン
- **MVCパターン重視**: 理解しやすいシンプル設計
- **段階的学習**: 小さな機能から始める
- **AI活用**: 疑問点は積極的にGeminiで確認
- **テスト習慣**: 重要機能はRSpecでテスト

### 🚀 効率的な開発フロー
- **計画重視**: Claude分析で事前設計
- **実装集中**: Gemini活用で高速開発
- **品質保証**: Claude検証で安定性確保
- **継続改善**: 小さなイテレーションで進歩

## 🔄 ドキュメント更新履歴

| 日付 | 更新内容 | 担当 |
|------|----------|------|
| 2025-07-02 | ローカル開発環境対応・Claude-Gemini連携システム統合 | Claude |
| 2025-06-27 | 初回作成・Claude Code Action統合ドキュメント | Claude |

---

**BattleOfRunteq** - 初学者向けイベント管理システム  
ローカルClaude Code + Gemini CLI連携により、コスト効率的なAI支援開発環境を実現