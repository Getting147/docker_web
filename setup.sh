#!/usr/bin/env bash
set -e

GREEN='\033[0;32m'; YELLOW='\033[1;33m'; RED='\033[0;31m'; NC='\033[0m'
IMAGE="registry.cn-hangzhou.aliyuncs.com/hlong/stock-web-snapshot:latest"
PORT=3002
CONTAINER="stock-web"

echo -e "${GREEN}=== Stock Web 一键部署 ===${NC}"

# 1. 检测 Docker
if ! command -v docker &> /dev/null; then
    echo -e "${YELLOW}[1/5] Docker 未安装，开始安装...${NC}"
    case "$(uname -s)" in
        MINGW*|MSYS*|CYGWIN*)
            if command -v winget &>/dev/null; then
                echo "用 winget 安装 Docker Desktop（需 UAC 授权）..."
                winget install -e --id Docker.DockerDesktop --accept-source-agreements
            elif command -v choco &>/dev/null; then
                choco install docker-desktop -y
            else
                echo -e "${RED}请先安装 winget（Win10 1809+）或 choco${NC}"
                echo "或手动下载: https://www.docker.com/products/docker-desktop/"
                exit 1
            fi
            ;;
        Darwin*)
            brew install --cask docker && open -a Docker
            ;;
        Linux*)
            curl -fsSL https://get.docker.com | sh
            sudo usermod -aG docker $USER
            ;;
    esac

    echo -e "${YELLOW}等待 Docker Desktop 启动（首次 1-3 分钟）...${NC}"
    for i in {1..60}; do
        if docker info &>/dev/null 2>&1; then
            break
        fi
        sleep 3
    done
fi
echo -e "${GREEN}[1/5] Docker 已就绪 ✓${NC}"

# 2. 拉镜像
echo -e "${YELLOW}[2/5] 拉取镜像（首次 1-3 分钟）...${NC}"
docker pull $IMAGE

# 3. 停旧容器
if docker ps -a --format '{{.Names}}' 2>/dev/null | grep -q "^${CONTAINER}$"; then
    echo -e "${YELLOW}[3/5] 停止旧容器...${NC}"
    docker stop $CONTAINER 2>/dev/null || true
    docker rm $CONTAINER 2>/dev/null || true
fi

# 4. 启动
echo -e "${YELLOW}[4/5] 启动服务...${NC}"
docker run -d --name $CONTAINER -p $PORT:$PORT --restart unless-stopped $IMAGE

# 5. 等就绪
echo -e "${YELLOW}[5/5] 等待服务就绪...${NC}"
READY=0
for i in {1..30}; do
    if curl -s -o /dev/null -m 2 http://localhost:$PORT/ 2>/dev/null; then
        READY=1
        break
    fi
    sleep 1
done

if [ $READY -eq 1 ]; then
    echo -e "${GREEN}=== 部署完成 ✓ ===${NC}"
    echo "访问: http://localhost:$PORT"
else
    echo -e "${YELLOW}服务可能还在启动，请稍后访问 http://localhost:$PORT${NC}"
    echo "查看日志: docker logs $CONTAINER"
fi
