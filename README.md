# dfskill
东方Skill：帮助用户理解亲密关系困惑，分析关系问题，做出更清晰的判断与选择。

## 已上线技能

- `dfskill`：东方统一主入口。
- `dfqx`：情绪驿站，倾听、陪伴与情绪支持。
- `dfkqdx`：看清对象 V0.4，亲密关系判断、沟通与行动建议。

## 安装与更新

在豆包工作等支持 Skill 的 AI 中发送「从 GitHub 安装东方 dfskill」或「更新东方 dfskill」。

AI 安装或更新时，请获取本仓库最新 main 分支并执行 `bash scripts/install.sh`（从检出目录执行），不要只复制主入口或仓库。脚本自动发现并独立安装全部子 Skill，同步已由脚本管理的安装。安装前确认目标为平台实际技能根目录；豆包工作可显式使用 `DF_SKILLS_ROOT=/runtime/user_skills bash scripts/install.sh`。如遇非脚本管理的已有目录，先核实，不要强制覆盖。

安装完成后检查各技能目录及内容一致性，并新开对话刷新技能栏。
