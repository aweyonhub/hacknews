# Hugo 站点部署指南

## 已完成配置

### 1. GitHub Action 自动部署脚本
- 文件位置：`.github/workflows/deploy.yml`
- 功能：代码推送到main分支后自动构建并部署到GitHub Pages
- 特性：
  - 自动拉取主题子模块
  - 使用最新版Hugo扩展版
  - 构建时自动压缩静态资源
  - 自动上传构建产物并部署

### 2. Hugo 配置文件
- 文件位置：`.github/config.toml`
- 主题选用：PaperMod（简约美观、性能优秀、内置搜索功能）
- 已启用功能：
  - ✅ Fuse.js 全文离线搜索功能
  - ✅ 亮/暗色模式切换（默认跟随系统）
  - ✅ 代码高亮 + 行号显示
  - ✅ 阅读时长/字数统计
  - ✅ 面包屑导航
  - ✅ 自动生成文章目录
  - ✅ 响应式布局，完美适配移动端

## 部署步骤

### 第一步：安装PaperMod主题
```bash
# 进入项目目录
cd d:\awey\ai\hacknews

# 添加PaperMod为子模块
git submodule add --depth=1 https://github.com/adityatelange/hugo-PaperMod.git themes/PaperMod
git submodule update --init --recursive
```

### 第二步：修改配置
1. 打开 `.github/config.toml`
2. 修改 `baseURL` 为你的GitHub Pages实际地址，如：`https://你的用户名.github.io/仓库名/`
3. 修改 `author` 和社交链接等个人信息

### 第三步：启用GitHub Pages
1. 进入GitHub仓库的Settings页面
2. 找到Pages选项
3. 在Build and deployment下，Source选择"GitHub Actions"
4. 保存设置

### 第四步：推送代码
```bash
git add .
git commit -m "feat: 添加Hugo配置和部署脚本"
git push origin main
```

推送完成后，GitHub Action会自动执行构建和部署流程，大约1-2分钟后站点即可访问。

## 搜索功能说明
PaperMod内置的Fuse.js搜索功能无需额外配置，构建时会自动生成搜索索引。访问站点的`/search/`路径即可使用搜索功能，支持中文全文搜索。

## 本地预览
```bash
# 安装Hugo后运行本地预览，指定配置文件路径
hugo server -D --config .github/config.toml
```
访问 http://localhost:1313 即可查看本地效果。
