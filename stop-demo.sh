#!/bin/bash

# AptoPay 钱包定制 Demo 停止脚本
# 使用方法: ./stop-demo.sh

echo "🛑 停止 AptoPay 钱包定制 Demo..."
echo "======================================"

# 停止通过 PID 文件记录的进程
if [ -f ".backend.pid" ]; then
    BACKEND_PID=$(cat .backend.pid)
    if kill -0 $BACKEND_PID 2>/dev/null; then
        echo "🔧 停止后端服务 (PID: $BACKEND_PID)..."
        kill $BACKEND_PID
        echo "✅ 后端服务已停止"
    else
        echo "ℹ️  后端服务已经停止"
    fi
    rm -f .backend.pid
fi

if [ -f ".frontend.pid" ]; then
    FRONTEND_PID=$(cat .frontend.pid)
    if kill -0 $FRONTEND_PID 2>/dev/null; then
        echo "🎨 停止前端服务 (PID: $FRONTEND_PID)..."
        kill $FRONTEND_PID
        echo "✅ 前端服务已停止"
    else
        echo "ℹ️  前端服务已经停止"
    fi
    rm -f .frontend.pid
fi

# 查找并停止可能的残留进程
echo "🔍 检查残留进程..."

# 停止可能在端口 3001 运行的进程
BACKEND_PIDS=$(lsof -ti:3001 2>/dev/null)
if [ ! -z "$BACKEND_PIDS" ]; then
    echo "🔧 发现端口 3001 上的进程，正在停止..."
    echo $BACKEND_PIDS | xargs kill -9 2>/dev/null
    echo "✅ 端口 3001 进程已清理"
fi

# 停止可能在端口 3002 运行的进程
FRONTEND_PIDS=$(lsof -ti:3002 2>/dev/null)
if [ ! -z "$FRONTEND_PIDS" ]; then
    echo "🎨 发现端口 3002 上的进程，正在停止..."
    echo $FRONTEND_PIDS | xargs kill -9 2>/dev/null
    echo "✅ 端口 3002 进程已清理"
fi

# 停止可能的 bun 和 pnpm 进程
echo "🧹 清理相关进程..."
pkill -f "bun run dev" 2>/dev/null && echo "✅ bun 进程已清理"
pkill -f "pnpm dev" 2>/dev/null && echo "✅ pnpm 进程已清理"

echo ""
echo "🎉 Demo 已完全停止！"
echo "======================================"
echo "💡 提示:"
echo "   - 所有相关进程已停止"
echo "   - 端口 3001 和 3002 已释放"
echo "   - 可以重新运行 ./start-demo.sh 启动"
echo ""
echo "👋 感谢使用 AptoPay Demo！"