#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
HUGO_DIR="$SCRIPT_DIR/hugo"
CONTENT_DIR="$HUGO_DIR/content/posts"

echo "=== HackNews Hugo Content Sync ==="
echo "Project: $PROJECT_ROOT"
echo "Hugo:   $HUGO_DIR"

mkdir -p "$CONTENT_DIR"

count=0

for dir in "$PROJECT_ROOT"/202*/; do
  if [ -d "$dir" ]; then
    year_month=$(basename "$dir")
    echo ""
    echo "--- Processing $year_month ---"

    for mdfile in "$dir"*-*-*.md; do
      if [ -f "$mdfile" ] && [[ "$(basename "$mdfile")" != week* ]]; then
        filename=$(basename "$mdfile" .md)
        target="$CONTENT_DIR/${filename}.md"

        title_line=$(head -1 "$mdfile")
        clean_title=$(echo "$title_line" | sed 's/^# //')

        cat > "$target" << ENDOFFILE
---
title: "${clean_title}"
date: "${filename:0:4}-${filename:4:2}-${filename:6:2}"
draft: false
categories: ["HN深度解读"]
tags:
ENDOFFILE

python3 -c "
import re, json, sys
with open('$mdfile', encoding='utf-8') as f:
    content = f.read()
tag_map = {'🤖':'AI','✨':'开源','🔒':'安全','⚠️':'警告','🚀':'航天/硬科','💻':'开发工具','🎮':'游戏/Demo','🌍':'地缘/国际','💡':'洞察/效率','🔍':'分析/解析','🛡️':'隐私/合规','📖':'人文/社会','📚':'知识管理','😤':'争议','🏆':'热门','📊':'商业/经济','🔄':'重构','🧪':'实验'}
found = re.findall(r'[' + ''.join(tag_map.keys()) + r']', content)
unique = list(dict.fromkeys(tag_map.get(t, t) for t in found))
for t in unique[:5]:
    print(f'  - {t}')
" >> "$target" 2>/dev/null || echo "  - 技术" >> "$target"

cat >> "$target" << ENDOFFILE
---

$(cat "$mdfile")
ENDOFFILE

        count=$((count + 1))
        echo "  ✓ $filename"
      fi
    done
  fi
done

echo ""
echo "✅ Sync complete! $count posts synced to $CONTENT_DIR"
