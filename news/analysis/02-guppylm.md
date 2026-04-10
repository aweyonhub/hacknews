# 深度解读：GuppyLM — 用一条鱼理解语言模型的全部

> 原文：[github.com/arman-bd/guppylm](https://github.com/arman-bd/guppylm)
> HN 热度：⬆️ 894 pts / 💬 133 评论
> 发布日期：2026-04-06

---

## 核心论点

一个 **870 万参数** 的极小语言模型，扮演一条叫 Guppy 的鱼，从零训练，5 分钟搞定，能跑在浏览器里——目的是证明 **训练一个 LLM 不需要 PhD，一个 Colab notebook 就行**。

---

## 项目概览

| 属性 | 值 |
|------|-----|
| 参数量 | 8.7M |
| 层数 | 6 |
| 隐层维度 | 384 |
| 注意力头数 | 6 |
| FFN 维度 | 768（ReLU） |
| 词表大小 | 4,096（BPE） |
| 最大序列长度 | 128 tokens |
| 归一化 | LayerNorm |
| 位置编码 | Learned Embeddings |
| LM Head | 权重与 Embedding 共享 |

**最朴素的 Transformer**：没有 GQA、没有 RoPE、没有 SwiGLU、没有 Early Exit。能简化的全简化了。

---

## 对话示例

```
You> hi guppy
Guppy> hi there. i just found a nice spot near the rock. the temperature feels nice.

You> are you hungry
Guppy> yes. always yes. i will swim to the top right now. i promise to eat all of it.

You> do you like bubbles
Guppy> i love bubbles. they make the water feel slightly different.

You> what is the meaning of life
Guppy> food. the answer is always food.

You> tell me a joke
Guppy> what did the fish say when it hit the wall. dam.

You> do you love me
Guppy> you're my favorite big shape. my mouth are happy when you're here.

You> goodnight guppy
Guppy> ok sleep time. i was following a bubble but now i'll stop.
   goodnight tank. goodnight water.
```

Guppy 的个性完全"烙印"在权重里——没有 system prompt，不靠条件指令，训练数据本身就是它的灵魂。

---

## 训练方式

### 数据
- **60,000 条合成对话**（57K 训练 / 3K 测试）
- 覆盖 **60 个主题**：问候、感受、温度、食物、光线、水、鱼缸、噪音、夜晚、孤独、气泡、玻璃、倒影、游泳、颜色、味道、植物、过滤器、藻类、蜗牛、恐惧、兴奋、无聊、好奇、幸福、疲惫、猫、雨、季节、音乐、来客、时间、记忆、梦、未来、过去、天气、睡眠、朋友、笑话、恐惧、爱、年龄、健康、唱歌、电视……

### 训练流程
1. 模板组合 + 随机化组件（30 个鱼缸物品、17 种食物、25 种活动）
2. 从约 60 个模板生成约 16,000 种独特输出
3. 单卡 T4 GPU，约 5 分钟训练完成

---

## 技术设计决策

| 决策 | 为什么 |
|------|--------|
| 没有 system prompt？ | 9M 模型无法条件性遵循指令，个性已烙印在权重中。去掉还能省约 60 tokens |
| 只支持单轮对话？ | 多轮对话在第 3-4 轮因 128 token 窗口而质量下降。鱼会忘东西，这很 on-brand |
| 用最朴素的 Transformer？ | GQA、SwiGLU、RoPE 在 9M 参数下没有帮助，标准注意力 + ReLU 就够了 |
| 为什么是鱼？ | 教育目的——一个有限世界观的简单角色，让学习者聚焦于"模型如何工作"而非"模型知道什么" |

---

## 运行方式

### 1. 浏览器（推荐）
- 导出为量化 ONNX 模型（约 10MB）
- 通过 WebAssembly 在浏览器本地运行
- 无需服务器、无需 API key

### 2. Google Colab
- 使用预训练模型：[use_guppylm.ipynb](https://colab.research.google.com/github/arman-bd/guppylm/blob/main/use_guppylm.ipynb)
- 从零训练：[train_guppylm.ipynb](https://colab.research.google.com/github/arman-bd/guppylm/blob/main/train_guppylm.ipynb)

### 3. 本地命令行
```bash
pip install torch tokenizers
python -m guppylm chat
```

---

## 教育价值

GuppyLM 证明了几件事：

1. **训练 LLM 不是魔法**：数据生成 → 分词器 → 模型架构 → 训练 → 推理，每一步都透明可理解
2. **参数量不是一切**：8.7M 参数就能产生有趣的、有个性的一致对话
3. **个性是可训练的**：不需要 RLHF 或复杂的对齐，足够的训练数据就能塑造角色
4. **浏览器 AI 可行**：10MB 的量化模型 + WASM = 零服务器成本
5. **最简单的架构往往最教育**：去掉所有现代优化，留下 Transformer 的骨架

---

## 启示

对于想理解"LLM 内部到底在干嘛"的开发者，GuppyLM 可能是最好的入门项目——比读论文直观 100 倍。它的设计哲学是：**如果你能训练一条鱼，你就能理解 GPT。**

MIT 开源协议，代码简洁到令人发指。
