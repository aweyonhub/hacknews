# HackNews Digest - 静态站部署指南

## 技术栈

| 组件 | 选择 | 理由 |
|------|------|------|
| **静态站生成器** | [Hugo](https://gohugo.io/) | 极速构建，Go编写，中文支持好 |
| **主题** | [PaperMod](https://github.com/adityatelange/hugo-PaperMod) | 简约美观、响应式、内置Fuse.js搜索、暗色模式、阅读体验优秀 |
| **搜索** | Fuse.js (客户端模糊搜索) | 无需后端，离线可用，中文分词友好 |
| **部署** | GitHub Pages + Actions | 免费、自动CI/CD、自定义域名支持 |

## 快速开始

### 1. 初始化仓库

```bash
cd hacknews
git init
git add .
git commit -m "init: HackNews Digest project"
git remote add origin https://github.com/<your-username>/hacknews.git
git push -u origin main
```

### 2. 启用 GitHub Pages

Settings → Pages → Source: **GitHub Actions**

### 3. 修改配置

编辑 `.claude/asset/github/hugo/hugo.toml`：
```toml
baseURL = 'https://<your-username>.github.io/hacknews/'
```

编辑 `.claude/asset/github/deploy.yml` 中 socialIcons 的 URL：
```yaml
url = "https://github.com/<your-username>/hacknews"
```

### 4. 推送即部署

```bash
git add .claude/asset/github/
git commit -m "add: hugo site + github actions"
git push
```

推送后自动触发构建 → 部署到 GitHub Pages。

## 本地预览

```bash
# 安装 Hugo (需要 extended 版本)
# macOS: brew install hugo
# Windows: choco install hugo-extended
# Linux: snap install hugo

cd .claude/asset/github/hugo

# 安装主题
git clone --depth=1 https://github.com/adityatelange/hugo-PaperMod themes/PaperMod

# 同步内容
bash ../sync-content.sh

# 启动本地服务器
hugo server -D --bind 0.0.0.0 --baseURL http://localhost:1313/

# 浏览 http://localhost:1313/
```

## 文件结构

```
.claude/asset/github/
├── deploy.yml           # GitHub Actions 工作流（自动构建+部署）
├── sync-content.sh      # 本地同步脚本：项目md → Hugo content
└── hugo/
    ├── hugo.toml        # 主配置文件
    ├── content/
    │   ├── posts/       # 深度解读文章（自动生成）
    │   ├── search/_index.md    # 搜索页
    │   └── archives/_index.md  # 归档页
    ├── layouts/_default/
    │   ├── search.html         # 搜索页面模板（Fuse.js）
    │   └── archives.html       # 归档页面模板
    ├── static/images/   # favicon等图片资源
    └── themes/          # PaperMod主题（git submodule或clone）
```

## PaperMod 主题特性

- ✅ **暗色/亮色模式** 自动跟随系统
- ✅ **全文搜索** Fuse.js 客户端模糊匹配
- ✅ **响应式设计** 手机/平板/桌面完美适配
- ✅ **阅读优化** 目录导航、代码高亮、复制按钮
- ✅ **SEO友好** Open Graph、RSS、Sitemap
- ✅ **多语言支持** 中文渲染完美

## 自定义域名（可选）

1. 在 repo 根目录创建 `CNAME` 文件，写入你的域名
2. DNS 配置：
   ```
   A     185.199.108.153
   A     185.199.109.153
   A     185.199.110.153
   A     185.199.111.153
   CNAME  <your-username>.github.io.
   ```
3. 更新 `hugo.toml` 的 `baseURL`
