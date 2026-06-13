# 鸿龙智算量化选股 · 策略回测平台（Docker 快照版）

[![License](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](LICENSE)
[![Docker Image](https://img.shields.io/badge/Docker-Aliyun_ACR-2496ED?logo=docker&logoColor=white)](https://cr.console.aliyun.com/repository/cn-hangzhou/hlong/stock-web-snapshot/details)

---

## 🚀 一键启动

```bash
docker pull registry.cn-hangzhou.aliyuncs.com/hlong/stock-web-snapshot:v1.0.0

docker run -d --name stock-web --restart unless-stopped -p 3002:3002 \
  registry.cn-hangzhou.aliyuncs.com/hlong/stock-web-snapshot:v1.0.0
```

浏览器打开 → http://localhost:3002

零依赖，30 秒启动。

---

## 🛠 一条命令部署（自动装 Docker）

**没装 Docker 的用户**直接跑：

- macOS / Linux（Git Bash）：`curl -fsSL https://gitee.com/size-linw/docker_web/raw/master/setup.sh | bash`
- Windows PowerShell：`irm https://gitee.com/size-linw/docker_web/raw/master/setup.bat -OutFile setup.bat; .\setup.bat`

脚本会自动：检测平台 → 安装 Docker → 拉镜像 → 起容器 → 健康检查。

---

## 🧰 常用运维

```bash
# 查看容器状态
docker ps | grep stock-web

# 看日志
docker logs -f stock-web

# 停止 / 重启
docker stop stock-web
docker restart stock-web

# 卸载
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
| 体积 | 约 165 MB（已含全量数据快照） |
| 依赖 | 镜像内已 bake 全量数据，无需外部数据库 |

镜像地址：[https://cr.console.aliyun.com/repository/cn-hangzhou/hlong/stock-web-snapshot/details](https://cr.console.aliyun.com/repository/cn-hangzhou/hlong/stock-web-snapshot/details)

---

## 📜 License

[Apache License 2.0](LICENSE)

---

## 💬 反馈

- 邮箱：h209119@sina.cn
