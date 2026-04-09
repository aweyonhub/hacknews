#!/usr/bin/env bash
# =============================================================
# start-hugo.sh — HackNews Digest 本地 Hugo 管理脚本
# 用法：./start-hugo.sh [命令]
# =============================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HUGO_DIR="$SCRIPT_DIR/.github/hugo"
CONTENT_DIR="$HUGO_DIR/content"
PUBLIC_DIR="$HUGO_DIR/public"
RESOURCES_DIR="$HUGO_DIR/resources"

# ── 颜色输出 ──────────────────────────────────────────────────
RED='\033[0;31m';  GREEN='\033[0;32m'
YELLOW='\033[1;33m'; BLUE='\033[0;34m'; NC='\033[0m'

info()    { echo -e "${BLUE}ℹ${NC}  $*"; }
success() { echo -e "${GREEN}✅${NC} $*"; }
warn()    { echo -e "${YELLOW}⚠️${NC}  $*"; }
error()   { echo -e "${RED}❌${NC} $*" >&2; }

# ── 帮助信息 ──────────────────────────────────────────────────
usage() {
  echo ""
  echo "用法: ./start-hugo.sh [命令]"
  echo ""
  echo "命令（不指定时默认执行 start）："
  echo "  start    准备内容并启动 Hugo 开发服务器"
  echo "  build    构建完整静态站点（输出到 .github/hugo/public/）"
  echo "  clean    清理内容目录、构建产物和缓存"
  echo "  help     显示此帮助信息"
  echo ""
  echo "示例："
  echo "  ./start-hugo.sh           # 等同于 start"
  echo "  ./start-hugo.sh start     # 启动开发服务器"
  echo "  ./start-hugo.sh build     # 生产构建"
  echo "  ./start-hugo.sh clean     # 清理临时文件"
  echo ""
}

# ── 检查 Hugo 是否已安装 ───────────────────────────────────────
check_hugo() {
  if ! command -v hugo &>/dev/null; then
    error "未找到 hugo 命令，请先安装 Hugo："
    echo "  官方下载: https://gohugo.io/installation/"
    echo "  macOS:    brew install hugo"
    echo "  Linux:    snap install hugo / apt install hugo"
    echo "  Windows:  scoop install hugo-extended"
    exit 1
  fi
  local ver
  ver="$(hugo version | head -1)"
  info "Hugo 已就绪：$ver"
}

# ── 检查 Python3 是否已安装 ────────────────────────────────────
check_python() {
  if ! command -v python3 &>/dev/null; then
    error "未找到 python3，内容预处理脚本需要 Python 3.6+"
    exit 1
  fi
}

# ── 准备 Hugo 内容目录 ─────────────────────────────────────────
prepare_content() {
  info "正在准备内容目录..."
  bash "$HUGO_DIR/scripts/prepare-content.sh"
}

# ── 启动开发服务器 ─────────────────────────────────────────────
cmd_start() {
  check_hugo
  check_python
  prepare_content

  echo ""
  success "内容就绪，启动开发服务器..."
  info  "本地访问地址：http://localhost:1313"
  warn  "按 Ctrl+C 停止服务器"
  echo ""

  cd "$HUGO_DIR"
  hugo server \
    --disableFastRender \
    --bind 0.0.0.0 \
    --port 1313
}

# ── 生产构建 ───────────────────────────────────────────────────
cmd_build() {
  check_hugo
  check_python
  prepare_content

  info "开始构建静态站点..."
  cd "$HUGO_DIR"
  hugo --minify

  echo ""
  success "构建完成！"
  info  "输出目录：$PUBLIC_DIR"
  if command -v du &>/dev/null; then
    info "站点大小：$(du -sh "$PUBLIC_DIR" 2>/dev/null | cut -f1)"
  fi
}

# ── 清理临时文件 ───────────────────────────────────────────────
cmd_clean() {
  info "正在清理临时文件..."

  local cleaned=0

  if [[ -d "$CONTENT_DIR" ]]; then
    rm -rf "$CONTENT_DIR"
    echo "  🗑  已删除：$CONTENT_DIR"
    ((cleaned++))
  fi

  if [[ -d "$PUBLIC_DIR" ]]; then
    rm -rf "$PUBLIC_DIR"
    echo "  🗑  已删除：$PUBLIC_DIR"
    ((cleaned++))
  fi

  if [[ -d "$RESOURCES_DIR" ]]; then
    rm -rf "$RESOURCES_DIR"
    echo "  🗑  已删除：$RESOURCES_DIR"
    ((cleaned++))
  fi

  echo ""
  if [[ $cleaned -eq 0 ]]; then
    info "没有需要清理的文件。"
  else
    success "清理完成，共删除 $cleaned 个目录。"
  fi
}

# ── 入口 ───────────────────────────────────────────────────────
case "${1:-start}" in
  start)             cmd_start  ;;
  build)             cmd_build  ;;
  clean)             cmd_clean  ;;
  help | -h | --help) usage     ;;
  *)
    error "未知命令：$1"
    usage
    exit 1
    ;;
esac
