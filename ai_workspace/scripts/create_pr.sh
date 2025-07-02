#!/bin/bash

# PR自動作成スクリプト
# 統一ワークフローとの連携でPRテンプレートを自動適用

set -e

FEATURE_NAME="$1"
BASE_BRANCH="${2:-main}"
COMMIT_MESSAGE_FILE="ai_workspace/outputs/commit_message.txt"
PR_BODY_FILE="ai_workspace/outputs/pr_body.md"

# 使用方法表示
show_usage() {
    echo "使用法: ./ai_workspace/scripts/create_pr.sh '機能名' [ベースブランチ]"
    echo ""
    echo "例:"
    echo "  ./ai_workspace/scripts/create_pr.sh 'イベント管理機能'"
    echo "  ./ai_workspace/scripts/create_pr.sh 'ユーザー認証' 'develop'"
    echo ""
    echo "💡 統一ワークフローとの連携:"
    echo "   1. ./ai_workspace/scripts/unified_workflow.sh '機能名'"
    echo "   2. gemini -p \"\$(cat ai_workspace/outputs/claude_generated_issue.md)\""
    echo "   3. ./ai_workspace/scripts/ai_pair_flow.sh '機能名' --create-pr"
    exit 1
}

if [ -z "$FEATURE_NAME" ]; then
    show_usage
fi

echo "=== PR自動作成開始 ==="
echo "機能名: $FEATURE_NAME"
echo "ベースブランチ: $BASE_BRANCH"
echo ""

# Git状態確認
echo "--- Git状態確認 ---"
CURRENT_BRANCH=$(git branch --show-current)
echo "現在のブランチ: $CURRENT_BRANCH"

if [ "$CURRENT_BRANCH" = "$BASE_BRANCH" ]; then
    echo "❌ エラー: ベースブランチ($BASE_BRANCH)と同じブランチです"
    echo "   feature/ブランチを作成してから実行してください"
    exit 1
fi

# 変更確認
CHANGES=$(git status --porcelain)
if [ -z "$CHANGES" ]; then
    echo "ℹ️  未コミットの変更はありません"
else
    echo "⚠️  未コミットの変更があります:"
    echo "$CHANGES"
    echo ""
    echo "📝 変更をコミットしますか？ (y/N)"
    read -r COMMIT_CONFIRM
    if [ "$COMMIT_CONFIRM" = "y" ] || [ "$COMMIT_CONFIRM" = "Y" ]; then
        git add -A
        
        # 統一ワークフローからのコミットメッセージ生成
        generate_commit_message
        
        if [ -f "$COMMIT_MESSAGE_FILE" ]; then
            git commit -F "$COMMIT_MESSAGE_FILE"
            echo "✅ 変更をコミットしました"
        else
            git commit -m "feat: ${FEATURE_NAME}の実装

🤖 Generated with [Claude Code](https://claude.ai/code)

Co-Authored-By: Claude <noreply@anthropic.com>"
            echo "✅ 変更をコミットしました（デフォルトメッセージ）"
        fi
    else
        echo "❌ コミットが必要です。処理を中断します"
        exit 1
    fi
fi

# リモートブランチへプッシュ
echo ""
echo "--- リモートブランチへプッシュ ---"
echo "🚀 ブランチをプッシュ中..."
git push -u origin "$CURRENT_BRANCH"

# PR内容生成
echo ""
echo "--- PR内容生成 ---"
generate_pr_body

# GitHub CLI認証確認
echo ""
echo "--- GitHub CLI認証確認 ---"
if ! gh auth status >/dev/null 2>&1; then
    echo "❌ GitHub CLIが認証されていません"
    echo "💡 以下のコマンドで認証してください:"
    echo "   gh auth login"
    echo ""
    echo "📋 または、GitHub Personal Access Tokenを使用:"
    echo "   export GITHUB_TOKEN=your_token_here"
    exit 1
fi

# PR作成
echo "--- PR作成実行 ---"
if [ -f "$PR_BODY_FILE" ]; then
    echo "📝 生成されたPR内容を使用"
    gh pr create \
        --title "feat: ${FEATURE_NAME}" \
        --body-file "$PR_BODY_FILE" \
        --base "$BASE_BRANCH" \
        --head "$CURRENT_BRANCH"
else
    echo "📝 デフォルトPR内容を使用"
    gh pr create \
        --title "feat: ${FEATURE_NAME}" \
        --body "$(generate_default_pr_body)" \
        --base "$BASE_BRANCH" \
        --head "$CURRENT_BRANCH"
fi

echo ""
echo "🎉 PR作成完了！"
echo "📋 PR URL: $(gh pr view --web 2>/dev/null || echo 'GitHub上で確認してください')"

# コミットメッセージ生成関数
generate_commit_message() {
    cat > "$COMMIT_MESSAGE_FILE" << EOF
feat: ${FEATURE_NAME}の実装

## 実装内容
$(get_implementation_summary)

## 変更ファイル
$(git diff --cached --name-only | sed 's/^/- /')

## 関連情報
- 統一ワークフロー使用: $([ -f "ai_workspace/outputs/claude_generated_issue.md" ] && echo "Yes" || echo "No")
- AI品質検証: $([ -f "ai_workspace/outputs/claude_review_*.json" ] && echo "実施済み" || echo "未実施")

🤖 Generated with [Claude Code](https://claude.ai/code)

Co-Authored-By: Claude <noreply@anthropic.com>
EOF
}

# 実装概要取得関数
get_implementation_summary() {
    local SUMMARY=""
    
    # Gemini実装結果から概要抽出
    if [ -f "ai_workspace/outputs/gemini_implementation.txt" ]; then
        SUMMARY=$(head -10 "ai_workspace/outputs/gemini_implementation.txt" | tail -5)
    fi
    
    # Claude生成Issue情報
    if [ -f "ai_workspace/outputs/claude_generated_issue.md" ]; then
        SUMMARY="$SUMMARY\n\n統一ワークフローによる計画的実装"
    fi
    
    echo -e "$SUMMARY" | head -3
}

# PR本文生成関数
generate_pr_body() {
    local TEMPLATE_FILE=".github/pull_request_template.md"
    
    if [ -f "$TEMPLATE_FILE" ]; then
        echo "📋 PRテンプレートを使用してPR内容生成中..."
        
        # テンプレートベースでPR内容生成
        cat > "$PR_BODY_FILE" << EOF
# 概要

## ${FEATURE_NAME}の実装

$(get_feature_description)

# 細かな変更点

$(get_detailed_changes)

# 影響範囲・懸念点

$(get_impact_analysis)

# おこなった動作確認

$(get_test_results)

# その他

$(get_additional_info)

---

🤖 Generated with [Claude Code](https://claude.ai/code)

## AI実装情報
- **統一ワークフロー**: $([ -f "ai_workspace/outputs/claude_generated_issue.md" ] && echo "使用済み" || echo "未使用")
- **Gemini実装**: $([ -f "ai_workspace/outputs/gemini_implementation.txt" ] && echo "実施済み" || echo "未実施")
- **Claude品質検証**: $(get_review_status)
- **実装日時**: $(date '+%Y-%m-%d %H:%M:%S')

EOF
        echo "✅ PR内容生成完了: $PR_BODY_FILE"
    else
        echo "⚠️  PRテンプレートが見つかりません: $TEMPLATE_FILE"
        echo "📝 デフォルトPR内容を生成します"
        generate_default_pr_body > "$PR_BODY_FILE"
    fi
}

# 機能説明取得
get_feature_description() {
    if [ -f "ai_workspace/outputs/claude_generated_issue.md" ]; then
        grep -A 5 "## 概要" "ai_workspace/outputs/claude_generated_issue.md" 2>/dev/null | tail -4 | head -2
    else
        echo "${FEATURE_NAME}に関する機能実装"
    fi
}

# 詳細変更取得
get_detailed_changes() {
    echo "- $(git diff --cached --name-only | wc -l)個のファイルを変更"
    git diff --cached --name-only | head -10 | sed 's/^/- /'
    
    if [ $(git diff --cached --name-only | wc -l) -gt 10 ]; then
        echo "- ... 他$(( $(git diff --cached --name-only | wc -l) - 10 ))個のファイル"
    fi
}

# 影響範囲分析
get_impact_analysis() {
    echo "## 変更されたファイル種別"
    
    local CONTROLLERS=$(git diff --cached --name-only | grep "app/controllers" | wc -l)
    local MODELS=$(git diff --cached --name-only | grep "app/models" | wc -l)
    local VIEWS=$(git diff --cached --name-only | grep "app/views" | wc -l)
    local ROUTES=$(git diff --cached --name-only | grep "config/routes.rb" | wc -l)
    local SPECS=$(git diff --cached --name-only | grep "spec/" | wc -l)
    
    [ $CONTROLLERS -gt 0 ] && echo "- コントローラー: ${CONTROLLERS}個"
    [ $MODELS -gt 0 ] && echo "- モデル: ${MODELS}個"
    [ $VIEWS -gt 0 ] && echo "- ビュー: ${VIEWS}個"
    [ $ROUTES -gt 0 ] && echo "- ルーティング: 変更あり"
    [ $SPECS -gt 0 ] && echo "- テスト: ${SPECS}個"
}

# テスト結果取得
get_test_results() {
    echo "* [ ] 基本機能動作確認"
    echo "* [ ] エラーハンドリング確認"
    echo "* [ ] レスポンシブデザイン確認"
    
    if [ -f "ai_workspace/outputs/claude_review_*.json" ]; then
        echo "* [x] AI品質検証完了"
    else
        echo "* [ ] AI品質検証"
    fi
}

# 追加情報取得
get_additional_info() {
    echo "統一ワークフローにより計画的に実装された機能です。"
    
    if [ -f "ai_workspace/outputs/claude_review_*.json" ]; then
        local LATEST_REVIEW=$(ls -t ai_workspace/outputs/claude_review_*.json | head -1)
        local SCORE=$(grep '"score"' "$LATEST_REVIEW" | grep -o '[0-9]*' | head -1)
        echo "AI品質検証スコア: ${SCORE}/100"
    fi
}

# レビュー状況取得
get_review_status() {
    if [ -f ai_workspace/outputs/claude_review_*.json ]; then
        local LATEST_REVIEW=$(ls -t ai_workspace/outputs/claude_review_*.json | head -1)
        local STATUS=$(grep '"status"' "$LATEST_REVIEW" | cut -d'"' -f4)
        echo "$STATUS"
    else
        echo "未実施"
    fi
}

# デフォルトPR内容生成
generate_default_pr_body() {
    cat << EOF
# 概要

## ${FEATURE_NAME}の実装

BattleOfRunteqプロジェクトにおける${FEATURE_NAME}の実装です。

<!-- レビュアーが理解できるよう、このプルリクの概要と共に、どうしておこなったかの背景が以下に書かれているとグッド -->

$(get_feature_description)

# 細かな変更点

<!-- コード自体の変更についてサマリを記載 -->

$(get_detailed_changes)

## スクリーンショット

|       | Before | After |
| :---: | :----: | :---: |
|  |  |  |

# 影響範囲・懸念点

<!-- レビュアーに見てほしい点、影響しそうな機能 -->

$(get_impact_analysis)

# おこなった動作確認

<!-- おこなった動作確認を箇条書きで -->

$(get_test_results)

# その他

<!-- レビュアーへのメッセージや一言などあれば -->

$(get_additional_info)

---

🤖 Generated with [Claude Code](https://claude.ai/code)
EOF
}