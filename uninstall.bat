@echo off
chcp 65001 >nul
setlocal

set CONTAINER=stock-web
set IMAGES=registry.cn-hangzhou.aliyuncs.com/hlong/stock-web-snapshot:latest

echo === Stock Web 卸载 ===

where docker >nul 2>&1
if errorlevel 1 (
    echo Docker 未安装，无需卸载
    pause
    exit /b 0
)

docker ps -a --format "{{.Names}}" | findstr /B "%CONTAINER%" >nul 2>&1
if not errorlevel 1 (
    echo 停止并删除容器 %CONTAINER%...
    docker stop %CONTAINER% >nul 2>&1
    docker rm %CONTAINER% >nul 2>&1
)

for %%i in (%IMAGES%) do (
    docker images --format "{{.Repository}}:{{.Tag}}" | findstr "%%i" >nul 2>&1
    if not errorlevel 1 (
        echo 删除镜像 %%i...
        docker rmi %%i >nul 2>&1
    )
)

echo === 卸载完成 ===
echo 如需重新部署: 双击 setup.bat
pause
