# 🚀 {{FEATURE_NAME}}実装依頼

**生成日時**: {{DATE}}  
**プロジェクト**: {{PROJECT_INFO}}

## 🎯 実装タスク
BattleOfRunteqプロジェクトで「{{FEATURE_NAME}}」を実装してください。

## 📋 詳細実装手順

### 1. お問い合わせモデル作成
- **ファイル**: `app/models/contact.rb`
- **マイグレーション**: `db/migrate/[timestamp]_create_contacts.rb`
- **フィールド**: 
  - `name:string` (お名前、必須)
  - `email:string` (メールアドレス、必須)
  - `phone:string` (電話番号、任意)
  - `subject:string` (件名、必須)
  - `message:text` (お問い合わせ内容、必須)
  - `category:string` (カテゴリ、必須)
  - `status:string` (対応状況: 'pending', 'in_progress', 'resolved')
  - `ip_address:string` (送信者IP、スパム対策用)
  - `user_agent:string` (ブラウザ情報)
  - `user:references` (ログインユーザーの場合の関連付け、任意)
- **バリデーション**: 
  - name必須、長さ制限（1-50文字）
  - email必須、メール形式チェック
  - subject必須、長さ制限（1-100文字）
  - message必須、長さ制限（10-2000文字）
  - categoryの値制限

### 2. カテゴリ管理
- **定数定義**: お問い合わせカテゴリの管理
```ruby
CATEGORIES = [
  ['一般的なお問い合わせ', 'general'],
  ['イベントについて', 'event'],
  ['技術的な問題', 'technical'],
  ['アカウント・ログイン', 'account'],
  ['要望・提案', 'suggestion'],
  ['その他', 'other']
].freeze
```

### 3. ContactsController実装
- **ファイル**: `app/controllers/contacts_controller.rb`
- **アクション**:
  - `new` (お問い合わせフォーム表示)
  - `create` (お問い合わせ送信処理)
  - `show` (送信完了ページ、確認番号表示)
  - `index` (管理者用: お問い合わせ一覧)
  - `update` (管理者用: ステータス更新)
- **認証**: newとcreateは認証不要、管理機能は管理者のみ
- **スパム対策**: reCAPTCHA統合、レート制限

### 4. フォームの高度な機能
- **リアルタイムバリデーション**: JavaScriptでの即座なフィードバック
- **自動保存**: フォーム入力中の一時保存機能
- **ファイル添付**: Active Storageでの画像・ファイル添付対応
- **確認画面**: 送信前の内容確認ステップ

### 5. 通知・メール機能
- **ContactMailer実装**: `app/mailers/contact_mailer.rb`
- **メールテンプレート**:
  - 送信者への自動返信メール
  - 管理者への通知メール
- **メール配信**: Action Mailerでの非同期処理
- **テンプレート**: HTMLとテキスト両対応

### 6. 管理機能
- **AdminController**: `app/controllers/admin/contacts_controller.rb`
- **管理者認証**: 管理者ロール制御
- **お問い合わせ管理**:
  - 一覧表示（ページネーション、検索、絞り込み）
  - 詳細表示
  - ステータス変更
  - 返信機能
  - CSVエクスポート

### 7. ビューファイル作成
- **Bootstrap 5.2対応レスポンシブデザイン**
- **app/views/contacts/**:
  - `new.html.erb` (お問い合わせフォーム)
  - `show.html.erb` (送信完了ページ)
  - `_form.html.erb` (フォームパーシャル)
- **app/views/admin/contacts/**:
  - `index.html.erb` (管理者用一覧)
  - `show.html.erb` (管理者用詳細)
- **メールテンプレート**:
  - `app/views/contact_mailer/` (各種メールテンプレート)

### 8. ルーティング設定
- **config/routes.rb**:
```ruby
resources :contacts, only: [:new, :create, :show]

namespace :admin do
  resources :contacts, only: [:index, :show, :update]
end
```

## 🔧 技術要件

### 基本要件
- **Rails 8 + PostgreSQL + Bootstrap 5.2対応**
- **MVCパターン準拠、初学者理解しやすい実装**
- **日本語コメント必須**（コードの意図と動作を説明）
- **Strong Parameters使用**（セキュリティ考慮）
- **RSpec テスト実装必須**

### フォーム特有の要件
- **スパム対策**: reCAPTCHA、レート制限、IPブロック機能
- **ユーザビリティ**: 分かりやすいエラーメッセージ、入力支援
- **メール送信**: 確実な配信と適切なテンプレート
- **管理機能**: 効率的なお問い合わせ処理
- **セキュリティ**: CSRF対策、XSS対策

### セキュリティ要件
- **スパム対策**: 複数層のスパム防止機能
- **入力検証**: 悪意のある入力に対する防御
- **レート制限**: 大量送信の防止
- **ファイルアップロード**: 安全なファイル処理

## 📁 対象ファイル

### 新規作成
- `app/models/contact.rb`
- `app/controllers/contacts_controller.rb`
- `app/controllers/admin/contacts_controller.rb`
- `app/mailers/contact_mailer.rb`
- `app/views/contacts/` (全ビューファイル)
- `app/views/admin/contacts/` (管理者用ビュー)
- `app/views/contact_mailer/` (メールテンプレート)
- `db/migrate/[timestamp]_create_contacts.rb`
- `spec/models/contact_spec.rb`
- `spec/requests/contacts_spec.rb`
- `spec/mailers/contact_mailer_spec.rb`

### 修正
- `config/routes.rb` (ルーティング追加)
- `app/models/user.rb` (お問い合わせとの関連付け)
- `config/application.rb` (メール設定)

## 📝 実装時の注意点

### フォーム設計の考慮事項
1. **ユーザビリティ**: 入力しやすく、分かりやすいフォーム
2. **バリデーション**: リアルタイムフィードバックと適切なエラーメッセージ
3. **アクセシビリティ**: スクリーンリーダー対応、キーボード操作
4. **モバイル対応**: スマートフォンでの入力しやすさ

### スパム対策
1. **reCAPTCHA**: Google reCAPTCHA v3の統合
2. **レート制限**: 同一IPからの連続送信制限
3. **ハニーポット**: 見えないフィールドでbot検出
4. **内容チェック**: 不適切な内容の自動検出

### メール処理
1. **配信確実性**: バックグラウンドジョブでの非同期処理
2. **テンプレート**: 分かりやすく親しみやすいメール文面
3. **エラーハンドリング**: メール送信失敗時の適切な処理
4. **ログ**: 送信履歴の適切な記録

## ✅ 完了基準

### 機能面
- [ ] フォーム送信が正常に動作
- [ ] メール送信が確実に動作
- [ ] スパム対策が機能
- [ ] 管理機能が正常に動作
- [ ] ファイル添付が機能（実装時）

### UI/UX面
- [ ] Bootstrap UIが適切に表示される
- [ ] レスポンシブデザインが機能
- [ ] フォームバリデーションが分かりやすい
- [ ] エラーメッセージが適切

### セキュリティ面
- [ ] CSRF対策が実装済み
- [ ] XSS対策が実装済み
- [ ] スパム対策が複数層で機能
- [ ] レート制限が機能

### 品質面
- [ ] すべてのRSpecテストがパス
- [ ] メールのテストが通る
- [ ] セキュリティチェック完了
- [ ] 初学者向けコメント完備

## 💡 実装のヒント

### よくある課題と対策
1. **メール送信**: 開発環境でのメール確認方法
2. **スパム対策**: 過度にならない適切なバランス
3. **フォーム設計**: ユーザーにとって入力しやすい項目設計
4. **管理機能**: 効率的なお問い合わせ処理フロー

### パフォーマンス最適化
- バックグラウンドジョブでのメール送信
- お問い合わせ一覧のページネーション
- 検索機能の効率化

### 拡張可能性の考慮
- FAQ機能との連携
- チャットボット導入への準備
- 多言語対応
- テンプレート回答機能

この実装指示に基づき、段階的にお問い合わせフォーム機能を実装してください。特に、スパム対策とユーザビリティのバランスを考慮し、十分なテストを行ってください。