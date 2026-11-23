# 让 Mac 和 Windows 跑自己的 AI｜把 Linger 部署交给 Agent
![Linger 本地部署封面](assets/cover.webp)


把这个仓库发给能操作目标电脑的 Agent，就能让它检查硬件、安装 Linger、选合适的本地模型，并用一次真实任务确认跑在预期设备上。Mac 和 Windows 都可以独立部署，也可以在 Windows 提交任务、让 Mac 执行。

## 把这段话发给你的 Agent

在准备安装的电脑上打开有终端权限的 Codex、Claude Code 或其他 Agent。把下面整段发给它，就可以从硬件检查开始。

```text
请在我这台电脑部署 Linger：https://github.com/pche2020/linger-local-deploy
先读取仓库的 AGENTS.md，检查硬件和已有安装。复用已有配置，按检查结果推荐部署方式和模型。
请代我完成当前电脑上的下载、校验、安装、配置和验收。需要登录、授予权限、连接另一台电脑、下载大型模型或更改已有配置时，先告诉我具体动作并等我确认。
如果我指定了模型，资源不足就报告缺口，等我释放资源。验收后告诉我怎么启动、停止，以及模型文件在哪里。
```

| Agent 会做什么 | 什么时候需要你 |
| --- | --- |
| 检查操作系统、芯片、内存、显存、驱动和磁盘，复用已经装好的应用与 Runtime | 要连接另一台电脑或使用新的账号权限时，先确认连接对象和用途 |
| 下载并校验官方安装包，安装并打开 Linger。界面可操作时继续完成已获准的配置 | 你本人完成账号登录、系统首次运行确认和权限授权。模型下载前确认模型、大小和目标盘 |
| 验证真正执行任务的设备和模型，试跑一次临时任务，卸载测试模型并保留文件 | 切换现用模型、退出有任务的应用、升级现有安装或重启设备时，先确认影响 |

有桌面操作能力的 Agent 可以继续点安装向导。只有终端权限的 Agent 会把应用打开，并在必须操作界面时告诉你具体点哪里。Windows Agent 安装入口会在确认是全新安装时使用官方安装器的安静模式，Mac 入口会安装并打开应用。手动安装命令见三个部署流程。 [Agent 执行手册](AGENTS.md)

## 本地部署能解决什么问题

| 你遇到的场景 | 可以怎么做 | 最后能拿到什么 |
| --- | --- | --- |
| 会议纪要在 Mac 的 Obsidian 库里，想整理内部项目 | 在 Mac 独立部署，用本地模型读一个已授权的项目目录，先生成纪要副本，按「决策、待办、负责人、日期」提取 | 一份 Markdown 纪要和待办表。原笔记保留，推理在 Mac 上完成 |
| Windows 上积累了构建日志、脚本输出和待整理文件 | 用 Windows 独立模式的轻量模型，先归类错误日志和重复条目，在临时目录输出结果 | 带原日志文件名的错误清单、复现线索或 CSV，便于比对后再处理源文件 |
| 剪辑或 ComfyUI 占着 Windows 显卡，资料还在 Mac | 在 Windows 打开 Mac 上的 Linger，选执行位置为 Mac 的 Agent，针对 Mac 工作区做摘要或批次整理 | Windows 上可以提交和查看任务，Mac 负责处理，Windows 显卡可以继续用于原任务 |
| 只有遇到长文或多份材料才想用 27B | 在硬件达标时保留 27B 权重，使用前检查资源，加载后分批对照材料并要求列出处 | 可复核的差异表或草稿。完成后卸载模型，显存和内存留给其他应用 |
| 经常试会议模板、写代码草稿或批量整理工作日志 | 下载完成后，用本地模型反复运行同一份模板，将输入和生成物留在你指定的工作区 | 可以反复生成结果，无需按次调用云模型。机器仍会消耗电力，速度由硬件决定 |
| 网络不稳定，仍要整理已经下载的资料 | 提前下载模型和所需文件，选独立模式和本地模型，任务只读取已有资料 | 能继续做本地摘要、改写和分类。联网搜索、远程访问和云端工具需要各自的连接 |

本地模型处理推理时，执行设备负责读文件和运行模型。房间、聊天和文档由所选的 Linger 服务保存。启用云模型、网页搜索或外部连接器时，按各自的数据流核对权限。 [数据存放位置](https://docs.heylinger.com/concepts/where-your-data-lives) · [数据和隐私](https://docs.heylinger.com/security/data-and-privacy)

## 选择部署方式

| 配置 | 服务与记录 | 执行 Agent 和模型 | 适合什么时候选 |
| --- | --- | --- | --- |
| [Mac 单独执行](docs/mac.md) | Mac 本机 | Mac，Metal | 常处理 Mac 上的笔记、文档或代码，想在一台机器内把流程跑通 |
| [Windows 单独执行](docs/windows.md) | Windows 本机 | Windows，CUDA | 文件在 Windows，或有 NVIDIA 独显，需要轻模型和 27B 分别按需使用 |
| [从 Windows 提交给 Mac](docs/windows-via-mac.md) | Mac 上的 Linger 服务 | Mac，Metal | Windows 负责操作界面，Mac 保持在线并执行任务，适合资料只在 Mac 或 Windows 显卡正在使用 |

切换入口时，按服务地址、Agent 的执行设备和模型来源逐项核对。两个独立 Linger 服务分别保存各自的聊天。

## Mac 与 Windows 配置对比

安装脚本以 **Linger Desktop 0.1.6** 为基线。该版本捆绑 `localmodels 0.1.0.dev45`。硬件参考来自官方 `0.1.0.dev41` 的模拟配置，实际选择以目标机安装向导和可用资源为准。 [官方发布](https://github.com/simplexai-labs/linger/releases/tag/desktop-v0.1.6) · [官方硬件表](https://docs.heylinger.com/hardware/compatibility)

| 项目 | Mac | Windows |
| --- | --- | --- |
| 官方桌面要求 | Apple silicon，macOS 14 或更新 | Windows 11 x64。本地模型计划要求受支持的 NVIDIA GPU 和 CUDA 驱动 |
| 资源瓶颈 | CPU 与 GPU 共用统一内存，Metal 也有工作集限制 | 可用系统 RAM、空闲独立 VRAM 分别达标，还要留意显示和其他 GPU 程序 |
| 27B 引擎 | llama.cpp + Metal | 原生 llama.cpp + CUDA |
| 官方安装包 | `Linger-0.1.6-macos-arm64.dmg` | `Linger-0.1.6-windows-x64-setup.exe`，另有便携 ZIP |
| 典型 27B 起点 | 24 GiB 统一内存，`UD-IQ3_S`，64K 共享上下文 | 16 GiB 独显，`UD-IQ3_S`，64K 共享上下文。官方参考机另有 32 GiB 系统 RAM |
| 释放方式 | 模型页点 **Unload**，检查内存和活动任务 | 模型页点 **Unload**，复测系统 RAM 和 `nvidia-smi` |

### 硬件对应模型

以下是官方自动计划参考。Mac 以统一内存容量分档。Windows 以 NVIDIA 总显存分档，参考的系统内存配置在最后一列。从 Windows 使用 Mac 执行时，要查 **Mac** 的硬件行。较长上下文需要更多 KV 缓存。64K 和 128K 分别是 65,536 和 131,072 tokens，两并发槽共享所列预算。

| 平台和容量 | 模型 | 量化 | 共享上下文 | 参考系统 RAM |
| --- | --- | --- | --- | --- |
| Mac 8 GiB | 无自动本地计划 | — | — | 统一内存 |
| Mac 16 GiB | Spark-X2.6-4B | `Q4_K_M` | 64K | 统一内存 |
| Mac 24 GiB | Qwen3.8-27B | `UD-IQ3_S` | 64K | 统一内存 |
| Mac 32 GiB | Qwen3.8-27B | `UD-Q4_K_M` | 128K | 统一内存 |
| Mac 48、64 GiB | Qwen3.8-27B | `UD-Q4_K_M` | 200,000 | 统一内存 |
| Mac 96 GiB | Qwen3.8-Flash-Next | `GSQ-RCO-IQ2_XS` | 200,000 | 统一内存 |
| Mac 128、256 GiB | Qwen3.8-Flash-Next | `GSQ-RCO-IQ3_S` | 200,000 | 统一内存 |
| Windows 8 GiB | Spark-X2.6-4B | `Q8_0` | 64K | 32 GiB |
| Windows 12 GiB | Spark-X2.6-4B | `Q8_0` | 200,000 | 32 GiB |
| Windows 16 GiB | Qwen3.8-27B | `UD-IQ3_S` | 64K | 32 GiB |
| Windows 24 GiB | Qwen3.8-27B | `UD-Q4_K_M` | 128K | 64 GiB |
| Windows 32、48 GiB | Qwen3.8-27B | `UD-Q4_K_M` | 200,000 | 64 GiB |
| Windows 96 GiB | Qwen3.8-27B | `UD-Q4_K_M` | 200,000 | 128 GiB |

官方模拟中，24 GiB Mac 的 27B/64K 配置约需 **21 GiB 可用统一内存**。Windows 在官方模拟里，`UD-IQ3_S` 64K 约需 **14.5 GiB 空闲显存**。官方 16 GiB 卡的 Linux 表给出了约 **18.25 GiB 可用 RAM** 的 27B 模拟参考，Windows 这档的表格显示的是 4B 的最低可用 RAM。可把 18.25 GiB 用作 Windows 16 GiB 卡的初筛值，正式加载使用该机器实际计划显示的门槛。Windows 8–12 GiB 档的 Spark 仍标为候选，16 GiB 卡以上的 Windows 可用方案也取决于驱动、当前空闲和实际计划。 [官方硬件表及其测试假设](https://docs.heylinger.com/hardware/compatibility)

## 三种模式的卡点

| 模式 | 常见卡点 | 解决方式 |
| --- | --- | --- |
| Mac 独立 | 能看到已下载的 27B，但统一内存／Metal 工作集不足 | 以 Mac 当前读数和计划的门槛为准。保存工作后由用户释放资源，重新检查 27B |
| Windows 独立 | 用 4B 的房间去测 27B，或以为进了 Windows 页面就一定用 Windows 推理 | 分开标记两个入口，任务前核对 Windows、Runtime 和模型。27B 不足时保持目标并暂停 |
| Windows 依赖 Mac | SSH 黑窗口安静、两模式的聊天看起来少了、Mac 休眠后打不开页面 | 无输出可通过 Windows 的浏览器核对链路。回到原服务找聊天。先确认 Mac 在线和实际端口，再核对 Agent 是否被派到 Mac |

## 通用排障

| 症状 | 查哪里 | 怎么处理 |
| --- | --- | --- |
| 两端显示同一个登录邮箱，但找不到另一台计算机 | 登录页对应的服务地址和 **Computers／计算机** 列表 | 若要从同一服务管理两端，分别确认设备已连接到这个服务。在 Agent 配置和推理日志核实执行机 |
| 登录页问 `owner@linger.local` 的密码 | 首次完成页的本地账号卡，以及当前登录页实际指向的服务 | 在对应服务的 Quick Install 完成页选 **Show**。Quick Install 随机生成密码。账号文件只在对应设备本地查阅，登录时用户直接在页面输入 |
| Mac 说应用无法验证，Windows 显示 SmartScreen | 官方发布页的 SHA 清单和报错原因 | 核对下载内容再按照官方首次启动步骤处理。组织设备遇到策略拦截时由管理员处理 |
| 安装器能看到 NVIDIA 卡，却不给 27B | 驱动、CUDA 探测、当前空闲 RAM／VRAM、安装路径空间 | 按提示从 NVIDIA 官方更新驱动并重检。按计划报出资源缺口，用户保存工作并释放资源后重试 |
| 自动计划只给 4B，目标是 27B | 模型名、量化、共享上下文、每个内存池 | 暂停确认安装。目标继续保留 27B，资源释放后重计划。硬件确实不足时由使用者决定接受哪个替代方案 |
| 关窗口后显存还在用 | 窗口可能最小化到菜单栏或托盘，推理进程仍在 | 先保存内容并检查活动任务，在模型页点 **Unload**。再看状态和显存，避免直接杀进程 |
| 卸载后重开应用又加载 | 向导的已批准计划、系统登录项、桌面版恢复流程 | 关闭开机自启并测试应用重开。某些安装会恢复已批准的模型栈，若重开自动加载，要明确记为未满足按需加载 |
| 权重下载中断或校验失败 | 模型状态、下载目录权限、可用磁盘 | 用模型页的 **Resume download** 继续。完整性失败时按错误提示重新获取对应文件 |
| Agent 列表里有 CLI 但无法执行 | CLI 是否新终端可见、账号登录、Runtime 检查 | 按智能体手册逐项检查。做本地模型验收时核对 Runtime 与模型来源，避免误测到云端 |

更多操作和命令见 [Mac 独立](docs/mac.md)、[Windows 独立](docs/windows.md)、[Windows 依赖 Mac](docs/windows-via-mac.md) 和 [官方排障](https://docs.heylinger.com/admin/troubleshooting)。

## 仓库结构

```text
linger-local-deploy/
├── README.md                 # 项目首页、发给 Agent 的启动词、模型对照
├── AGENTS.md                 # Agent 安装、确认、验收与交付流程
├── CLAUDE.md                 # Claude Code 的项目指引入口
├── install-macos.sh          # Mac 硬件检查、校验、安装与打开应用
├── install-windows.ps1       # Windows 硬件检查、校验与 Agent 安装
├── open-windows-mac.ps1      # 使用已获准的 SSH 路径从 Windows 访问 Mac
├── docs/
│   ├── mac.md                # Mac 独立部署
│   ├── windows.md            # Windows 独立部署
│   └── windows-via-mac.md    # Windows 提交任务给 Mac
└── LICENSE                   # MIT
```

## 许可

本指南原创建议和安装辅助脚本采用 [MIT](LICENSE)。安装时从上游取得的 Linger 程序、模型和 Agent CLI 使用各自的上游许可。 [Linger 许可](https://github.com/simplexai-labs/linger/blob/desktop-v0.1.6/LICENSE)
