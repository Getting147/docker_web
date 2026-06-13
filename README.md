# 鸿龙智算量化选股 · 策略回测平台（Docker 快照版）

[![License](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](LICENSE)
[![Docker Image](https://img.shields.io/badge/Docker-Aliyun_ACR-2496ED?logo=docker&logoColor=white)](https://cr.console.aliyun.com/repository/cn-hangzhou/hlong/stock-web-snapshot/details)

---

## 🚀 一键启动（推荐）

```bash
docker pull registry.cn-hangzhou.aliyuncs.com/hlong/stock-web-snapshot:v1.0.0

docker run -d --name stock-web --restart unless-stopped -p 3002:3002 \
  registry.cn-hangzhou.aliyuncs.com/hlong/stock-web-snapshot:v1.0.0
```

浏览器打开 → http://localhost:3002

零依赖，30 秒启动，不需要 Node.js、不需要数据库。

---

## 🛠 一条命令部署（自动装 Docker）

**没装 Docker 的用户**直接跑：

- macOS / Linux（Git Bash）：`curl -fsSL https://gitee.com/size-linw/docker_web/raw/master/setup.sh | bash`
- Windows PowerShell：`irm https://gitee.com/size-linw/docker_web/raw/master/setup.bat -OutFile setup.bat; .\setup.bat`

脚本会自动：检测平台 → 安装 Docker → 拉镜像 → 起容器 → 健康检查。

---

## 📖 文档

| 文档 | 说明 |
|------|------|
| **本 README** | 快速使用说明 |
| [DOCKER.md](https://gitee.com/size-linw/stock_web/blob/master/docker_web/DOCKER.md) | 完整部署文档（13 节，含架构、运维、卸载、FAQ） |
| [源代码](https://gitee.com/size-linw/stock_web/tree/master/docker_web) | Node.js 服务 + 前端静态页 + Dockerfile + Compose |

---

## 🧰 常用运维

```bash
# 查看容器状态
docker ps | grep stock-web

# 看日志
docker logs -f stock-web

# 停止
docker stop stock-web

# 重启
docker restart stock-web

# 卸载（停止+删容器+删镜像）
docker rm -f stock-web && docker rmi registry.cn-hangzhou.aliyuncs.com/hlong/stock-web-snapshot:v1.0.0
```

---

## 📦 镜像信息

| 项 | 值 |
|----|----|
| 镜像仓库 | `registry.cn-hangzhou.aliyuncs.com/hlong/stock-web-snapshot` |
| 当前版本 | `v1.0.0` |
| 基础镜像 | `node:20-alpine` |
| 监听端口 | `3002` |
| 体积 | 约 165 MB（包含 142MB 数据快照） |
| 运行时 | 镜像内已 bake 全量数据，无需外部数据库 |

镜像地址：[https://cr.console.aliyun.com/repository/cn-hangzhou/hlong/stock-web-snapshot/details](https://cr.console.aliyun.com/repository/cn-hangzhou/hlong/stock-web-snapshot/details)

---

## 🔄 数据更新 / 重新构建

本仓库**不发布构建产物**。如需更新数据或重新构建镜像：

1. 进入私有仓 `stock_web` 的 `docker_web/` 目录
2. 运行 `python dump_snapshot.py` 重新生成数据快照
3. `docker build -t registry.cn-hangzhou.aliyuncs.com/hlong/stock-web-snapshot:v1.x.x .`
4. `docker push registry.cn-hangzhou.aliyuncs.com/hlong/stock-web-snapshot:v1.x.x`

详细流程见 [DOCKER.md §7 数据更新与版本发布](https://gitee.com/size-linw/stock_web/blob/master/docker_web/DOCKER.md#7-数据更新与版本发布)。

---

## 📜 License

[Apache License 2.0](LICENSE)

---

## 💬 反馈

- 邮箱：h209119@sina.cn
- 微信：见 stock_web 私有仓 README

© 2026 Hlong Tech. All rights reserved.
