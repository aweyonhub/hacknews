#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
HUGO_DIR="$PROJECT_ROOT/.github/hugo"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m'

function print_color() {
    local color=$1
    shift
    echo -e "${color}$@${NC}"
}

function clean_temp_files() {
    print_color $CYAN "正在清理临时文件..."

    items_to_remove=(
        "$HUGO_DIR/public"
        "$HUGO_DIR/resources/_gen"
        "$PROJECT_ROOT/public"
        "$HUGO_DIR/.hugo_build.lock"
        "$PROJECT_ROOT/hugo_stats.json"
    )

    for item in "${items_to_remove[@]}"; do
        if [ -e "$item" ]; then
            echo "删除: $item"
            rm -rf "$item"
        fi
    done

    print_color $GREEN "清理完成！"
}

function sync_content() {
    print_color $CYAN "正在同步内容..."

    content_dir="$HUGO_DIR/content"

    if ls "$content_dir"/2026* 1>/dev/null 2>&1; then
        rm -rf "$content_dir"/2026*
    fi

    cp -r "$PROJECT_ROOT"/2026* "$content_dir/"
    cp "$PROJECT_ROOT/README.md" "$content_dir/_index.md"

    front_matter="---
title: HackNews Digest
---

"
    current_content=$(cat "$content_dir/_index.md")
    echo -e "$front_matter$current_content" > "$content_dir/_index.md"

    print_color $GREEN "内容同步完成！"
}

function start_hugo_server() {
    print_color $CYAN "正在启动 Hugo 开发服务器..."
    print_color $YELLOW "请确保已安装 Hugo Extended 版本"

    sync_content

    cd "$HUGO_DIR"
    hugo server -D --navigateToChanged
}

function build_hugo_site() {
    print_color $CYAN "正在构建 Hugo 静态网站..."

    sync_content

    cd "$HUGO_DIR"
    hugo --minify

    print_color $GREEN "构建完成！输出目录: $HUGO_DIR/public"
}

function show_help() {
    print_color $MAGENTA "HackNews Digest - Hugo 本地开发脚本"
    echo ""
    echo "使用方法:"
    echo "  ./hugo.sh              - 启动开发服务器"
    echo "  ./hugo.sh --clean      - 清理临时文件"
    echo "  ./hugo.sh --build      - 构建静态网站"
    echo "  ./hugo.sh --help       - 显示帮助信息"
    echo ""
}

case "$1" in
    --clean)
        clean_temp_files
        ;;
    --build)
        clean_temp_files
        build_hugo_site
        ;;
    --help)
        show_help
        ;;
    *)
        if [ -z "$1" ]; then
            start_hugo_server
        else
            echo "未知选项: $1"
            show_help
            exit 1
        fi
        ;;
esac
