#!/usr/bin/env bash
set -e

GREEN='\033[0;32m'; NC='\033[0m'
CONTAINER="stock-web"
IMAGES=("stock-web-snapshot:latest" "registry.cn-hangzhou.aliyuncs.com/hlong/stock-web-snapshot:v1.0.0")

echo -e "${GREEN}=== Stock Web 卸载 ===${NC}"

if ! command -v docker &> /dev/null; then
    echo "Docker 未安装，无需卸载"
    exit 0
fi

if docker ps -a --format '{{.Names}}' 2>/dev/null | grep -q "^${CONTAINER}$"; then
    echo "停止并删除容器 ${CONTAINER}..."
    docker stop $CONTAINER 2>/dev/null || true
    docker rm $CONTAINER 2>/dev/null || true
fi

for img in "${IMAGES[@]}"; do
    if docker images --format '{{.Repository}}:{{.Tag}}' 2>/dev/null | grep -q "^${img}$"; then
        echo "删除镜像 ${img}..."
        docker rmi "$img" 2>/dev/null || true
    fi
done

echo -e "${GREEN}=== 卸载完成 ===${NC}"
echo "如需重新部署: bash setup.sh"
