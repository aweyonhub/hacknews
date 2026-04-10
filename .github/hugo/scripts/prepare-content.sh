#!/usr/bin/env bash
# =============================================================
# .github/hugo/scripts/prepare-content.sh
# 功能：将项目根目录的 Markdown 文件处理后复制到 Hugo 内容目录
#       并为缺少 front matter 的文件自动补充元数据
# 调用方：GitHub Actions 工作流 / start-hugo.sh 本地脚本
# =============================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HUGO_DIR="$(dirname "$SCRIPT_DIR")"                    # .github/hugo/
PROJECT_ROOT="$(dirname "$(dirname "$HUGO_DIR")")"     # 项目根目录
CONTENT_DIR="$HUGO_DIR/content"

echo "──────────────────────────────────────"
echo "📂 项目根目录  : $PROJECT_ROOT"
echo "📋 目标内容目录: $CONTENT_DIR"
echo "──────────────────────────────────────"

# 清理旧内容，重建目录
rm -rf "$CONTENT_DIR"
mkdir -p "$CONTENT_DIR"

# -------------------------------------------------------
# 使用 Python 处理文件（更可靠地支持 Unicode 标题提取）
# -------------------------------------------------------
python3 - "$PROJECT_ROOT" "$CONTENT_DIR" << 'PYEOF'
import sys
import os
import re
import shutil

source_root = sys.argv[1]
content_dir = sys.argv[2]


def extract_title(text):
    """从 Markdown 内容中提取第一个 H1 标题。"""
    m = re.search(r'^#\s+(.+)$', text, re.MULTILINE)
    return m.group(1).strip() if m else None


def process_file(src_path, dst_path):
    """读取源文件并写入目标路径，必要时添加 front matter。"""
    with open(src_path, 'r', encoding='utf-8') as f:
        content = f.read()

    # 已有 front matter（以 --- 开头），直接复制
    if content.lstrip().startswith('---'):
        shutil.copy2(src_path, dst_path)
        return

    basename = os.path.basename(src_path)

    # 从 H1 提取标题，回退到文件名
    title = extract_title(content) or basename
    title = title.replace('"', '\\"')    # 转义双引号

    # 从文件名提取日期（YYYYMMDD 前缀）
    date = ''
    m = re.match(r'^(\d{4})(\d{2})(\d{2})', basename)
    if m:
        date = f'{m.group(1)}-{m.group(2)}-{m.group(3)}'

    # slug 使用原始文件名（不含扩展名），转换为小写以确保链接一致性
    slug = os.path.splitext(basename)[0].lower().replace('"', '\\"')

    # 拼装 front matter
    fm_lines = ['---', f'title: "{title}"']
    if date:
        fm_lines.append(f'date: "{date}"')
    fm_lines.append(f'slug: "{slug}"')
    fm_lines.extend(['---', ''])

    with open(dst_path, 'w', encoding='utf-8') as f:
        f.write('\n'.join(fm_lines) + '\n' + content)


# ---- 1. README.md → content/_index.md ----
readme = os.path.join(source_root, 'README.md')
if os.path.exists(readme):
    shutil.copy2(readme, os.path.join(content_dir, '_index.md'))
    print('  ✓ README.md → _index.md')

# ---- 2. 各月份目录（YYYYMM 格式） ----
for entry in sorted(os.listdir(source_root)):
    month_path = os.path.join(source_root, entry)
    if not os.path.isdir(month_path) or not re.match(r'^\d{6}$', entry):
        continue

    month = entry
    year  = month[:4]
    mon   = month[4:]

    dst_month = os.path.join(content_dir, month)
    os.makedirs(dst_month, exist_ok=True)

    # 生成月份 _index.md（若源目录中不存在）
    src_index = os.path.join(month_path, '_index.md')
    dst_index = os.path.join(dst_month, '_index.md')
    if os.path.exists(src_index):
        shutil.copy2(src_index, dst_index)
    else:
        with open(dst_index, 'w', encoding='utf-8') as f:
            f.write(f'---\ntitle: "{year}年{mon}月"\n---\n')
        print(f'  ✓ 自动生成 {month}/_index.md（{year}年{mon}月）')

    # 处理月份目录中的所有 Markdown 文件
    for fname in sorted(os.listdir(month_path)):
        if not fname.endswith('.md') or fname == '_index.md':
            continue
        src = os.path.join(month_path, fname)
        dst = os.path.join(dst_month, fname)
        process_file(src, dst)
        print(f'  ✓ {month}/{fname}')

print('')
print('✅ 内容准备完成')
PYEOF
