# HackNews Digest Hugo 部署指南

本项目使用 **Hugo + PaperMod 主题** 构建静态网站，支持全文搜索功能，可一键部署到 GitHub Pages。

## 🎨 特性

- ✨ **简约美观**：基于 PaperMod 主题，响应式设计
- 🔍 **全文搜索**：Fuse.js 客户端模糊搜索，离线可用
- 📱 **移动端友好**：自适应各种屏幕尺寸
- ⚡ **自动部署**：GitHub Actions 自动构建和发布
- 📁 **自动同步**：自动同步根目录下的所有 markdown 文章

## 🚀 快速开始

### 1. 本地部署

#### 前置条件

- 安装 [Hugo Extended](https://gohugo.io/installation/)（必须是 extended 版本）
- 安装 [Git](https://git-scm.com/)

#### 步骤

```bash
# 1. 克隆项目
git clone https://github.com/yourusername/hacknews.git
cd hacknews

# 2. 初始化 PaperMod 主题（第一次运行）
git submodule add https://github.com/adityatelange/hugo-PaperMod.git .github/hugo/themes/PaperMod

# 3. 同步内容到 Hugo 目录
cp -r 2026* .github/hugo/content/
cp README.md .github/hugo/content/_index.md
# 给 index 添加 front matter
sed -i '1s/^/---\ntitle: HackNews Digest\n---\n\n/' .github/hugo/content/_index.md

# 4. 启动本地开发服务器
cd .github/hugo
hugo server -D

# 访问 http://localhost:1313 查看网站
```

### 2. GitHub Pages 部署

#### 前置条件

- 你的项目托管在 GitHub
- 已经启用 GitHub Pages 功能（设置 → Pages → Source 选择 "GitHub Actions"）

#### 步骤

1. **修改配置文件**

   编辑 `hugo.toml`，将 `baseURL` 修改为你的 GitHub Pages 地址：
   ```toml
   baseURL = "https://yourusername.github.io/hacknews/"
   ```

2. **修改菜单链接**

   编辑 `hugo.toml` 中的 GitHub 菜单项：
   ```toml
   [[menu.main]]
     identifier = "github"
     name = "GitHub"
     url = "https://github.com/yourusername/hacknews"
     weight = 30
     params.external = true
   ```

3. **提交代码到 main 分支**
   ```bash
   git add .
   git commit -m "chore: add hugo deployment config"
   git push origin main
   ```

4. **启用 GitHub Pages**
   - 进入仓库 → Settings → Pages
   - 在 "Build and deployment" → "Source" 选择 "GitHub Actions"
   - 保存设置

5. **自动部署**
   - 每次 push 到 main 分支时，GitHub Actions 会自动构建并部署
   - 部署完成后，访问 `https://yourusername.github.io/hacknews/` 查看网站

## 📁 目录结构

```
.github/hugo/
├── content/           # 自动同步的文章内容
├── layouts/           # 自定义模板
│   └── _default/
│       ├── search.html   # 搜索页面模板
│       └── archives.html # 归档页面模板
├── static/            # 静态资源
│   ├── css/
│   └── js/
│       ├── fuse.min.js   # Fuse.js 搜索库
│       └── search.js     # 搜索逻辑
├── themes/            # Hugo 主题（PaperMod）
├── hugo.toml          # Hugo 配置文件
└── README.md          # 本文件
```

## ⚙️ 配置说明

### 搜索功能

默认已经启用 Fuse.js 全文搜索，支持：
- 标题和内容模糊匹配
- 搜索结果高亮
- 最小匹配长度 2 个字符
- 相似度阈值 0.3

可以在 `hugo.toml` 的 `[params.search]` 部分调整搜索参数。

### 主题配置

PaperMod 主题支持丰富的配置选项，详细请参考：
https://github.com/adityatelange/hugo-PaperMod/wiki/Features

## 📝 更新内容

所有文章都存放在项目根目录下的 `YYYYMM/` 文件夹中，每次 push 到 main 分支时，GitHub Actions 会自动：
1. 同步所有 markdown 文章到 Hugo 的 content 目录
2. 构建静态网站
3. 发布到 GitHub Pages

无需手动操作 Hugo 目录下的内容。

## 🎯 功能清单

- [x] 自动同步文章内容
- [x] 全文搜索功能
- [x] 归档页面（按月份分组）
- [x] 响应式设计
- [x] 暗色/亮色主题切换
- [x] 阅读时间统计
- [x] 代码复制按钮
- [x] RSS 订阅
