# 🔄 我们用虚拟文件系统替代 RAG 构建 AI 文档助手

**日期**: 2026-04-04
**HN 讨论**: https://news.ycombinator.com/item?id=47629xxx

---

## 💡 核心创新：VFS vs RAG

### 传统 RAG (Retrieval-Augmented Generation) 架构

```
用户问题
    ↓
[查询向量数据库] → 检索相关文档片段 (Top-K chunks)
    ↓
[拼接成 Prompt] → "以下是从文档中检索到的相关内容：\n{chunk1}\n{chunk2}..."
    ↓
[LLM 生成回答]
```

**问题**：
- 文档被切碎成 chunk，丢失上下文
- 检索质量依赖 embedding 质量
- 无法处理结构化文档（表格、层级、交叉引用）
- 维护成本高（embedding 更新、chunk 策略调优）

### 新方案：虚拟文件系统 (Virtual Filesystem, VFS)

```
用户问题
    ↓
[AI 决定"打开哪个文件"] → 如: "让我查看 auth 模块的文档"
    ↓
[VFS 层] → 将文档映射为虚拟文件系统结构
    ├── /docs/api/auth.md          (认证 API 文档)
    ├── /docs/api/database.md      (数据库 API 文档)
    ├── /docs/guides/getting-started.md
    └── /docs/examples/auth-flow.py
    ↓
[读取文件内容] → 完整文档（非碎片）
    ↓
[LLM 基于完整上下文回答]
```

## VFS 的关键设计思想

### ① 文档 = 文件，不是 Chunk

不再将文档切割成固定大小的片段，而是**保持文档完整性**：

```python
# 传统 RAG: 文档被切成 512-token 的块
chunks = split_into_chunks(document, chunk_size=512)
# 结果: "第三章的下半部分"+"第四章的开头"混在一起

# VFS: 文档就是文件
vfs.mount("/docs", document_tree)
# 结果: AI 可以"打开"任何一个完整文档
```

### ② 目录结构 = 知识图谱

VFS 的目录层次天然形成了知识的组织结构：

```
/docs/
├── api/           ← API 参考
│   ├── auth.md
│   ├── users.md
│   └── payments.md
├── guides/        ← 使用指南
│   ├── getting-started.md
│   └── advanced/
├── examples/      ← 代码示例
└── changelog.md   ← 变更日志
```

AI 可以像人类一样"浏览"这个结构：先看目录，再决定深入哪个文件。

### ③ AI 驱动的文件访问

不是传统的关键词匹配检索，而是**让 AI 自己决定要读什么**：

```
用户: "如何实现 OAuth2 登录？"

AI 的思考过程:
1. "这是一个认证相关的问题"
2. "我应该查看 /docs/api/auth.md"
3. [读取 auth.md 的完整内容]
4. "还需要看看 /docs/examples/auth-flow.py"
5. [读取示例代码]
6. 基于两个文件的完整内容生成回答
```

## VFS 方案的优势

| 维度 | RAG | VFS |
|------|-----|-----|
| **上下文完整性** | ❌ 文档被切碎 | ✅ 完整文档 |
| **结构感知** | ❌ 无结构概念 | ✅ 目录层级 |
| **交叉引用** | ❌ 困难 | ✅ 自然支持 |
| **维护成本** | 高（embedding pipeline） | 低（文件系统） |
| **可解释性** | 低（为什么选了这个 chunk?） | 高（看了哪些文件） |
| **调试难度** | 黑盒 | 白盒 |

## 适用场景

这种方案特别适合：

- 大型技术文档库（API 文档、SDK 指南）
- 企业知识库（政策文档、流程手册）
- 教育材料（课程、教材）
- 法律/合规文档（条款引用需要精确）

## 深层启示

这篇文章反映了一个更大的趋势：

> **AI 应用正在从"以检索为中心"转向"以代理行为为中心"。**

RAG 是**被动检索范式**——系统帮你找内容。
VFS 是**主动探索范式**——AI 像人类一样主动查找和阅读。

这也解释了为什么 **MCP (Model Context Protocol)** 和 **Agent 工具调用** 正在成为新的标准接口——因为未来的 AI 不是"搜索引擎"，而是"会使用工具的研究助理"。
