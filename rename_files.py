
import os
import re

# 定义文件重命名映射
rename_map_202603 = {
    '20260321-opencode-开源ai编程代理.md': '20260321-opencode-ai-coding-agent.md',
    '20260322-windows原生应用开发现状一团糟.md': '20260322-windows-native-apps-mess.md',
    '20260323-github可用性挣扎于三个九.md': '20260323-github-availability-three-nines.md',
    '20260323-pc-gamer-rss文章反模式.md': '20260323-pc-gamer-rss-anti-pattern.md',
    '20260323-代码消亡的报告被严重夸大了.md': '20260323-death-of-code-exaggerated.md',
    '20260323-移民到欧盟.md': '20260323-immigrating-to-eu.md',
    '20260324-claude-code速查表.md': '20260324-claude-code-cheatsheet.md',
    '20260324-wine11-内核级重写.md': '20260324-wine11-kernel-rewrite.md',
    '20260325-video.js-16年后重写缩小88%.md': '20260325-videojs-rewrite-shrink-88-percent.md',
    '20260326-shell-技巧让生活更轻松.md': '20260326-shell-tricks-make-life-easier.md',
    '20260326-个人百科全书.md': '20260326-personal-encyclopedia.md',
    '20260326-为什么控制室都是海沫绿.md': '20260326-why-control-rooms-seafoam-green.md',
    '20260326-伊朗战争杂记.md': '20260326-iran-war-notes.md',
    '20260327-claude文件夹解剖.md': '20260327-claude-folder-anatomy.md',
    '20260328-让macos持续地烂得一致.md': '20260328-macos-consistently-bad.md',
    '20260330-copilot-pr-ads.md': '20260330-copilot-pr-ads.md',
    '20260330-复古demo场景图形.md': '20260330-retro-demo-scene-graphics.md',
    '20260330-认知暗森林-the-cognitive-dark-forest.md': '20260330-cognitive-dark-forest.md'
}

rename_map_202604 = {
    '20260401-claude-code-unpacked.md': '20260401-claude-code-unpacked.md',
    '20260401-claude-code解包完整版.md': '20260401-claude-code-unpacked-full.md',
    '20260402-gemma4.md': '20260402-gemma4.md',
    '20260402-qwen3.6-plus.md': '20260402-qwen3.6-plus.md',
    '20260404-vfs-replace-rag.md': '20260404-vfs-replace-rag.md',
    '20260406-claude-code在复杂工程任务中不可用.md': '20260406-claude-code-unusable-complex-tasks.md',
    '20260406-guppylm-用一条鱼理解语言模型的全部.md': '20260406-guppylm-fish-understand-llms.md',
    '20260407-vibe-coding文化批判.md': '20260407-vibe-coding-critique.md',
    '20260407-battle-for-wesnoth-20年开源传奇.md': '20260407-battle-for-wesnoth-20-years.md',
    '20260408-美伊达成临时停火协议.md': '20260408-us-iran-ceasefire.md',
    '20260408-glm-5.1-面向长周期任务.md': '20260408-glm-5.1-long-horizon-tasks.md'
}

def rename_files_in_dir(dir_path, rename_map):
    if not os.path.exists(dir_path):
        print(f'目录不存在: {dir_path}')
        return
    
    for old_name, new_name in rename_map.items():
        old_path = os.path.join(dir_path, old_name)
        new_path = os.path.join(dir_path, new_name)
        
        if old_name == new_name:
            continue
            
        if os.path.exists(old_path):
            os.rename(old_path, new_path)
            print(f'重命名: {old_name} → {new_name}')
        else:
            print(f'文件不存在: {old_name}')

# 执行重命名
base_dir = os.path.dirname(os.path.abspath(__file__))
rename_files_in_dir(os.path.join(base_dir, '202603'), rename_map_202603)
rename_files_in_dir(os.path.join(base_dir, '202604'), rename_map_202604)

print('\n✅ 文件重命名完成！')

