# Hugo 静态站点部署指南

## 🎯 已实现功能

| 功能 | 状态 | 说明 |
|------|------|------|
| ✅ 主题选择 | 完成 | PaperMod 简约美观主题，支持亮/暗自动切换 |
| ✅ 搜索功能 | 完成 | Fuse.js 全文搜索，无需后端服务 |
| ✅ 自动部署 | 完成 | GitHub Action 自动构建部署到 GitHub Pages |
| ✅ 文章同步 | 完成 | 自动同步现有 `.md` 深度解读文章到站点 |
| ✅ 周度索引 | 完成 | 自动同步 weekN.md 到周归档页面 |

---

## 🚀 部署步骤

### 1. GitHub 配置

1. 前往你的 GitHub 仓库 → **Settings** → **Pages**
2. 在 **Build and deployment** 下，**Source** 选择 **GitHub Actions**
3. 保存设置

### 2. 修改配置

编辑 `hugo/config.yml`:
```yaml
baseURL: "https://你的用户名.github.io/你的仓库名/"  # 修改为你的 GitHub Pages 地址
```

### 3. 触发部署

**方式 1：自动触发**
- 当你添加/修改 `hacknews/YYYYMM/` 目录下的 `.md` 文件时，GitHub Action 会自动运行
- 推送代码到 `main` 分支即可触发

**方式 2：手动触发**
- 前往 GitHub 仓库 → **Actions** → 选择 **部署 Hugo 站点到 GitHub Pages** → 点击 **Run workflow**

### 4. 访问站点

部署完成后，站点地址为：`https://你的用户名.github.io/你的仓库名/`

---

## 📋 部署脚本工作流程

```
代码推送 → GitHub Action 启动
   ↓
1. 检出代码 + 安装 Hugo
   ↓
2. 同步文章：
   - 复制所有深度解读 .md 文件到 hugo/content/posts/
   - 自动添加 date 字段（从文件名 YYYYMMdd 提取）
   - 复制 week*.md 到 hugo/content/weeks/
   ↓
3. Hugo 构建静态站点（minify 优化）
   ↓
4. 部署到 GitHub Pages
```

---

## 🎨 站点特性

### 主题特性
- 🎨 简约美观设计，内容优先
- 🌞🌙 亮/暗模式自动切换 + 手动切换按钮
- 📱 完美响应式，适配手机/平板/桌面
- ⚡ 极致性能，加载速度极快
- 🔍 全文搜索，支持关键词模糊匹配
- 📚 自动归档页面，按时间浏览
- ⏱️ 显示阅读时间、字数统计
- 📑 自动生成文章目录

### 搜索功能使用
- 点击导航栏「搜索」按钮
- 输入关键词即可实时搜索所有文章标题、内容、摘要
- 支持键盘快捷键：↑↓ 选择，Enter 跳转，ESC 清空

---

## 🔧 自定义配置

### 修改站点信息
编辑 `hugo/config.yml` 中的 params 部分：
```yaml
params:
  description: "你的站点描述"
  author: "你的名字"
  
  homeInfoParams:
    Title: "站点标题"
    Content: "站点介绍内容"
```

### 添加导航栏菜单
```yaml
menu:
  main:
    - name: 关于
      url: /about/
      weight: 40
```

### 添加关于页面
创建 `hugo/content/about.md`：
```markdown
---
title: "关于本站"
---

这里是关于页面的内容...
```

---

## 📝 注意事项

1. **文件名规范**：所有深度解读文章必须遵循 `YYYYMMdd-中文标题-EnglishTitle.md` 命名格式，部署脚本会自动提取日期
2. **不要修改 weekN.md**：周度索引会原样同步到站点，保持历史记录完整
3. **Front Matter**：如果文章开头有 front matter，不要删除，Hugo 会自动识别
4. **图片资源**：文章中引用的图片请放到 `hugo/static/images/` 目录下，引用路径为 `/images/xxx.jpg`

---

## 📁 项目结构

```
hacknews/
├── .github/
│   └── workflows/
│       └── deploy-hugo.yml    ← GitHub Action 部署脚本
├── hugo/
│   ├── config.yml              ← Hugo 配置文件
│   ├── content/
│   │   ├── posts/              ← 文章自动同步到这里（无需手动修改）
│   │   ├── weeks/              ← 周索引自动同步到这里（无需手动修改）
│   │   ├── archives.md         ← 归档页面
│   │   └── search.md           ← 搜索页面
│   ├── themes/
│   │   └── PaperMod/           ← PaperMod 主题
│   └── static/
│       └── assets/             ← 静态资源（图片、CSS等）
├── 202603/                      ← 现有的月度数据目录
│   ├── week1.md
│   ├── 20260321-xxx.md
│   └── ...
└── README.md                    ← 项目说明
```
