# 🚀 {{FEATURE_NAME}}実装依頼

**生成日時**: {{DATE}}  
**プロジェクト**: {{PROJECT_INFO}}

## 🎯 実装タスク
BattleOfRunteqプロジェクトで「{{FEATURE_NAME}}」を実装してください。

## 📋 詳細実装手順

### 1. Eventモデル作成
- **ファイル**: `app/models/event.rb`
- **マイグレーション**: `db/migrate/[timestamp]_create_events.rb`
- **フィールド**: 
  - `name:string` (イベント名、必須)
  - `description:text` (説明文)
  - `start_time:datetime` (開始日時、必須)
  - `end_time:datetime` (終了日時)
  - `location:string` (開催場所)
  - `capacity:integer` (定員、正の整数)
  - `user:references` (主催者、Userモデルとの関連)
  - `status:string` (ステータス: 'draft', 'published', 'cancelled')
- **バリデーション**: 
  - name必須、長さ制限（1-100文字）
  - start_time必須、未来日時チェック
  - capacity正の整数、上限チェック
  - end_time > start_time バリデーション

### 2. Registrationモデル作成（イベント参加管理）
- **ファイル**: `app/models/registration.rb`
- **概要**: Event-User間の中間テーブル
- **マイグレーション**: `db/migrate/[timestamp]_create_registrations.rb`
- **フィールド**:
  - `event:references` (参加するイベント)
  - `user:references` (参加者)
  - `status:string` (申し込み状況: 'pending', 'confirmed', 'cancelled')
  - `message:text` (申し込み時のメッセージ、任意)
  - `registered_at:datetime` (申し込み日時)
- **バリデーション**: 
  - 同一イベントへの重複申し込み防止
  - statusの値制限
  - 定員オーバーチェック

### 3. モデル関連付け設定
- **Eventモデル**:
  - `belongs_to :user` (主催者)
  - `has_many :registrations, dependent: :destroy`
  - `has_many :participants, through: :registrations, source: :user`
- **Userモデル**:
  - `has_many :events, dependent: :destroy` (主催イベント)
  - `has_many :registrations, dependent: :destroy`
  - `has_many :participating_events, through: :registrations, source: :event`

### 4. EventsController実装
- **ファイル**: `app/controllers/events_controller.rb`
- **アクション**:
  - `index` (イベント一覧、検索・絞り込み機能)
  - `show` (イベント詳細、参加状況表示)
  - `new` (新規イベント作成フォーム)
  - `create` (イベント作成処理)
  - `edit` (イベント編集フォーム)
  - `update` (イベント更新処理)
  - `destroy` (イベント削除)
- **認証**: Deviseによる認証必須（new, create, edit, update, destroy）
- **認可**: 主催者のみ編集・削除可能

### 5. RegistrationsController実装
- **ファイル**: `app/controllers/registrations_controller.rb`
- **アクション**:
  - `create` (イベント参加申し込み)
  - `destroy` (参加キャンセル)
  - `index` (自分の参加申し込み一覧)
- **ネストルーティング**: `/events/:event_id/registrations`

### 6. ビューファイル作成
- **Bootstrap 5.2対応レスポンシブデザイン**
- **app/views/events/**:
  - `index.html.erb` (イベント一覧、カード形式表示)
  - `show.html.erb` (イベント詳細、参加申し込みボタン)
  - `new.html.erb` (イベント作成フォーム)
  - `edit.html.erb` (イベント編集フォーム)
  - `_form.html.erb` (共通フォームパーシャル)
  - `_event_card.html.erb` (イベントカードパーシャル)
- **app/views/registrations/**:
  - `index.html.erb` (参加申し込み一覧)

### 7. ルーティング設定
- **config/routes.rb**:
```ruby
resources :events do
  resources :registrations, only: [:create, :destroy]
end
resources :registrations, only: [:index]
```

## 🔧 技術要件

### 基本要件
- **Rails 8 + PostgreSQL + Bootstrap 5.2対応**
- **MVCパターン準拠、初学者理解しやすい実装**
- **日本語コメント必須**（コードの意図と動作を説明）
- **Strong Parameters使用**（セキュリティ考慮）
- **RSpec テスト実装必須**
- **Devise認証との連携**

### イベント管理特有の要件
- **日時管理**: 開始・終了時刻の適切な処理
- **定員管理**: 参加人数の上限チェック
- **ステータス管理**: イベントと参加申し込みの状態管理
- **検索機能**: 日付、場所、キーワードでの検索
- **参加者管理**: 主催者による参加者確認機能

### セキュリティ要件
- **CSRF対策**: Rails標準のCSRF保護
- **認証・認可**: Deviseと連携した適切なアクセス制御
- **SQLインジェクション対策**: Active Recordの適切な使用
- **入力値検証**: 悪意のあるデータに対する防御

## 📁 対象ファイル

### 新規作成
- `app/models/event.rb`
- `app/models/registration.rb`
- `app/controllers/events_controller.rb`
- `app/controllers/registrations_controller.rb`
- `app/views/events/` (全ビューファイル)
- `app/views/registrations/index.html.erb`
- `db/migrate/[timestamp]_create_events.rb`
- `db/migrate/[timestamp]_create_registrations.rb`
- `spec/models/event_spec.rb`
- `spec/models/registration_spec.rb`
- `spec/requests/events_spec.rb`
- `spec/requests/registrations_spec.rb`

### 修正
- `config/routes.rb` (ルーティング追加)
- `app/models/user.rb` (関連付け追加)

## 📝 実装時の注意点

### イベント管理固有の考慮事項
1. **日時処理**: タイムゾーンの適切な管理
2. **定員チェック**: 同時申し込みでの競合状態対策
3. **キャンセル処理**: イベント・参加申し込みのキャンセル業務フロー
4. **通知機能**: 将来の拡張を考慮した設計
5. **アクセシビリティ**: 障害のある方でも使いやすいUI

### パフォーマンス考慮
- イベント一覧での効率的なクエリ（includes使用）
- 大量データでのページネーション実装
- 検索機能でのインデックス設計

## ✅ 完了基準

### 機能面
- [ ] イベントのCRUD操作が正常に動作
- [ ] 参加申し込み・キャンセルが正常に動作
- [ ] 定員チェックが正しく機能
- [ ] 検索・絞り込み機能が動作
- [ ] 認証・認可が適切に機能

### UI/UX面
- [ ] Bootstrap UIが適切に表示される
- [ ] レスポンシブデザインが機能
- [ ] フォームバリデーションが適切に表示
- [ ] エラーメッセージが分かりやすい

### 品質面
- [ ] すべてのRSpecテストがパス
- [ ] セキュリティチェック完了
- [ ] パフォーマンステスト実行
- [ ] 初学者向けコメント完備

## 💡 実装のヒント

### よくある課題と対策
1. **定員管理**: 楽観的ロックまたはトランザクション処理
2. **日時バリデーション**: カスタムバリデーターの実装
3. **検索機能**: ransackなどの検索gemの活用検討
4. **UI設計**: イベント情報の視認性を重視したカードデザイン

### 拡張可能性の考慮
- 複数日程イベント対応
- 有料イベント対応
- カテゴリ分類機能
- コメント・評価機能

この実装指示に基づき、段階的にイベント管理機能を実装してください。特に、定員管理と日時処理は慎重に実装し、十分なテストを行ってください。