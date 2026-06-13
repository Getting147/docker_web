@echo off
chcp 65001 >nul
setlocal

set IMAGE=registry.cn-hangzhou.aliyuncs.com/hlong/stock-web-snapshot:v1.0.0
set PORT=3002
set CONTAINER=stock-web

echo === Stock Web 一键部署 ===

REM 1. 检测 Docker
where docker >nul 2>&1
if errorlevel 1 (
    echo [1/5] Docker 未安装，请先安装 Docker Desktop
    echo 下载地址: https://www.docker.com/products/docker-desktop/
    echo 安装后重新运行本脚本
    pause
    exit /b 1
)
echo [1/5] Docker 已就绪

REM 2. 拉镜像
echo [2/5] 拉取镜像（首次 1-3 分钟）...
docker pull %IMAGE%
if errorlevel 1 (
    echo 拉取失败！
    pause
    exit /b 1
)

REM 3. 停旧容器
docker ps -a --format "{{.Names}}" | findstr /B "%CONTAINER%" >nul 2>&1
if not errorlevel 1 (
    echo [3/5] 停止旧容器...
    docker stop %CONTAINER% >nul 2>&1
    docker rm %CONTAINER% >nul 2>&1
)

REM 4. 启动
echo [4/5] 启动服务...
docker run -d --name %CONTAINER% -p %PORT%:%PORT% --restart unless-stopped %IMAGE%

REM 5. 等就绪
echo [5/5] 等待服务就绪...
:wait
timeout /t 2 /nobreak >nul
curl -s -o nul -m 2 http://localhost:%PORT%/ 2>nul
if errorlevel 1 goto wait

echo === 部署完成 ===
echo 访问: http://localhost:%PORT%
pause
