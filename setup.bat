@echo off
chcp 65001 >nul
setlocal

set IMAGE=registry.cn-hangzhou.aliyuncs.com/hlong/stock-web-snapshot:latest
set PORT=3002
set CONTAINER=stock-web
set MAX_WAIT=30

echo === Stock Web 一键部署 ===

REM ============================================================
REM 1. 检测 Docker；没有就自动装
REM ============================================================
where docker >nul 2>&1
if %errorlevel% neq 0 (
    echo [1/5] Docker 未安装，开始自动安装...

    REM 优先 winget（Win10 1809+ / Win11 自带）
    where winget >nul 2>&1
    if %errorlevel% equ 0 (
        echo 用 winget 安装 Docker Desktop（需 UAC 授权）...
        winget install -e --id Docker.DockerDesktop --accept-source-agreements
    ) else (
        REM 回退：choco
        where choco >nul 2>&1
        if %errorlevel% equ 0 (
            echo 用 choco 安装 Docker Desktop（需管理员权限）...
            choco install docker-desktop -y
        ) else (
            REM 都没有就走 Docker 官方一键脚本
            echo 未检测到 winget/choco，改用 Docker 官方安装脚本...
            powershell -NoProfile -ExecutionPolicy Bypass -Command "irm https://get.docker.com/win | iex"
        )
    )

    echo 等待 Docker Desktop 启动（首次 1-3 分钟）...
    set /a waited=0
    :wait_docker
    if %waited% geq 60 (
        echo Docker Desktop 启动超时，请检查后重试。
        pause
        exit /b 1
    )
    docker info >nul 2>&1
    if %errorlevel% equ 0 goto docker_ready
    timeout /t 3 /nobreak >nul
    set /a waited+=1
    goto wait_docker
    :docker_ready
)
echo [1/5] Docker 已就绪

REM ============================================================
REM 2. 拉镜像
REM ============================================================
echo [2/5] 拉取镜像（首次 1-3 分钟）...
docker pull %IMAGE%
if %errorlevel% neq 0 (
    echo 拉取失败！
    pause
    exit /b 1
)

REM ============================================================
REM 3. 停旧容器
REM ============================================================
docker ps -a --format "{{.Names}}" | findstr /B "%CONTAINER%" >nul 2>&1
if %errorlevel% equ 0 (
    echo [3/5] 停止旧容器...
    docker stop %CONTAINER% >nul 2>&1
    docker rm %CONTAINER% >nul 2>&1
)

REM ============================================================
REM 4. 启动
REM ============================================================
echo [4/5] 启动服务...
docker run -d --name %CONTAINER% -p %PORT%:%PORT% --restart unless-stopped %IMAGE%

REM ============================================================
REM 5. 健康检查（带次数上限，超时报错并提示查日志）
REM ============================================================
echo [5/5] 等待服务就绪（最多 %MAX_WAIT% 秒）...
set /a try=0
:wait_ready
if %try% geq %MAX_WAIT% (
    echo 服务启动超时，请稍后手动访问 http://localhost:%PORT% 或执行: docker logs %CONTAINER%
    pause
    exit /b 1
)
curl -s -o nul -m 2 http://localhost:%PORT%/ 2>nul
if %errorlevel% equ 0 goto ready
set /a try+=1
timeout /t 1 /nobreak >nul
goto wait_ready

:ready
echo === 部署完成 ===
echo 访问: http://localhost:%PORT%
pause