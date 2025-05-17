#!/bin/bash

set -e

echo "🔧 Poetry セットアップスクリプトを開始します..."

# 1. Python の確認
if ! command -v python3 &> /dev/null; then
  echo "❌ Python3 がインストールされていません。"
  exit 1
fi
echo "✅ Python バージョン: $(python3 --version)"

# 2. Poetry の確認 or インストール
if ! command -v poetry &> /dev/null; then
  echo "📦 Poetry をインストール中..."
  curl -sSL https://install.python-poetry.org | python3 -
  export PATH="$HOME/.local/bin:$PATH"
else
  echo "✅ Poetry は既にインストールされています。"
fi

echo "🧪 Poetry バージョン: $(poetry --version)"

# 3. README.md を自動生成（なければ）
if [ ! -f "README.md" ]; then
  echo "📄 README.md が存在しないため、自動生成します..."
  cat <<EOF > README.md
# $(basename "$PWD")

このプロジェクトは Poetry によって初期化されました。

## セットアップ方法

\`\`\`bash
poetry install
poetry shell
\`\`\`

## 実行方法

\`\`\`bash
python your_script.py
\`\`\`
EOF
else
  echo "✅ README.md は既に存在しています。"
fi

# 4. Poetry プロジェクト初期化（存在しない場合）
if [ ! -f "pyproject.toml" ]; then
  echo "📁 pyproject.toml を初期化中..."
  poetry init --name "$(basename "$PWD")" \
              --description "" \
              --author "$(whoami)" \
              --python "^$(python3 -c 'import sys; print(".".join(map(str, sys.version_info[:2])))')" \
              --no-interaction

  # package-mode を false に設定
  echo "⚙️  package-mode = false を設定します..."
  sed -i '' '/^\[tool.poetry\]/a\
package-mode = false
' pyproject.toml
else
  echo "✅ pyproject.toml は既に存在しています。"
fi

# 5. 仮想環境を作成（パッケージなし）
echo "🐍 仮想環境のセットアップ中..."
poetry install --no-root

echo "🎉 セットアップ完了！ 'poetry shell' で仮想環境に入れます。"
