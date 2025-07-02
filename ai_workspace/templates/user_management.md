# 🚀 {{FEATURE_NAME}}実装依頼

**生成日時**: {{DATE}}  
**プロジェクト**: {{PROJECT_INFO}}

## 🎯 実装タスク
BattleOfRunteqプロジェクトで「{{FEATURE_NAME}}」を実装してください。

## 📋 詳細実装手順

### 1. プロフィール機能の拡張
- **既存Userモデルの拡張**: `app/models/user.rb`
- **マイグレーション**: `db/migrate/[timestamp]_add_profile_fields_to_users.rb`
- **追加フィールド**: 
  - `first_name:string` (名)
  - `last_name:string` (姓)
  - `nickname:string` (ニックネーム、一意制約)
  - `bio:text` (自己紹介)
  - `avatar:string` (プロフィール画像URL)
  - `birthday:date` (生年月日)
  - `location:string` (居住地)
  - `website:string` (ウェブサイトURL)
  - `twitter_handle:string` (Twitterハンドル)
  - `github_handle:string` (GitHubハンドル)
  - `public_profile:boolean` (プロフィール公開設定、デフォルト: true)
- **バリデーション**: 
  - nickname一意性、長さ制限（3-20文字）
  - bio長さ制限（500文字以内）
  - URLフォーマット検証
  - Twitter/GitHubハンドル形式チェック

### 2. プロフィール表示・編集機能
- **ProfilesController実装**: `app/controllers/profiles_controller.rb`
- **アクション**:
  - `show` (プロフィール表示、パブリック・プライベート対応)
  - `edit` (プロフィール編集フォーム、本人のみ)
  - `update` (プロフィール更新処理)
- **認証・認可**: 
  - 編集は本人のみ許可
  - 公開プロフィールは未ログインユーザーも閲覧可能

### 3. ユーザー一覧・検索機能
- **UsersController実装**: `app/controllers/users_controller.rb`
- **アクション**:
  - `index` (ユーザー一覧、検索・絞り込み機能)
  - `show` (ユーザー詳細、プロフィールへのリダイレクト)
- **検索機能**:
  - ニックネーム・名前での検索
  - 居住地での絞り込み
  - 新規登録順・活動順でのソート

### 4. アバター画像管理
- **Active Storage統合**: プロフィール画像のアップロード機能
- **画像処理**: ImageProcessingを使用したリサイズ・最適化
- **バリデーション**: ファイル形式・サイズ制限
- **デフォルト画像**: アバター未設定時のデフォルト表示

### 5. プライバシー設定
- **設定項目**:
  - プロフィール公開/非公開
  - メールアドレス公開設定
  - 参加イベント履歴公開設定
- **PrivacySettingsモデル**: `app/models/privacy_setting.rb`
- **User関連付け**: `has_one :privacy_setting`

### 6. ユーザーアクティビティ表示
- **参加イベント履歴**: プロフィールページに表示
- **主催イベント履歴**: プロフィールページに表示
- **統計情報**: 参加回数、主催回数などの表示

### 7. ビューファイル作成
- **Bootstrap 5.2対応レスポンシブデザイン**
- **app/views/profiles/**:
  - `show.html.erb` (プロフィール表示)
  - `edit.html.erb` (プロフィール編集フォーム)
  - `_profile_card.html.erb` (プロフィールカードパーシャル)
- **app/views/users/**:
  - `index.html.erb` (ユーザー一覧)
  - `_user_card.html.erb` (ユーザーカードパーシャル)

### 8. ルーティング設定
- **config/routes.rb**:
```ruby
resources :users, only: [:index, :show]
resources :profiles, only: [:show, :edit, :update]
# または
resource :profile, only: [:show, :edit, :update]
get '/users/:id/profile', to: 'profiles#show', as: 'user_profile'
```

## 🔧 技術要件

### 基本要件
- **Rails 8 + PostgreSQL + Bootstrap 5.2対応**
- **MVCパターン準拠、初学者理解しやすい実装**
- **日本語コメント必須**（コードの意図と動作を説明）
- **Strong Parameters使用**（セキュリティ考慮）
- **RSpec テスト実装必須**
- **Devise認証との連携**

### ユーザー管理特有の要件
- **プライバシー保護**: 適切な公開範囲制御
- **画像処理**: Active Storageでの効率的な画像管理
- **検索機能**: 高速で使いやすい検索UI
- **レスポンシブデザイン**: モバイル対応のプロフィール表示
- **アクセシビリティ**: 障害のある方でも使いやすいUI

### セキュリティ要件
- **プライバシー保護**: 個人情報の適切な取り扱い
- **認証・認可**: 他人のプロフィール不正編集防止
- **ファイルアップロード**: 安全な画像アップロード処理
- **XSS対策**: ユーザー入力の適切なエスケープ

## 📁 対象ファイル

### 新規作成
- `app/controllers/profiles_controller.rb`
- `app/controllers/users_controller.rb`
- `app/models/privacy_setting.rb`
- `app/views/profiles/` (全ビューファイル)
- `app/views/users/` (index, _user_card)
- `db/migrate/[timestamp]_add_profile_fields_to_users.rb`
- `db/migrate/[timestamp]_create_privacy_settings.rb`
- `spec/models/privacy_setting_spec.rb`
- `spec/requests/profiles_spec.rb`
- `spec/requests/users_spec.rb`

### 修正
- `app/models/user.rb` (プロフィール機能拡張)
- `config/routes.rb` (ルーティング追加)
- `app/views/layouts/application.html.erb` (ナビゲーション更新)

## 📝 実装時の注意点

### プライバシー・セキュリティ考慮
1. **個人情報保護**: 最小限の情報のみ収集・表示
2. **公開範囲制御**: ユーザーが適切に制御可能な設計
3. **画像セキュリティ**: アップロード画像のウイルスチェック考慮
4. **データ削除**: アカウント削除時の関連データ適切削除

### ユーザビリティ考慮
1. **プロフィール補完**: 段階的なプロフィール入力促進
2. **検索性**: 見つけやすく、プライバシーも配慮した検索
3. **モバイル対応**: スマートフォンでの使いやすさ
4. **アクセシビリティ**: スクリーンリーダー対応

## ✅ 完了基準

### 機能面
- [ ] プロフィール表示・編集が正常に動作
- [ ] アバター画像アップロードが機能
- [ ] ユーザー検索・一覧が正常に動作
- [ ] プライバシー設定が適切に機能
- [ ] 認証・認可が正しく動作

### UI/UX面
- [ ] Bootstrap UIが適切に表示される
- [ ] レスポンシブデザインが機能
- [ ] フォームバリデーションが適切に表示
- [ ] 画像表示が最適化されている

### セキュリティ面
- [ ] プライバシー保護が適切に機能
- [ ] ファイルアップロードが安全
- [ ] 認可制御が正しく実装
- [ ] XSS対策が実装済み

### 品質面
- [ ] すべてのRSpecテストがパス
- [ ] セキュリティチェック完了
- [ ] パフォーマンステスト実行
- [ ] 初学者向けコメント完備

## 💡 実装のヒント

### よくある課題と対策
1. **画像処理**: ImageProcessingでの効率的なリサイズ
2. **プライバシー制御**: ポリシーパターンの活用
3. **検索機能**: ransackまたはPgSearchの活用
4. **UI設計**: ユーザーカードの見やすいデザイン

### パフォーマンス最適化
- ユーザー一覧でのEager Loading
- 画像の適切なキャッシュ設定
- 検索機能でのインデックス最適化

### 拡張可能性の考慮
- フォロー・フォロワー機能への拡張
- バッジ・実績システム
- プロフィールのカスタマイズ機能
- SNS連携の拡張

この実装指示に基づき、段階的にユーザー管理機能を実装してください。特に、プライバシー保護とセキュリティ対策は慎重に実装し、十分なテストを行ってください。