# BattleOfRunteq

初学者向けのイベント管理システムです。
プログラミング学習における実践的なWebアプリケーション開発を目的として設計されており、
Claude Code と Gemini CLI の自律連携システムによる AI ペアプログラミングの実証実験プロジェクトでもあります。

## 技術スタック
- **フレームワーク**: Ruby on Rails 8.x
- **言語**: Ruby 3.3.0
- **データベース**: PostgreSQL
- **認証**: Devise
- **UI**: Bootstrap 5.2
- **テスト**: RSpec
- **開発環境**: Docker
- **AI連携**: Claude Code + Gemini CLI

## 開発環境構築

### 前提条件
- Docker
- Docker Compose

### セットアップ
```bash
# リポジトリクローン
git clone https://github.com/Bohemian1506/BattleOfRunteq.git
cd BattleOfRunteq

# 開発環境起動
docker-compose up
```

### テスト実行
```bash
bundle exec rspec
```

### Lint・コード品質チェック
```bash
bundle exec rubocop
```

## PR自動作成設定

**Claude Codeが自動でPR文章を生成します**

### 自動PR作成コマンド
```bash
# Claude Codeが実行
gh pr create --title "[機能名]" --body "$(cat <<'EOF'
# 概要

[コミットメッセージから自動生成される概要]

Notion: [必要に応じてユーザーが追加]
Figma: [必要に応じてユーザーが追加]

# 細かな変更点

[変更されたファイルと内容を自動列挙]
- [ファイル1]: [変更内容]
- [ファイル2]: [変更内容]

## スクリーンショット

|       | Before | After |
| :---: | :----: | :---: |
| [必要に応じてユーザーが追加] |  |  |

# 影響範囲・懸念点

[技術的な影響範囲を自動分析]

# おこなった動作確認

[基本的な動作確認項目を自動生成]
* [ ] 基本機能の動作確認
* [ ] テストケースの実行
* [ ] エラーハンドリングの確認
* [ ] [その他、機能に応じた確認項目]

# その他

🤖 Generated with [Claude Code](https://claude.ai/code)
EOF
)"
```

### ユーザー補足事項

Claude Code生成後、必要に応じて以下を追加：
- **Notion/Figma URL**: タスク・デザインのリンク
- **スクリーンショット**: UI変更のBefore/After画像
- **特記事項**: レビュアーへの特別なメッセージ

### 自動生成される内容

- **概要**: コミットメッセージから抽出
- **変更点**: git diffから自動分析
- **影響範囲**: 変更ファイルから技術的影響を推定
- **動作確認**: 機能に応じた基本チェック項目

**重要**: Claude Codeが基本構造を自動生成するため、手動でのテンプレート記入は不要です。

## プロジェクト構造
- `app/controllers/` - MVCのController層
- `app/models/` - データモデル
- `app/views/` - UI・テンプレート
- `spec/` - RSpecテストファイル
- `db/migrate/` - データベースマイグレーション

## 学習目標
1. Rails MVCパターンの理解
2. RESTful APIの実装
3. 認証・認可の実装
4. データベース設計の基礎
5. テスト駆動開発の実践

## 開発方針

### 初学者向けのシンプル設計
- MVCパターンの基本を重視
- 複雑な設計パターンよりも理解しやすさを優先
- 段階的な機能追加により学習効果を最大化
- 明確なコメントと分かりやすい変数名を使用

### セキュリティ
- DeviseによるSecure By Default認証
- Strong Parametersの徹底
- CSRFトークンの適切な使用
- SQLインジェクション対策

### テスト戦略
- RSpecによる基本的なテストカバレッジ
- Factory Botを使った効率的なテストデータ作成
- 重要な機能における統合テストの実装
