# Windows 依赖 Mac 执行任务

适合在 Windows 上操作 Linger，同时复用 Mac 上的房间、文件、Agent 和本地模型。Mac 提供 Linger 服务、本地 Runtime 和模型，Windows 负责访问界面并提交任务。Mac 进入睡眠、服务暂停或访问链路中断时，这个入口会受影响。希望两台机器各自可用时，另外保留 [Windows 独立模式](windows.md)。

## 1. 在 Mac 准备实际执行环境

1. 按 [Mac 独立流程](mac.md) 安装和启动 Linger，确认在 Mac 上至少完成一次本地运行。记录在 **Mac 自己的浏览器**中能用的准确服务地址、Mac 在 **Computers／计算机**里的名字、Runtime、模型和存放目录。用户自己在本地处理密码。
2. 先按 **Mac 的统一内存**选模型。16 GiB 通常从 4B 起步。24 GiB 机型可评估 `Qwen3.8-27B UD-IQ3_S` 和 64K 共享上下文，发布方模拟约需 21 GiB 可用。Windows 的显存和盘余量用于 Windows 本机任务，Mac 的计划以 Mac 的可用量为准。
3. 在 Mac 的 Linger 里为这一路径准备一个明确指向 Mac 的 Agent。检查它使用 Mac 的工作区、本地 Pi 和已加载的所选模型。做跨设备测试前准备一个空的临时测试目录。

## 2. 从 Windows 打开 Mac 上的 Linger

有正式可达的 HTTPS 服务地址时，直接在 Windows 浏览器打开该地址。需要 Windows 桌面入口时，在已有授权的场合选择 **Server address** 并使用该地址。对于需要长期供多设备直接访问的部署，参照官方 Docker Compose 和 HTTPS 网络配置。 [桌面安装](https://docs.heylinger.com/install/desktop-app) · [共享服务网络配置](https://docs.heylinger.com/admin/network)

Mac 的桌面安装若只监听回环地址，可以走已经配置好且获准使用的 SSH 通道。先在 Mac 打开本机 Linger，读取实际的 HTTP 端口，再在 Windows 的普通 PowerShell 执行。下面的 `your-mac` 是已配置的 SSH 独立主机别名，`3000` 只是示例。按实际端口替换两处。

```powershell
.\open-windows-mac.ps1 -SshHost your-mac -MacWebPort 3000
```

这条命令在当前窗口维持一个只绑定 Windows `127.0.0.1` 的 SSH 转发。命令连上后通常没有新输出。使用原有可信主机配置并核对 SSH 主机指纹。另开浏览器访问 `http://localhost:3000` 或 Mac 原本使用的回环主机名，继续用实际端口。若已有能正常运行的 SSH 窗口和 `Open-Linger` 快捷入口，直接复用该入口即可。 [Windows OpenSSH 客户端](https://learn.microsoft.com/windows-server/administration/openssh/openssh-overview)

1. Windows 页面能加载后，在页面登录 Mac 这条路径对应的 Linger 账号。可用原账号时复用。需要查看 Quick Install 生成的密码时，在对应服务的安装完成页 **Show**，由用户在登录页输入。
2. 在房间选择明确指向 Mac 的 Agent，发送前确认房间、计算机和模型。只用 Windows 浏览器访问时，Windows 可以只承担客户端角色。选择 Windows 独立入口时会使用 Windows 本机服务及其记录。
3. 两边显示同一邮箱或已登录时，分别核对当前 URL、Agent 指定的计算机和模型。案例里 Windows 独立模式和 Windows 访问 Mac 模式的聊天分别保存，切换入口不自动合并聊天。

## 3. 跨设备验收与停止

- 从 Windows 发一个短任务，请 Mac Agent 在刚准备的 Mac 临时目录写一行 `linger-mac-route-ok`，读回同一行。在 Mac 确认新测试文件及其内容，并核对模型状态、推理日志或资源变化。
- 如果用 SSH，页面登录和 HTTP 成功只验到访问链路。记录任务真正执行的计算机、Runtime、模型、输出及文件位置。
- 暂停使用时，先确认聊天任务结束、内容已保存。想回收内存就在 Mac 模型页 **Unload** 并核对磁盘文件仍在。使用 SSH 时用 `Ctrl+C` 收掉自己开的转发。只关闭 Windows 页面后，本次 Mac 推理进程可能仍在运行。
- 测试 Mac 关机或睡眠时 Windows 独立模式是否仍可用，等两端工作都已保存并获准后另做。案例截图明确记录该断开测试尚未执行。

## 4. 卡点与处理

| 现象 | 处理 |
| --- | --- |
| SSH 窗口连接后没有文字 | 本地转发正常可保持安静。另开 Windows 浏览器核对实际地址，并完成 Mac 执行验收 |
| `Address already in use` | 核实 Windows 已有的监听是否是正在使用的旧转发。正在用就复用。要替换时，在核实影响后由用户关闭自己创建的旧转发。检查实际端口和应用 origin，再重新连接 |
| 能开登录页但密码不通 | 确认页面对应的是哪个服务。独立安装可生成相同默认邮箱，各服务的密码分别生成 |
| 报网络错误、一直离线或 WebSocket 断开 | 检查 Mac 是否在线、Linger 服务是否启动、Windows 端口与 Mac 实际端口是否对应。正式共享部署同时核对 HTTPS 地址、WebSocket 公共地址和反向代理 |
| 任务跑到 Windows 路径或选到了 4B | 在同一房间确认选中的 Agent、Computer、Runtime 和模型。想跑 Mac 27B 时重新在 Mac 检查可用统一内存，资源不足先停 |
| 切换入口后看不到刚才的聊天 | 回到创建该聊天的服务和入口。确有迁移需要时，先保存必要内容，再决定迁移哪些数据 |
