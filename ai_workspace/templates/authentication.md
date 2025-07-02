# 🚀 {{FEATURE_NAME}}実装依頼

**生成日時**: {{DATE}}  
**プロジェクト**: {{PROJECT_INFO}}

## 🎯 実装タスク
BattleOfRunteqプロジェクトで「{{FEATURE_NAME}}」を実装してください。

## 📋 詳細実装手順

### 1. Devise設定の強化・カスタマイズ
- **既存Devise設定の確認**: `config/initializers/devise.rb`
- **追加設定**:
  - パスワード強度設定（最小8文字、複雑さ要求）
  - セッション管理（タイムアウト設定）
  - ロックアウト機能（連続ログイン失敗時）
  - 確認メール機能の強化
  - パスワードリセット機能の改善

### 2. 二段階認証（2FA）実装
- **TOTP（Time-based OTP）実装**:
  - `rqrcode` gem追加でQRコード生成
  - Google Authenticator対応
  - バックアップコード生成・管理
- **Userモデル拡張**:
  - `otp_secret:string` (暗号化保存)
  - `otp_enabled:boolean` (2FA有効フラグ)
  - `backup_codes:text` (バックアップコード配列)
- **2FA設定画面実装**:
  - QRコード表示
  - 確認コード入力
  - バックアップコード表示・ダウンロード

### 3. ソーシャルログイン統合
- **OAuth実装** (`omniauth` gem使用):
  - Google OAuth
  - GitHub OAuth  
  - Twitter OAuth（必要に応じて）
- **設定ファイル**: `config/initializers/omniauth.rb`
- **コールバック処理**: 既存アカウントとの連携
- **プロフィール情報自動取得**: OAuth経由での基本情報取得

### 4. セキュリティ機能強化
- **アカウントロック機能**:
  - 連続ログイン失敗でのアカウント一時停止
  - 管理者による手動ロック・解除
  - IP制限機能
- **セッション管理**:
  - 同時ログインセッション数制限
  - デバイス管理機能
  - セッション強制切断機能
- **監査ログ**:
  - ログイン・ログアウト履歴
  - パスワード変更履歴
  - 重要操作の記録

### 5. パスワード・セキュリティポリシー
- **パスワード要件**:
  - 最小8文字、英数字記号組み合わせ
  - 過去パスワードの再利用防止
  - 定期的なパスワード変更推奨
- **カスタムバリデーター実装**:
```ruby
# app/validators/password_strength_validator.rb
class PasswordStrengthValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    # パスワード強度チェックロジック
  end
end
```

### 6. ユーザー招待システム
- **Invitationモデル**: `app/models/invitation.rb`
- **招待機能**:
  - 管理者による招待メール送信
  - 招待リンクでのアカウント作成
  - 招待の有効期限管理
- **招待管理画面**: 送信済み招待の管理

### 7. ロール・権限管理システム
- **Roleモデル**: `app/models/role.rb`
- **User-Role関連付け**: 多対多の関連
- **権限チェック**:
  - コントローラーでのbefore_action
  - ビューでの表示制御
  - ポリシーベースの認可制御

### 8. セキュリティ監査・ログ機能
- **AuditLogモデル**: `app/models/audit_log.rb`
- **ログ対象アクション**:
  - ログイン・ログアウト
  - パスワード変更
  - プロフィール更新
  - 重要データの変更
- **管理者ダッシュボード**: セキュリティ状況の可視化

## 🔧 技術要件

### 基本要件
- **Rails 8 + PostgreSQL + Bootstrap 5.2対応**
- **Devise 4.x使用**（最新安定版）
- **MVCパターン準拠、初学者理解しやすい実装**
- **日本語コメント必須**（コードの意図と動作を説明）
- **Strong Parameters使用**（セキュリティ考慮）
- **RSpec テスト実装必須**

### セキュリティ要件
- **暗号化**: パスワード、OTPシークレットの適切な暗号化
- **HTTPS強制**: 本番環境でのSSL/TLS必須
- **CSRF対策**: Rails標準のCSRF保護強化
- **セッション固定攻撃対策**: セッション再生成実装
- **ブルートフォース攻撃対策**: レート制限・アカウントロック

### 監査・コンプライアンス要件
- **ログ保存**: セキュリティ関連イベントの完全記録
- **データ保護**: 個人情報の適切な取り扱い
- **GDPR対応**: データ削除・エクスポート機能
- **アクセス制御**: 最小権限の原則

## 📁 対象ファイル

### 新規作成
- `app/models/invitation.rb`
- `app/models/role.rb`
- `app/models/audit_log.rb`
- `app/controllers/two_factor_authentication_controller.rb`
- `app/controllers/invitations_controller.rb`
- `app/controllers/admin/security_controller.rb`
- `app/validators/password_strength_validator.rb`
- `app/views/two_factor_authentication/` (2FA関連ビュー)
- `app/views/invitations/` (招待関連ビュー)
- `app/mailers/invitation_mailer.rb`
- `db/migrate/[timestamp]_add_two_factor_to_users.rb`
- `db/migrate/[timestamp]_create_invitations.rb`
- `db/migrate/[timestamp]_create_roles.rb`
- `db/migrate/[timestamp]_create_audit_logs.rb`

### 修正
- `app/models/user.rb` (認証機能強化)
- `config/initializers/devise.rb` (Devise設定強化)
- `config/routes.rb` (認証関連ルーティング)
- `app/controllers/application_controller.rb` (共通認証ロジック)

### 設定ファイル
- `config/initializers/omniauth.rb` (OAuth設定)
- `config/secrets.yml` or `credentials.yml.enc` (API キー管理)

## 📝 実装時の注意点

### セキュリティ考慮
1. **機密情報の保護**: OTPシークレット、APIキーの暗号化保存
2. **セッション管理**: 適切なタイムアウト・無効化処理
3. **入力検証**: 全ての入力値の適切な検証・サニタイズ
4. **エラー情報**: セキュリティに関わる詳細情報の漏洩防止

### ユーザビリティ考慮
1. **2FA導入**: 段階的な導入とユーザー教育
2. **パスワード要件**: 厳しすぎない適切なバランス
3. **エラーメッセージ**: 分かりやすく、セキュリティを損なわない表現
4. **バックアップ手段**: 2FA無効時の適切な復旧手段

### 運用考慮
1. **監査ログ**: 適切な保存期間とローテーション
2. **アカウントロック**: 管理者による迅速な解除手段
3. **緊急時対応**: セキュリティインシデント時の手順
4. **定期メンテナンス**: セキュリティ設定の定期見直し

## ✅ 完了基準

### 機能面
- [ ] 基本認証機能が正常に動作
- [ ] 2FA機能が正常に動作
- [ ] ソーシャルログインが機能
- [ ] アカウントロック機能が動作
- [ ] 招待システムが機能

### セキュリティ面
- [ ] パスワード強度チェックが機能
- [ ] セッション管理が適切
- [ ] CSRF対策が実装済み
- [ ] 監査ログが正常に記録
- [ ] OAuth設定が安全

### UI/UX面
- [ ] Bootstrap UIが適切に表示される
- [ ] 2FA設定画面が使いやすい
- [ ] エラーメッセージが分かりやすい
- [ ] モバイル対応が完了

### 品質面
- [ ] すべてのRSpecテストがパス
- [ ] セキュリティテストが完了
- [ ] 負荷テストが完了
- [ ] 初学者向けコメント完備

## 💡 実装のヒント

### よくある課題と対策
1. **2FA実装**: QRコードの表示とバックアップコード管理
2. **OAuth連携**: 既存アカウントとの適切な紐付け
3. **セッション管理**: 複数デバイスでの適切な制御
4. **パスワード要件**: ユーザビリティとセキュリティのバランス

### 推奨Gem
- **omniauth**: OAuth認証
- **omniauth-rails_csrf_protection**: CSRF保護
- **rotp**: TOTP実装
- **rqrcode**: QRコード生成
- **cancancan**: 権限管理

### セキュリティベストプラクティス
- 最小権限の原則
- 多層防御の実装
- 定期的なセキュリティ監査
- インシデント対応計画の策定

### パフォーマンス最適化
- セッションストアの最適化（Redis使用検討）
- 認証クエリの効率化
- 監査ログの適切なインデックス設計

### 拡張可能性の考慮
- SSO（Single Sign-On）対応
- 生体認証対応
- リスクベース認証
- 外部ID プロバイダー連携

この実装指示に基づき、段階的に認証システムを強化してください。特に、セキュリティ要件は妥協せず、十分なテストとセキュリティ監査を行ってください。