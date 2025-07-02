# 統一実装ワークフロー完全ガイド

## 🎯 概要
BattleOfRunteqプロジェクトにおける「○○を実装したい」という簡単な要求から、Geminiで実行できる詳細な実装指示まで一貫して生成する統一ワークフローの完全マニュアルです。

## 🚀 基本的な使用法

### ワンコマンド実行（推奨）
```bash
# Step 1: 統一ワークフロー実行（実装指示生成）
./ai_workspace/scripts/unified_workflow.sh 'イベント管理機能'

# Step 2: 生成された指示でGemini実行
gemini -p "$(cat ai_workspace/outputs/claude_generated_issue.md)"

# Step 3: 品質検証（Claude検証ループ）
./ai_workspace/scripts/ai_pair_flow.sh 'イベント管理機能'
```

### 自動実行コマンド使用
```bash
# Step 1で生成されるコマンドファイルを使用
./ai_workspace/outputs/gemini_execution_command.sh

# その後品質検証
./ai_workspace/scripts/ai_pair_flow.sh 'イベント管理機能'
```

## 📋 対応する機能タイプ

統一ワークフローは要求内容を自動分析し、最適なテンプレートを選択します：

| 機能キーワード | テンプレート | 生成される実装指示の特徴 |
|---------------|-------------|-------------------------|
| **イベント** | event_management | ・Event/Registrationモデル<br>・参加申し込み機能<br>・定員管理・日時検証 |
| **ユーザー**<br>**プロフィール** | user_management | ・プロフィール拡張<br>・アバター機能<br>・プライバシー設定 |
| **お問い合わせ**<br>**フォーム** | form_feature | ・メール送信機能<br>・スパム対策<br>・管理機能 |
| **一覧**<br>**表示** | listing_feature | ・検索・絞り込み<br>・ソート・ページネーション<br>・パフォーマンス最適化 |
| **認証**<br>**ログイン** | authentication | ・2FA実装<br>・ソーシャルログイン<br>・セキュリティ強化 |
| **その他** | basic_feature | ・汎用CRUD機能<br>・Rails規約準拠<br>・基本的なMVC実装 |

## 📁 ファイル構成

### 生成されるファイル
```
ai_workspace/
├── outputs/
│   ├── claude_generated_issue.md          # 詳細実装指示
│   └── gemini_execution_command.sh        # Gemini実行コマンド
├── scripts/
│   ├── unified_workflow.sh                # 統一ワークフロー本体
│   └── ai_pair_flow.sh                   # 品質検証スクリプト
└── templates/
    ├── basic_feature.md                   # 汎用テンプレート
    ├── event_management.md                # イベント管理テンプレート
    ├── user_management.md                 # ユーザー管理テンプレート
    ├── form_feature.md                    # フォーム機能テンプレート
    ├── listing_feature.md                 # 一覧機能テンプレート
    └── authentication.md                  # 認証機能テンプレート
```

## 🔧 テンプレートの詳細

### event_management.md
```markdown
# 🚀 [機能名]実装依頼

## 📋 詳細実装手順
### 1. Eventモデル作成
### 2. Registrationモデル作成
### 3. コントローラー実装
### 4. ビュー作成
### 5. ルーティング設定

## 🔧 技術要件
- Rails 8 + PostgreSQL + Bootstrap 5.2対応
- 日時管理・定員管理・ステータス管理
- 検索機能・参加者管理

## 📁 対象ファイル
[具体的なファイルリスト]

## ✅ 完了基準
[機能面・UI/UX面・品質面の基準]
```

### 他のテンプレートも同様の構造
- **実装手順**: 段階的な作業ステップ
- **技術要件**: 機能固有の要件
- **対象ファイル**: 作成・修正するファイル
- **完了基準**: 品質チェック項目

## 💡 実際の使用例

### 例1: イベント管理機能の実装
```bash
$ ./ai_workspace/scripts/unified_workflow.sh 'イベント管理機能'

🚀 統一実装ワークフロー開始
📋 要求: イベント管理機能
🎯 検出パターン: イベント管理系機能
📄 使用テンプレート: event_management
✅ 実装指示生成完了: ai_workspace/outputs/claude_generated_issue.md
```

生成される実装指示（187行、7468文字）:
- Eventモデル設計（8フィールド、詳細バリデーション）
- Registrationモデル設計（中間テーブル、重複防止）
- EventsController（7アクション、認証・認可）
- RegistrationsController（3アクション、ネストルーティング）
- Bootstrap 5.2対応ビュー（6ファイル）
- RSpecテスト（4ファイル）

### 例2: お問い合わせフォームの実装
```bash
$ ./ai_workspace/scripts/unified_workflow.sh 'お問い合わせフォーム'

🎯 検出パターン: フォーム系機能
📄 使用テンプレート: form_feature
```

生成される実装指示の特徴:
- Contactモデル（8フィールド、スパム対策）
- ContactMailer（自動返信・管理者通知）
- 管理機能（一覧・詳細・ステータス管理）
- セキュリティ対策（reCAPTCHA、レート制限）

## 🔍 品質チェック機能

統一ワークフローには品質チェック機能が組み込まれています：

### 自動チェック項目
1. **ファイルサイズチェック**: 500bytes〜10KB の適切な範囲
2. **必須セクション確認**: 「実装タスク」「詳細実装手順」「技術要件」「対象ファイル」
3. **行数チェック**: 適切な詳細度の確認

### 出力例
```bash
📊 生成された実装指示の概要:
   - ファイルサイズ: 7468 bytes
   - 行数: 187 lines
✅ ファイルサイズは適切です
✅ 必須セクション全て含まれています
```

## 🚨 エラー対応

### よくあるエラーと対処法

#### 1. テンプレートファイルが見つからない
```bash
⚠️  テンプレートファイルが見つかりません: ai_workspace/templates/event_management.md
💡 基本テンプレートを使用します
```
**対処法**: `ai_workspace/templates/` ディレクトリにテンプレートファイルが存在することを確認

#### 2. 権限エラー
```bash
bash: ./ai_workspace/scripts/unified_workflow.sh: Permission denied
```
**対処法**: 実行権限を付与
```bash
chmod +x ./ai_workspace/scripts/unified_workflow.sh
```

#### 3. 生成内容が短すぎる
```bash
⚠️  生成内容が短すぎる可能性があります（500bytes未満）
```
**対処法**: テンプレートファイルの内容を確認、プレースホルダーが正しく置換されているかチェック

## 📈 パフォーマンス最適化

### 処理時間の短縮
- テンプレート選択の最適化（正規表現マッチング）
- プレースホルダー置換の効率化
- 品質チェックの軽量化

### 実行時間の目安
- **小規模機能** (basic_feature): 1-2秒
- **中規模機能** (event_management): 2-3秒
- **大規模機能** (authentication): 3-4秒

## 🔄 従来手法との比較

### 従来の手動方式
```bash
# 手動でGemini指示を作成（5-10分）
gemini -p "BattleOfRunteqプロジェクトでイベント管理機能を実装してください。
Rails 8とBootstrap 5.2を使用し、以下の要件で実装してください:
- Eventモデルの作成
- [手動で詳細を記述...]"
```

### 統一ワークフロー
```bash
# 自動生成（3秒）
./ai_workspace/scripts/unified_workflow.sh 'イベント管理機能'
gemini -p "$(cat ai_workspace/outputs/claude_generated_issue.md)"
```

### 改善効果
- ⏱️ **時間短縮**: 5-10分 → 10秒
- 🎯 **精度向上**: 手動ミス削減
- 📚 **一貫性**: テンプレート化による標準化
- 🔄 **再利用性**: 生成された指示文書の保存・再利用

## 🛠️ カスタマイズ

### 新しいテンプレートの追加
1. `ai_workspace/templates/新機能名.md` を作成
2. `unified_workflow.sh` のテンプレート選択ロジックに追加:
```bash
elif [[ "$SIMPLE_REQUEST" =~ (新機能|keyword) ]]; then
    TEMPLATE_TYPE="新機能名"
    echo "🎯 検出パターン: 新機能系"
```

### プレースホルダーの追加
テンプレートで使用可能な変数:
- `{{FEATURE_NAME}}`: 機能名
- `{{DATE}}`: 生成日時
- `{{PROJECT_INFO}}`: プロジェクト情報

## 📚 参考資料

- **[CLAUDE.md](../CLAUDE.md)**: Claude-Gemini連携システム全体仕様
- **[docs/README.md](./README.md)**: ローカル開発環境ガイド
- **[docs/AI_SYSTEM_GUIDE.md](./AI_SYSTEM_GUIDE.md)**: AI連携システム活用法

---

**BattleOfRunteq統一実装ワークフロー** - 「○○を実装したい」から詳細実装指示まで一貫生成  
効率的で一貫性のあるAI支援開発環境を実現