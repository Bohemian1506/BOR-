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

# 要件分析・実装計画立案 + Gemini用Issue作成指示
「イベント参加申し込み機能を実装したい。Gemini用のIssue文書も作成してください。」

# → 詳細分析結果 + Gemini向けの実装指示Issue文書を生成
# → claude_generated_issue.md として保存することを推奨
```

#### Phase 2: 実装 (Gemini CLI)
```bash
# Claude生成のIssue文書をGeminiに投入
# オプション1: ファイルから読み込み
gemini -p "$(cat claude_generated_issue.md)"

# オプション2: 直接コピペ
gemini -p "BattleOfRunteqプロジェクトで以下の計画で実装してください:

[Claude生成のIssue文書内容をここにペースト]

例：
🚀 イベント参加申し込み機能実装依頼

📋 実装手順:
1. Eventモデル作成（name, description, start_time, location, capacity）
2. Registrationモデル作成（Event-User中間テーブル、status管理）
3. EventsController・RegistrationsController実装
4. Bootstrap 5.2対応ビュー作成
5. RSpecテスト実装

🔧 技術要件:
- Rails 8 + PostgreSQL + Bootstrap対応
- 初学者理解しやすい日本語コメント
- Strong Parameters使用
- セキュリティ考慮"
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

### 📄 Gemini用Issue文書の具体例

Claude Codeが生成するGemini向け実装指示文書の詳細例：

```markdown
# 🚀 イベント参加申し込み機能実装依頼

## 🎯 実装タスク
BattleOfRunteqプロジェクトでイベント参加申し込み機能を実装してください。

## 📋 詳細実装手順

### 1. Eventモデル作成
- **ファイル**: `app/models/event.rb`
- **フィールド**: 
  - name:string (イベント名、必須)
  - description:text (説明文)
  - start_time:datetime (開始日時、必須)
  - end_time:datetime (終了日時)
  - location:string (開催場所)
  - capacity:integer (定員、正の整数)
  - user:references (主催者、Userモデルとの関連)
- **バリデーション**: name必須、start_time必須、capacity正の整数

### 2. Registrationモデル作成
- **ファイル**: `app/models/registration.rb`
- **概要**: Event-User間の中間テーブル
- **フィールド**:
  - event:references (参加するイベント)
  - user:references (参加者)
  - status:string (申し込み状況: 'pending', 'confirmed', 'cancelled')
  - message:text (申し込み時のメッセージ)
  - created_at:datetime (申し込み日時)
- **バリデーション**: 同一イベントへの重複申し込み防止

### 3. コントローラー実装
- **EventsController**: index, show, new, create, edit, update, destroy
- **RegistrationsController**: create, destroy (申し込み・キャンセル)

### 4. ビュー作成
- Bootstrap 5.2対応のレスポンシブデザイン
- イベント一覧・詳細・作成・編集ページ
- 参加申し込みボタン・フォーム

### 5. ルーティング設定
- RESTfulなネストしたルーティング
- events/:id/registrations の設計

## 🔧 技術要件
- **Rails 8 + PostgreSQL + Bootstrap 5.2対応**
- **MVCパターン準拠、初学者理解しやすい実装**
- **日本語コメント必須**
- **Strong Parameters使用**
- **RSpec テスト実装必須**
- **Devise認証との連携**
- **セキュリティ考慮（CSRF、SQLインジェクション対策）**

## 📁 対象ファイル
- app/models/event.rb
- app/models/registration.rb
- app/models/user.rb (関連付け追加)
- app/controllers/events_controller.rb
- app/controllers/registrations_controller.rb
- app/views/events/
- config/routes.rb
- spec/models/
- spec/requests/
- db/migrate/

## ✅ 完了基準
- [ ] すべてのRSpecテストがパス
- [ ] Bootstrap UIが正常表示
- [ ] セキュリティチェック完了
- [ ] 初学者向けコメント完備
- [ ] Rails規約準拠確認
```

### 💡 ワークフロー効率化のメリット

**従来の方式**:
1. Claude分析 → あなたが手動でGemini指示作成 → Gemini実装

**改善後の方式**:
1. Claude分析+Issue文書生成 → ファイル/コピペでGemini実行

**効果**:
- ⏱️ **時短**: 手動での指示作成が不要
- 🎯 **精度向上**: Claude分析との一貫性保証
- 📚 **学習効果**: 詳細な実装手順で理解促進
- 🔄 **再利用性**: Issue文書は将来の参考資料

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