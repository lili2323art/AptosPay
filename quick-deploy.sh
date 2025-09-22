#!/bin/bash

# AptoPay 快速部署脚本
# 此脚本将自动完成项目的安装、构建和启动过程

set -e  # 遇到错误时退出

echo "🚀 AptoPay 快速部署脚本"
echo "================================"
echo ""

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 打印带颜色的消息
print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

# 检查命令是否存在
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# 检查 Node.js 版本
check_node_version() {
    if command_exists node; then
        NODE_VERSION=$(node --version | cut -d'v' -f2)
        MAJOR_VERSION=$(echo $NODE_VERSION | cut -d'.' -f1)
        if [ "$MAJOR_VERSION" -ge 20 ]; then
            print_success "Node.js 版本: v$NODE_VERSION (满足要求 >= 20.0.0)"
            return 0
        else
            print_error "Node.js 版本过低: v$NODE_VERSION (需要 >= 20.0.0)"
            return 1
        fi
    else
        print_error "未找到 Node.js，请先安装 Node.js >= 20.0.0"
        return 1
    fi
}

# 安装 pnpm
install_pnpm() {
    if ! command_exists pnpm; then
        print_info "正在安装 pnpm..."
        npm install -g pnpm@9.15.5
        print_success "pnpm 安装完成"
    else
        PNPM_VERSION=$(pnpm --version)
        print_success "pnpm 版本: $PNPM_VERSION"
    fi
}

# 安装 Bun (可选)
install_bun() {
    if ! command_exists bun; then
        print_warning "未找到 Bun，正在尝试安装..."
        if command_exists curl; then
            curl -fsSL https://bun.sh/install | bash
            export PATH="$HOME/.bun/bin:$PATH"
            if command_exists bun; then
                print_success "Bun 安装完成"
            else
                print_warning "Bun 安装失败，将使用 npm 运行后端服务"
            fi
        else
            print_warning "未找到 curl，跳过 Bun 安装，将使用 npm 运行后端服务"
        fi
    else
        BUN_VERSION=$(bun --version)
        print_success "Bun 版本: $BUN_VERSION"
    fi
}

# 主要部署流程
main() {
    print_info "开始 AptoPay 项目快速部署..."
    echo ""
    
    # 1. 检查系统要求
    print_info "步骤 1/6: 检查系统要求"
    if ! check_node_version; then
        print_error "系统要求检查失败，请安装 Node.js >= 20.0.0"
        echo "下载地址: https://nodejs.org/"
        exit 1
    fi
    echo ""
    
    # 2. 安装包管理器
    print_info "步骤 2/6: 安装包管理器"
    install_pnpm
    install_bun
    echo ""
    
    # 3. 安装依赖
    print_info "步骤 3/6: 安装项目依赖"
    print_info "这可能需要几分钟时间，请耐心等待..."
    if pnpm install; then
        print_success "依赖安装完成"
    else
        print_error "依赖安装失败"
        exit 1
    fi
    echo ""
    
    # 4. 构建项目
    print_info "步骤 4/6: 构建项目"
    if pnpm build; then
        print_success "项目构建完成"
    else
        print_error "项目构建失败"
        exit 1
    fi
    echo ""
    
    # 5. 检查端口占用
    print_info "步骤 5/6: 检查端口占用"
    PORTS=(3001 3002 3000)
    for port in "${PORTS[@]}"; do
        if lsof -i :$port >/dev/null 2>&1; then
            print_warning "端口 $port 已被占用，请手动停止相关进程或稍后手动启动服务"
        else
            print_success "端口 $port 可用"
        fi
    done
    echo ""
    
    # 6. 启动服务
    print_info "步骤 6/6: 启动服务"
    print_info "正在启动 AptoPay 服务..."
    
    # 检查是否存在启动脚本
    if [ -f "start-demo.sh" ]; then
        chmod +x start-demo.sh
        print_success "使用 start-demo.sh 启动服务"
        ./start-demo.sh
    else
        print_warning "未找到 start-demo.sh，手动启动服务"
        
        # 启动后端服务
        print_info "启动后端服务..."
        cd apps/backend
        if command_exists bun; then
            bun run dev &
        else
            npm run dev &
        fi
        BACKEND_PID=$!
        cd ../..
        
        # 等待后端启动
        sleep 3
        
        # 启动前端服务
        print_info "启动支付应用..."
        cd apps/payment
        pnpm dev --port 3002 &
        FRONTEND_PID=$!
        cd ../..
        
        # 保存进程ID
        echo $BACKEND_PID > .backend.pid
        echo $FRONTEND_PID > .frontend.pid
    fi
    
    echo ""
    print_success "🎉 AptoPay 部署完成！"
    echo ""
    echo "📱 访问地址:"
    echo "   • 支付应用: https://localhost:3002"
    echo "   • 钱包定制 Demo: https://localhost:3002/customize"
    echo "   • 后端 API: http://localhost:3001"
    echo "   • API 健康检查: http://localhost:3001/api/v1/health"
    echo ""
    echo "🛑 停止服务:"
    echo "   • 运行: ./stop-demo.sh"
    echo "   • 或按 Ctrl+C 停止当前进程"
    echo ""
    echo "📚 更多信息:"
    echo "   • 部署指南: DEPLOYMENT_GUIDE.md"
    echo "   • 演示指南: DEMO_GUIDE.md"
    echo "   • 项目说明: README.md"
    echo ""
    print_info "请等待服务完全启动 (约 30-60 秒)，然后访问上述地址"
}

# 错误处理
trap 'print_error "部署过程中发生错误，请检查上述输出信息"' ERR

# 运行主函数
main "$@"