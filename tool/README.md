# tool/ · 项目工具

| 文件 | 用途 |
|---|---|
| asset_pipeline.py | 标准库脚本：todo 查看 278 个运行时目标的缺失情况；validate 校验已存在 PNG 的尺寸和透明通道；mirror 生成缺少的角色右向镜像（需要 Pillow）；manifest 写入 PNG 路径、尺寸、字节数与 SHA256；deploy 复制登记路径中可读取且透明度符合要求的 PNG 到 app/assets/，尺寸检查需先单独运行 validate；all 按校验、镜像、清单、部署顺序执行。 |
| intake_picture.py | 使用 Pillow 将指定下载目录中的素材重命名、裁切/缩放并接入 assets-src/。脚本中的下载目录是本机路径，换环境前需调整。 |
| ip_scan.py | 按 docs/00 的禁用词表扫描源码、文档和源资产文本，可手动运行 python tool/ip_scan.py .。当前仓库未配置 GitHub Actions 等 CI 工作流。 |
| coverage_report.py | 从 app/coverage/lcov.info 汇总 domain 行覆盖率；需先运行 flutter test --coverage。 |

脚本细节和资产规则见 [docs/06](../docs/06-AI美术资产管线.md)。asset_pipeline.py manifest 只从 PNG 文件生成清单，不会与 ledger.md 自动交叉校验。
