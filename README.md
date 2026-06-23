# 鸿龙智算量化选股 · 策略回测平台（Docker 快照版）

[![License](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](LICENSE)
[![Docker Image](https://img.shields.io/badge/Docker-Aliyun_ACR-2496ED?logo=docker&logoColor=white)](https://cr.console.aliyun.com/repository/cn-hangzhou/hlong/stock-web-snapshot/details)

> 一行命令，30 秒启动。零数据库依赖，零环境配置。

---

## 📋 环境要求

**Windows 版本要求：**
- ✅ Win10 **2020 年 5 月更新 及以上**（专业版 / 企业版 / 教育版 / 家庭版均可）
- ✅ Win11
- ❌ 不支持 Win7 / Win8 / Win10 2019 年 11 月 及更早版本

判断方法：设置 → 系统 → 关于 → **Windows 规格** → OS 版本

**macOS：** 需要 Homebrew（无则手动装 [Docker Desktop](https://www.docker.com/products/docker-desktop/)）
**Linux：** 主流发行版均可（需 `curl` + `sudo`）

---

## 👉 先选你的情况

| 你的情况 | 用这套方案 | 预计耗时 |
|---------|-----------|---------|
| ✅ 电脑已装 Docker | [方式 A：docker run](#方式-a已装-docker) | 30 秒 |
| ❌ 电脑没装 Docker | [方式 B：一键安装脚本](#方式-b未装-docker) | 3–5 分钟（含自动装 Docker） |

---

## 方式 A：已装 Docker

复制下面两行命令，粘贴到终端执行：

```bash
docker pull registry.cn-hangzhou.aliyuncs.com/hlong/stock-web-snapshot:latest

docker run -d --name stock-web --restart unless-stopped -p 3002:3002 \
  registry.cn-hangzhou.aliyuncs.com/hlong/stock-web-snapshot:latest
```

启动成功后，浏览器打开 → **http://localhost:3002**

**端口被占**？把 `-p 3002:3002` 改成 `-p 8888:3002`（容器内仍是 3002，宿主换成 8888）。

---

## 方式 B：未装 Docker

脚本会自动：检测平台 → 安装 Docker → 拉镜像 → 启动容器 → 健康检查。

**macOS / Linux（Git Bash）**：

```bash
curl -fsSL https://raw.githubusercontent.com/Getting147/docker_web/master/setup.sh | bash
```

**Windows PowerShell**（按 `Win + X` → 选 **PowerShell / 终端**，不要在 CMD 或 Git Bash 里跑）：

```powershell
curl -fsSL https://raw.githubusercontent.com/Getting147/docker_web/master/setup.bat -OutFile setup.bat
.\setup.bat
```

> 为什么用 `curl` 而不是 `irm`？`irm -OutFile` 默认以 UTF-8 + LF 写文件，会把 setup.bat 的 CRLF 换行符改成 LF，导致 cmd 解析失败。`curl` 保留原始字节，最稳。Win10 1803+ 自带 curl.exe，PowerShell 里是 `curl.exe`（不是 `Invoke-WebRequest` 的别名 `curl`，必要时显式 `curl.exe`）。

启动成功后，浏览器打开 → **http://localhost:3002**

---

## 🧰 常用命令

```bash
# 查看容器状态
docker ps | grep stock-web

# 看日志（实时）
docker logs -f stock-web

# 停止 / 重启
docker stop stock-web
docker restart stock-web

# 完全卸载（删容器 + 删镜像）
docker rm -f stock-web && docker rmi registry.cn-hangzhou.aliyuncs.com/hlong/stock-web-snapshot:latest
```

也可以用仓库自带的卸载脚本：

```bash
# macOS / Linux
curl -fsSL https://raw.githubusercontent.com/Getting147/docker_web/master/uninstall.sh | bash

# Windows
curl -fsSL https://raw.githubusercontent.com/Getting147/docker_web/master/uninstall.bat -OutFile uninstall.bat
.\uninstall.bat
```

### 方式 C：使用 Docker Compose

仓库根目录已提供 `docker-compose.yml`：

```bash
docker compose up -d     # 启动
docker compose down      # 停止
```

启动成功后浏览器访问 → **http://localhost:3002**

---

## 📦 镜像信息

| 项 | 值 |
|----|----|
| 镜像仓库 | `registry.cn-hangzhou.aliyuncs.com/hlong/stock-web-snapshot` |
| 当前版本 | 跟 `latest` tag 同步 |
| 基础镜像 | `node:20-alpine` |
| 监听端口 | `3002` |
| 体积 | 约 165 MB（已含全量数据快照） |
| 依赖 | 镜像内已 bake 全量数据，无需外部数据库 |

镜像地址：[https://cr.console.aliyun.com/repository/cn-hangzhou/hlong/stock-web-snapshot/details](https://cr.console.aliyun.com/repository/cn-hangzhou/hlong/stock-web-snapshot/details)

---

## ❓ 常见问题

**Q：访问 3002 端口没反应？**
A：等 10–30 秒，容器启动需要时间。可以 `docker logs stock-web` 看启动日志。

**Q：想换端口？**
A：参考「方式 A」末尾说明。

**Q：能更新数据吗？**
A：本镜像包含数据快照，如需更新版本请关注本仓 Releases。

---

## 📜 License

[Apache License 2.0](LICENSE)

---

## 💬 反馈

- 邮箱：h209119@sina.cn
