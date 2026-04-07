# 😂 PC Gamer 用一篇 37MB 的无限下载文章教你用 RSS (PC Gamer recommends RSS readers in a 37mb article that just keeps downloading)

**日期**: 2026-03-23
**原文链接**: [stuartbreckenridge.net](https://stuartbreckenridge.net) | [HN](https://news.ycombinator.com/item?id=47480507)
**HN 热度**: ~838 points | ~400+ comments

---

## 🎯 核心内容/论点

这是一篇**充满黑色幽默的技术讽刺作品**。作者 Stuart Breckenridge 发现 PC Gamer 网站发布了一篇推荐 RSS 阅读器的文章，但这篇文章本身就是一个**完美的 Web 反模式案例**：

### 🤯 文章的问题清单

| 问题 | 详情 |
|------|------|
| **页面大小 37MB** | 一篇文字文章重达 37 兆字节 |
| **无限滚动加载** | 页面永远不会结束，内容不断追加 |
| **自动播放视频** | 多个视频同时开始播放 |
| **大量追踪脚本** | 数十个广告和分析脚本 |
| **图片未优化** | 高分辨率图片未做任何压缩 |
| **JavaScript 臃肿** | 重度依赖 JS 渲染基本内容 |

### 💣 讽刺的核心

**一篇教人使用"轻量、简洁、去中心化"的 RSS 工具的文章，自身却是 Web 臃肿文化的极致体现。**

这种矛盾就像：
> 一个体重 300 斤的营养师在教你健康饮食

## 💡 关键洞察 / 为什么重要

### 🌐 **现代 Web 的"肥胖流行病"**

这篇文章成了一个**完美的反面教材**，展示了当前 Web 开发的系统性问题：

```
理想中的 Web:
├── 内容优先 (Content First)
├── 轻量快速 (Lightweight)
├── 可访问 (Accessible)
└── 隐私尊重 (Privacy-respecting)

现实中的 Web:
├── 追踪优先 (Tracking First)
├── 广告驱动 (Ad-driven)
├── JavaScript 重度依赖 (JS-heavy)
└── 数据收割 (Data-harvesting)
```

### 📊 **为什么 37MB？一个典型页面的解剖**

根据社区分析，这类页面通常包含：

| 组成部分 | 大小估算 | 目的 |
|----------|----------|------|
| 文章正文（纯文本） | ~50 KB | 实际内容 |
| 图片（未优化） | ~15 MB | 视觉效果 |
| 广告脚本 | ~10 MB | 变现 |
| 分析/追踪 | ~8 MB | 用户行为收集 |
| 视频（自动播放） | ~5 MB | "互动体验" |
| 第三方库（jQuery 等） | ~3 MB | 过时的依赖 |
| 字体图标 | ~2 MB | 品牌"一致性" |

**结论：实际内容不到页面总大小的 0.14%**

### 🎯 **RSS 的复兴意义**

这件事意外地成为了 **RSS 最佳广告**：
- RSS 正是为了对抗这种 Web 臃肿而生的
- 它只传输纯文本/结构化内容
- 没有追踪、没有广告、没有 JavaScript
- 你控制阅读节奏，而不是被算法投喂

## 💬 HN 社区精彩评论

> "This is peak irony — an article about RSS being the antithesis of what RSS stands for." — 讽刺的巅峰

> "37MB to tell me to use RSS... I think the article made its point better than any argument ever could." — 文章用自己的存在证明了观点

> "This should be framed and put in the Museum of Web Anti-Patterns." — 应该放进 Web 反模式博物馆

> "The fact that this got 800+ points on HN tells you everything about how fed up developers are with the modern web." — 800+ 热度说明了开发者有多厌倦现代 Web

> "I checked the page and my browser's RAM usage jumped by 500MB. For a text article." — 内存占用比页面大小更可怕

---

## 📎 延展思考

### 🛠️ 如何检查你自己的网站是否"肥胖"

```bash
# 使用 lighthouse 检查性能
npx lighthouse https://example.com --view

# 查看页面大小分布
# DevTools → Network → 勾选 "Disable cache" → 刷新
```

### 📚 相关资源

- [The 100KB Club](https://100kb.club) — 100KB 以内的精美网站展示
- [Dark Mode CSS Award](https://darkmodecss.club) — 注重性能的设计
- [1MB Club](https://1mb.club) — 1MB 以内的网站（宽松版）
- [GTmetrix](https://gtmetrix.com) — 网站性能分析工具
