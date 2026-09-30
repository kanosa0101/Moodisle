# assets-src/ · 美术源文件

- ledger.md：生成与后处理记录；新增或替换的资产应登记日期、资产 ID、工具、提示词、seed（如有）、处理过程和经手人。
- 当前 assets_manifest.json 收录 322 张 PNG：278 张与运行时规格对应的资产，另有 30 张尚未接入的表情差分、10 张 canon 设定图和 4 张过程图。
- fonts/：中文子集字体的全量母版（Noto Sans SC，SIL OFL 1.0）与授权文本；子集产物在 `app/assets/fonts/`，生成方式见 `tool/subset_font.py` 与 docs/06 §7。
- audio/original/：3 首用户提供的原始 MP3 和 10 个脚本合成 WAV；`audio/manifest.csv` 记录来源、工具/模型、prompt 或“不适用”、seed/参数、日期、权利信息和 SHA-256。运行时资源在 `app/assets/audio/`。SFX 由 `tool/generate_audio_sfx.py` 使用 Python 标准库可复现生成；BGM 原文件按位复制后临时按标题映射晴朗/薄雾/夜晚。用户未提供的模型、提示词、日期和授权信息标注“未提供”；不从 C2PA 签名推断模型或授权。详见 docs/06 §6。
- python tool/asset_pipeline.py todo 检查运行时规格中的 278 个目标；validate 校验已存在的目标文件，manifest 重建本目录 PNG 的尺寸、字节数和 SHA256 清单，deploy 复制登记路径中可读取且透明度符合要求的 PNG 到 app/assets/。尺寸检查需先单独运行 validate。
- 资产目录结构与描述以 [美术资产管线](../docs/06-AI美术资产管线.md) 和 [资产描述总表](../docs/08-美术资产描述总表.md) 为准。
- 未登记来源或生成记录的资产不应作为正式素材发布。process/ 中的过程文件保留在证据链中，不随运行时资源部署。
