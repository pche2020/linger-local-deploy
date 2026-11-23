# Linger 安装与验收执行手册

适用对象是能在目标设备运行命令的 Codex、Claude Code、Pi、Antigravity、Cursor、Copilot、WorkBuddy 等。可自动读项目说明的客户端以当前目录作为工作区。其他客户端把本文件交给智能体，并附上对应系统的完整流程。能照本手册实施部署，与 Linger 本身是否支持某客户端作为运行时，是两件事。

## 收到部署请求后直接执行

用户把仓库发来并明确要求安装时，从目标电脑上的只读检查开始。安装工作已在请求里明确授权时，常规检查、安装包校验和新装应用可以连续完成。复用已有应用、账号和 Runtime。部署方式或模型信息能从当前机器与请求中确定时，直接给出推荐方案。只有答案会改变执行设备、模型或权限范围时才向用户确认。

1. **确认执行环境。** 在有授权的目标主机上操作，记下客户端、服务、Agent 执行机和模型运行的设备。用户只发送链接时，自行克隆仓库或获取批准的文件。跨设备操作前说明要连接哪台机器和用途，等同意再连接。参考 [Mac 单独执行](docs/mac.md)、[Windows 单独执行](docs/windows.md) 或 [Windows 依赖 Mac](docs/windows-via-mac.md)。
2. **只读检查。** 运行对应的硬件检测。检查系统、CPU、GPU、内存、显存、磁盘、驱动以及 Linger 是否已装。比较实时可用空间和模型计划，记录计划选中的设备、模型量化与上下文。Windows 使用系统 RAM 和独立 VRAM 两项读数，Mac 使用统一内存。
3. **安装并打开。** 在目标机运行下面对应的安装命令。脚本继续应用的官方首装流程，已有应用复用原安装。已有配置若会在打开 Linger 时自动加载模型，先核对模型、可用资源和启动授权。只选本地模型时优先用 Linger 托管的 Pi。需要额外 CLI 时才使用下方 Runtime 安装参数。
4. **继续配置。** 有获准的桌面操作能力时，在 Linger 里继续已确认的配置。在需要权限、登录账号或系统首次运行确认时，让用户直接在系统或应用页面完成。只有终端权限时，把应用打开后说明当前必须点哪个按钮、要核对的模型和设备。用户完成该操作后，接手剩余检查和验收。
5. **锁定用户的模型选择。** 大型模型下载前合并确认一次模型、下载量、目标盘和预检资源。用户已明确确认同一计划时直接执行。若目标是 27B，遇到 4B 建议或资源不足时保留 27B，说明 RAM 或显存缺口，等用户释放资源后重测。Windows 日常 4B 与按需 27B 分开记录。
6. **验收并交付。** 在目标设备运行一次不含隐私的临时任务，核对执行机、Runtime、模型、结果和资源或日志。测试结束后，仅卸载本次测试启动且已经闲置的模型，确认文件仍在。交付时列出安装路径、模型路径、启动／停止方式和已验结果。未在实机执行的项目标为待验。

```bash
# Mac，在目标机器上执行
bash ./install-macos.sh --check
bash ./install-macos.sh --open
```

```powershell
# Windows，在目标机器的普通用户 PowerShell 执行
.\install-windows.ps1 -CheckOnly
.\install-windows.ps1 -AgentInstall
```

Windows 的 `-AgentInstall` 用于已获准的新装应用，会使用官方安装器的 `/S` 选项并打开应用。现有应用会复用，首次安装或启动遇到系统策略提示时，请用户在系统界面处理。仅在用户想看 Windows 安装器时使用不带 `-AgentInstall` 的命令。Mac 的 `--open` 在安装后打开 Linger。

从 Windows 使用 Mac 时，本地模型和 Agent 应落在 Mac。复用用户已同意的 Mac HTTPS 地址或 SSH 路径。只在已经有可信 SSH 主机别名且 Mac Linger 在回环地址监听 HTTP 的情况下使用下面的命令。把 `3000` 替换成实际端口。

```powershell
.\open-windows-mac.ps1 -SshHost your-mac -MacWebPort 3000
```

## 这些动作先让用户确认

- 连接另一台设备、授予桌面或文件权限、更改启动或网络设置。说明对象和影响。
- 下载大型模型、更换现有模型或升级／替换已有 Linger。说明模型标识、目标盘、大小和影响。
- 关闭有工作中的应用或模型、停止其他人的任务、删除数据、重启或关机。确认内容已保存并收到同意。
- 登录或填写凭据由用户在应用或系统界面操作。收到确认后接着执行剩余步骤。

## 安装 Linger 支持的 Runtime

| Runtime | 脚本参数 | 安装和登录要点 |
| --- | --- | --- |
| Pi | `pi` | 跑 Linger 内置本地模型时，优先用 Linger 配置的 Pi。额外安装独立 `pi` 适合单独调用。核对用途与实际模型来源。 [Pi 官方仓库](https://github.com/earendil-works/pi/tree/main/packages/coding-agent) |
| Codex | `codex` | 核对 `codex --version`，按需要由使用者运行 `codex login`。通过订阅使用时按远程模型的数据流处理。 [Codex CLI](https://learn.chatgpt.com/docs/codex/cli) |
| Claude Code | `claude` | 核对 `claude --version`，运行 `claude` 并按提示完成登录。npm 是官方安装选项之一。 [Claude Code 安装](https://code.claude.com/docs/en/setup) |
| Antigravity CLI | `antigravity` | 核对 `agy --version`，按官方教程完成 Google 登录或配置凭据。Linger `0.1.6` 发布说明列出支持，以本机能识别 `agy` 为准。 [Google CLI](https://antigravity.google/docs/cli/tutorial/) · [Linger 0.1.6](https://github.com/simplexai-labs/linger/releases/tag/desktop-v0.1.6) |

Mac 和 Windows 的脚本任选一个 Runtime 参数。已有可识别的 CLI 会保留。通过 npm 的选项需要已有兼容版本的 Node.js 和 npm，推荐当前 Node.js LTS。用户也可通过表中的上游文档直接安装。Antigravity 使用 Google 的操作系统安装器。外部 CLI 的安装、更新、授权和版本兼容按各上游负责。Linger 桌面包按本仓库固定格式核验 SHA-256。第三方 Runtime 支持与使用 Linger 原生本地模型的 Pi 模式应分开验证。

```bash
bash ./install-macos.sh --runtime codex
```

```powershell
.\install-windows.ps1 -Runtime codex
```

在目标机新开终端，若 `linger-computer` 在 PATH 中，先运行 `linger-computer runtime check`。`READY` 表示 Runtime 检查通过。需要测试账号模型时再用 `linger-computer runtime check codex --live`，这是一次实际模型调用。Linger 管理的本地模型验收仍按应用内设备与推理日志进行。Cursor、Copilot、WorkBuddy 等可以作为阅读本手册的执行助手，Linger 的原生 Runtime 以官方版本说明为准。 [官方 Runtime 检查](https://docs.heylinger.com/models/choose-a-runtime)

## 给其他 Agent 的启动词

> 请读取 `AGENTS.md`，在指定电脑上部署 Linger。先检查硬件，复用已有安装，再自动完成安装和验收。需要登录、额外权限、跨设备连接、下载大型模型或更改已有配置时请我确认。已选模型资源不足就报告差额。请告诉我启动、停止和模型存放位置。

## 交付记录

| 项目 | 要填的结果 |
| --- | --- |
| 目标模式与设备 | 界面设备、服务、实际 Agent 和推理宿主，以及 OS、CPU、RAM、GPU、VRAM、驱动和目标盘余量 |
| 安装 | 桌面和工具包版本、安装来源、SHA-256 结果 |
| 模型 | 模型来源、名称、量化、引擎、共享上下文、并发槽、权重路径 |
| 加载前 | RAM、VRAM 或统一内存读数，计划门槛、差额和处理结果 |
| 推理 | 测试时间、执行设备、Runtime、模型来源、回答与资源／日志证据 |
| 停止及重启 | 卸载状态、资源回收量、权重是否保留、开机及重开状态、启动入口 |
