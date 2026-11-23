# Linger 本地部署指南

选择 Mac 独立、Windows 独立或从 Windows 使用 Mac 三种 Linger 部署方式。按实际执行机的硬件选模型，再用任务结果和设备资源变化验收。本文以 **Linger Desktop 0.1.6** 为安装基线。该版本捆绑 `localmodels 0.1.0.dev45`，硬件参考表来自官方 `0.1.0.dev41` 的模拟配置，以实际安装向导的计划和本机验收为准。 [官方发布](https://github.com/simplexai-labs/linger/releases/tag/desktop-v0.1.6) · [官方硬件表](https://docs.heylinger.com/hardware/compatibility)

## 本地部署能解决什么问题

| 场景 | 做法 | 得到什么 |
| --- | --- | --- |
| 私密笔记、内部文档、离线素材 | 在自管设备上用本地模型提取要点、分类或起草 | 推理内容留在选定的本地计算机。房间、历史和文档由你选用的 Linger 服务保存 |
| 高频处理日志、代码和草稿 | 在日常机器或闲置 GPU 电脑上运行模型 | 本地推理没有远程模型 API 的逐次费用或限流。机器仍有显存、耗电和吞吐成本 |
| 两台设备分工，或 Windows 不适合常驻大模型 | 在各自设备独立执行，或者从 Windows 提交给 Mac 上的 Agent | 可在 Windows 操作、复用 Mac 的工作区与本地模型，也可让 Windows 自己使用 NVIDIA 显卡 |
| 偶尔用 27B，而且还要剪辑、游戏或跑 ComfyUI | 保留模型文件，用时加载，用完卸载 | 避免专为偶发任务常驻占用 RAM 和显存 |
| 断网或网络不稳定 | 先完成必要下载，再用已下载模型处理本地文本 | 本地推理可以使用已有权重。网页搜索、云模型登录和远程连接仍各自需要网络 |

Linger 里的**账号**是登录身份，**服务**保存房间和会话，**计算机**提供执行环境，**Runtime**运行 Agent，**模型**负责推理。同一个邮箱也可能出现在两个独立 Quick Install 中。两端实际使用同一账号时，仍要分别核实服务地址、计算机状态和模型执行位置。云模型、联网工具与外部连接器有各自的数据流。 [数据存放位置](https://docs.heylinger.com/concepts/where-your-data-lives) · [数据和隐私](https://docs.heylinger.com/security/data-and-privacy)

## 选择部署方式

| 配置 | Linger 服务与记录 | Agent 和模型执行机 | 优点与使用场景 | 依赖与代价 |
| --- | --- | --- | --- | --- |
| [Mac 单独执行](docs/mac.md) | Mac 本机 | Mac，Metal | 设备少、维护简单。适合 Mac 日常文档、笔记、代码和个人知识库 | 占用 Mac 的统一内存，模型容量随当前可用内存变化 |
| [Windows 单独执行](docs/windows.md) | Windows 本机 | Windows，CUDA | 可使用独显与本地文件。轻任务可以明确选 4B，长文和较复杂任务按需启用 27B | 要管理 Windows 可用 RAM、显存、驱动和磁盘，两档入口各自核对所选模型 |
| [Windows 依赖 Mac 执行](docs/windows-via-mac.md) | Mac 上的 Linger 服务 | Mac，Metal。Windows 访问并提交任务 | Windows 可以复用 Mac 的 Agent、文件和模型，适合 Windows GPU 忙、文件在 Mac 或想维持同一个 Mac 工作区 | Mac 要在线，Windows 要能访问 Mac 服务。远程访问可能受休眠、网络和端口影响 |

两端可以登录同一账号。选择模式时以实际服务地址、Agent 指定的计算机、Runtime 和模型为准。案例里的 Windows 独立模式与访问 Mac 的模式分别保存聊天，切换入口不会合并两边的历史。

## 一条命令安装

从 GitHub 下载仓库 ZIP 并解压，或者克隆仓库，进入本指南的目录。选与你目标机器匹配的一行，在那台机器的终端运行。脚本从 Linger 官方 Release 下载固定版本并核对 SHA-256。先完成桌面安装，随后在应用里选择账号、计算机和模型。已有安装会跳过桌面安装。需自行完成系统安装提示与账号登录。

| 系统 | 命令 | 完整流程 |
| --- | --- | --- |
| Apple silicon Mac | `bash ./install-macos.sh` | [Mac 单独执行](docs/mac.md) |
| Windows 11 x64 | `.\install-windows.ps1` | [Windows 单独执行](docs/windows.md) |
| 在 Windows 使用 Mac | `.\open-windows-mac.ps1 -SshHost your-mac -MacWebPort 3000` | [已授权 SSH 环境的快捷入口，端口按实际填写](docs/windows-via-mac.md) |

仅盘点硬件用 Mac 的 `--check` 或 Windows 的 `-CheckOnly`。仅下载并校验桌面安装包用 `--download-only` 或 `-DownloadOnly`。安装常用 Agent CLI 的参数及登录方式见[智能体执行手册](AGENTS.md)。

## Mac 与 Windows 配置对比

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

## 本指南的验证记录

- **现场确认。** Windows 独立的 4B 完成了本机文件写入和读回。测试模型随后已卸载，权重仍在磁盘，未设置开机加载。日常 4B 与按需 27B 有各自入口，资源不足时保持当前目标，等待用户释放资源。原 Mac 入口继续保留，两模式聊天分别保存。
- **现场待补验。** 截图没有给出 Windows 独立 27B 的完整实测结果，也没有做 Mac 关机后的 Windows 独立复测。两项应分别记录为待验证。
- **公开脚本校验。** 两平台的官方桌面包已完整下载，实算 SHA-256 与同版清单一致。安装脚本做了语法检查和模拟资源预检。公开脚本的新机器安装、Runtime 登录和各模式推理以目标机验收为准。

## 许可

本指南原创建议和安装辅助脚本采用 [MIT](LICENSE)。安装时从上游取得的 Linger 程序、模型和 Agent CLI 使用各自的上游许可。 [Linger 许可](https://github.com/simplexai-labs/linger/blob/desktop-v0.1.6/LICENSE)
