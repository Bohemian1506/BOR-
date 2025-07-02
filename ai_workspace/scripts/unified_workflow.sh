#!/bin/bash

# 統一実装ワークフロー - 「○○を実装したい」から詳細実装指示生成まで一貫実行
# Usage: ./ai_workspace/scripts/unified_workflow.sh "要求内容"

SIMPLE_REQUEST="$1"
TEMPLATES_DIR="ai_workspace/templates"
OUTPUTS_DIR="ai_workspace/outputs"

if [ -z "$SIMPLE_REQUEST" ]; then
    echo "❌ 使用法: ./ai_workspace/scripts/unified_workflow.sh '実装したい機能'"
    echo ""
    echo "📝 例:"
    echo "  ./ai_workspace/scripts/unified_workflow.sh 'イベント管理機能'"
    echo "  ./ai_workspace/scripts/unified_workflow.sh 'ユーザープロフィール画面'"
    echo "  ./ai_workspace/scripts/unified_workflow.sh 'お問い合わせフォーム'"
    exit 1
fi

echo "🚀 統一実装ワークフロー開始"
echo "📋 要求: $SIMPLE_REQUEST"
echo "=================================="

# 出力ディレクトリの確保
mkdir -p "$OUTPUTS_DIR"

# Phase 1: 要求内容の分析・分類
echo ""
echo "--- Phase 1: 要求分析・テンプレート選択 ---"

# 要求内容から適切なテンプレートを選択（キーワードマッチング）
TEMPLATE_TYPE=""
if [[ "$SIMPLE_REQUEST" =~ (イベント|event) ]]; then
    TEMPLATE_TYPE="event_management"
    echo "🎯 検出パターン: イベント管理系機能"
elif [[ "$SIMPLE_REQUEST" =~ (ユーザー|プロフィール|user|profile) ]]; then
    TEMPLATE_TYPE="user_management"  
    echo "🎯 検出パターン: ユーザー管理系機能"
elif [[ "$SIMPLE_REQUEST" =~ (お問い合わせ|contact|form|フォーム) ]]; then
    TEMPLATE_TYPE="form_feature"
    echo "🎯 検出パターン: フォーム系機能"
elif [[ "$SIMPLE_REQUEST" =~ (一覧|list|表示|show) ]]; then
    TEMPLATE_TYPE="listing_feature"
    echo "🎯 検出パターン: 一覧表示系機能"
elif [[ "$SIMPLE_REQUEST" =~ (認証|auth|login|ログイン) ]]; then
    TEMPLATE_TYPE="authentication"
    echo "🎯 検出パターン: 認証系機能"
else
    TEMPLATE_TYPE="basic_feature"
    echo "🎯 検出パターン: 基本機能（汎用テンプレート使用）"
fi

echo "📄 使用テンプレート: $TEMPLATE_TYPE"

# Phase 2: テンプレートベース実装指示生成
echo ""
echo "--- Phase 2: 詳細実装指示生成 ---"

TEMPLATE_FILE="$TEMPLATES_DIR/${TEMPLATE_TYPE}.md"
OUTPUT_FILE="$OUTPUTS_DIR/claude_generated_issue.md"

if [ ! -f "$TEMPLATE_FILE" ]; then
    echo "⚠️  テンプレートファイルが見つかりません: $TEMPLATE_FILE"
    echo "💡 基本テンプレートを使用します"
    TEMPLATE_FILE="$TEMPLATES_DIR/basic_feature.md"
fi

# テンプレートを読み込み、プレースホルダーを置換
if [ -f "$TEMPLATE_FILE" ]; then
    echo "📖 テンプレート読み込み: $TEMPLATE_FILE"
    
    # プレースホルダー置換処理
    sed "s/{{FEATURE_NAME}}/$SIMPLE_REQUEST/g" "$TEMPLATE_FILE" > "$OUTPUT_FILE.tmp"
    
    # 日付とプロジェクト情報を追加
    CURRENT_DATE=$(date '+%Y-%m-%d')
    PROJECT_INFO="BattleOfRunteq (Rails 8 + PostgreSQL + Bootstrap 5.2)"
    
    sed -i "s/{{DATE}}/$CURRENT_DATE/g" "$OUTPUT_FILE.tmp"
    sed -i "s/{{PROJECT_INFO}}/$PROJECT_INFO/g" "$OUTPUT_FILE.tmp"
    
    mv "$OUTPUT_FILE.tmp" "$OUTPUT_FILE"
    echo "✅ 実装指示生成完了: $OUTPUT_FILE"
else
    echo "❌ テンプレートファイルの読み込みに失敗しました"
    exit 1
fi

# Phase 3: 品質チェック・最適化
echo ""
echo "--- Phase 3: 生成内容の品質チェック ---"

# 生成されたファイルの基本的な品質チェック
ISSUE_SIZE=$(wc -c < "$OUTPUT_FILE")
LINE_COUNT=$(wc -l < "$OUTPUT_FILE") 

echo "📊 生成された実装指示の概要:"
echo "   - ファイルサイズ: ${ISSUE_SIZE} bytes"
echo "   - 行数: ${LINE_COUNT} lines"

if [ $ISSUE_SIZE -lt 500 ]; then
    echo "⚠️  生成内容が短すぎる可能性があります（500bytes未満）"
elif [ $ISSUE_SIZE -gt 10000 ]; then
    echo "⚠️  生成内容が長すぎる可能性があります（10KB以上）"
else
    echo "✅ ファイルサイズは適切です"
fi

# 必須セクション存在チェック
REQUIRED_SECTIONS=("実装タスク" "詳細実装手順" "技術要件" "対象ファイル")
MISSING_SECTIONS=()

for section in "${REQUIRED_SECTIONS[@]}"; do
    if ! grep -q "$section" "$OUTPUT_FILE"; then
        MISSING_SECTIONS+=("$section")
    fi
done

if [ ${#MISSING_SECTIONS[@]} -eq 0 ]; then
    echo "✅ 必須セクション全て含まれています"
else
    echo "⚠️  不足している可能性のあるセクション: ${MISSING_SECTIONS[*]}"
fi

# Phase 4: Gemini実行コマンド生成
echo ""
echo "--- Phase 4: Gemini実行コマンド生成 ---"

GEMINI_COMMAND_FILE="$OUTPUTS_DIR/gemini_execution_command.sh"

cat > "$GEMINI_COMMAND_FILE" << EOF
#!/bin/bash

# 自動生成されたGemini実行コマンド
# 生成日時: $(date '+%Y-%m-%d %H:%M:%S')
# 元の要求: $SIMPLE_REQUEST

echo "🚀 Gemini CLI実行中..."
echo "📋 実装要求: $SIMPLE_REQUEST"
echo ""

# 実装指示ファイルを読み込んでGeminiに投入
gemini -p "\$(cat $OUTPUT_FILE)"

echo ""
echo "✅ Gemini実行完了"
echo "📄 生成された実装指示: $OUTPUT_FILE"
echo "💡 次のステップ: Geminiの出力を確認して、Claudeで品質検証を実行してください"
EOF

chmod +x "$GEMINI_COMMAND_FILE"

echo "✅ Gemini実行コマンド生成完了: $GEMINI_COMMAND_FILE"

# Phase 5: 完了報告・次のアクション案内
echo ""
echo "🎉 統一実装ワークフロー完了"
echo "=================================="
echo ""
echo "📄 生成されたファイル:"
echo "   1. 詳細実装指示: $OUTPUT_FILE"
echo "   2. Gemini実行コマンド: $GEMINI_COMMAND_FILE"
echo ""
echo "🚀 次のアクション（推奨手順）:"
echo ""
echo "   # Step 1: 生成された実装指示を確認"
echo "   cat $OUTPUT_FILE"
echo ""
echo "   # Step 2: Gemini CLIで実装実行"
echo "   $GEMINI_COMMAND_FILE"
echo "   # または直接実行:"
echo "   gemini -p \"\$(cat $OUTPUT_FILE)\""
echo ""
echo "   # Step 3: 実装結果をClaude Codeで品質検証"
echo "   # （Gemini実行後、このスクリプトの親ディレクトリで）"
echo "   ./ai_workspace/scripts/ai_pair_flow.sh '$SIMPLE_REQUEST'"
echo ""
echo "💡 ワンライナー実行（全自動）:"
echo "   $GEMINI_COMMAND_FILE && ./ai_workspace/scripts/ai_pair_flow.sh '$SIMPLE_REQUEST'"
echo ""
echo "🔗 PR自動作成（品質検証後）:"
echo "   ./ai_workspace/scripts/ai_pair_flow.sh '$SIMPLE_REQUEST' --create-pr"
echo ""
echo "📖 詳細な手順は docs/README.md または CLAUDE.md を参照してください"

# オプション解析（PR作成フラグ）
CREATE_PR=false
if [ "$2" = "--create-pr" ] || [ "$2" = "-p" ]; then
    CREATE_PR=true
    echo ""
    echo "🔗 PR作成オプションが有効です"
    echo "   品質検証完了後、自動でPRを作成します"
fi