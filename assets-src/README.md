# assets-src/ · 美术源文件

- ledger.md：生成与后处理记录；新增或替换的资产应登记日期、资产 ID、工具、提示词、seed（如有）、处理过程和经手人。
- 当前 assets_manifest.json 收录 322 张 PNG：278 张与运行时规格对应的资产，另有 30 张尚未接入的表情差分、10 张 canon 设定图和 4 张过程图。
- python tool/asset_pipeline.py todo 检查运行时规格中的 278 个目标；validate 校验已存在的目标文件，manifest 重建本目录 PNG 的尺寸、字节数和 SHA256 清单，deploy 复制登记路径中可读取且透明度符合要求的 PNG 到 app/assets/。尺寸检查需先单独运行 validate。
- 资产目录结构与描述以 [美术资产管线](../docs/06-AI美术资产管线.md) 和 [资产描述总表](../docs/08-美术资产描述总表.md) 为准。
- 未登记来源或生成记录的资产不应作为正式素材发布。process/ 中的过程文件保留在证据链中，不随运行时资源部署。
