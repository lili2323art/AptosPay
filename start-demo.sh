#!/bin/bash

# AptoPay 钱包定制 Demo 启动脚本
# 使用方法: ./start-demo.sh

echo "🚀 启动 AptoPay 钱包定制 Demo..."
echo "======================================"

# 检查 Node.js 版本
if ! command -v node &> /dev/null; then
    echo "❌ 错误: 未找到 Node.js，请先安装 Node.js >= 20.0.0"
    exit 1
fi

NODE_VERSION=$(node -v | cut -d'v' -f2 | cut -d'.' -f1)
if [ "$NODE_VERSION" -lt 20 ]; then
    echo "❌ 错误: Node.js 版本过低，需要 >= 20.0.0，当前版本: $(node -v)"
    exit 1
fi

# 检查 pnpm
if ! command -v pnpm &> /dev/null; then
    echo "❌ 错误: 未找到 pnpm，请先安装 pnpm"
    echo "安装命令: npm install -g pnpm"
    exit 1
fi

# 检查 bun
if ! command -v bun &> /dev/null; then
    echo "❌ 错误: 未找到 bun，请先安装 bun"
    echo "安装命令: curl -fsSL https://bun.sh/install | bash"
    exit 1
fi

echo "✅ 环境检查通过"
echo ""

# 安装依赖（如果需要）
if [ ! -d "node_modules" ]; then
    echo "📦 安装项目依赖..."
    pnpm install
    echo "✅ 依赖安装完成"
    echo ""
fi

# 启动后端服务
echo "🔧 启动后端服务..."
cd apps/backend
bun run dev &
BACKEND_PID=$!
echo "✅ 后端服务已启动 (PID: $BACKEND_PID)"
echo "📍 后端地址: http://localhost:3001"
echo ""

# 等待后端启动
echo "⏳ 等待后端服务启动..."
sleep 3

# 检查后端是否启动成功
if curl -s http://localhost:3001/api/v1/health > /dev/null 2>&1; then
    echo "✅ 后端服务启动成功"
else
    echo "⚠️  后端服务可能还在启动中，请稍后检查"
fi
echo ""

# 启动前端服务
echo "🎨 启动前端服务..."
cd ../payment
pnpm dev --port 3002 &
FRONTEND_PID=$!
echo "✅ 前端服务已启动 (PID: $FRONTEND_PID)"
echo "📍 前端地址: https://localhost:3002"
echo "🎯 Demo 地址: https://localhost:3002/customize"
echo ""

# 等待前端启动
echo "⏳ 等待前端服务启动..."
sleep 5

echo "🎉 Demo 启动完成！"
echo "======================================"
echo "📖 演示指南: 请查看项目根目录的 DEMO_GUIDE.md"
echo "🌐 访问地址: https://localhost:3002/customize"
echo "🔧 后端 API: http://localhost:3001"
echo ""
echo "💡 提示:"
echo "   - 使用 Ctrl+C 停止服务"
echo "   - 如遇问题，请检查端口 3001 和 3002 是否被占用"
echo "   - 详细使用说明请参考 DEMO_GUIDE.md"
echo ""
echo "🚀 开始您的演示吧！"

# 保存 PID 以便后续清理
echo $BACKEND_PID > .backend.pid
echo $FRONTEND_PID > .frontend.pid

# 等待用户中断
wait

# 清理进程
echo "🧹 清理进程..."
kill $BACKEND_PID 2>/dev/null
kill $FRONTEND_PID 2>/dev/null
rm -f .backend.pid .frontend.pid
echo "✅ 清理完成"