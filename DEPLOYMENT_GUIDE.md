# AptoPay 项目部署指南

本文档将指导您如何在新环境中部署和运行 AptoPay 项目。

## 📋 系统要求

### 必需软件
- **Node.js**: >= 20.0.0 (推荐使用 LTS 版本)
- **pnpm**: 9.15.5 或更高版本
- **Git**: 用于版本控制
- **操作系统**: macOS, Linux, 或 Windows (推荐 macOS/Linux)

### 可选软件
- **Bun**: >= 1.0.0 (用于后端服务，可选)
- **VS Code**: 推荐的开发环境

## 🚀 快速部署步骤

### 1. 解压项目文件

```bash
# 解压收到的项目压缩包
tar -xzf AptoPay_*.tar.gz
cd AptoPay_*
```

### 2. 安装 Node.js 和 pnpm

#### 安装 Node.js
```bash
# 使用 nvm (推荐)
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
source ~/.bashrc
nvm install 20
nvm use 20

# 或者直接从官网下载: https://nodejs.org/
```

#### 安装 pnpm
```bash
# 使用 npm 安装 pnpm
npm install -g pnpm@9.15.5

# 验证安装
pnpm --version
```

### 3. 安装项目依赖

```bash
# 在项目根目录执行
pnpm install
```

### 4. 构建项目

```bash
# 构建所有包和应用
pnpm build
```

### 5. 启动服务

#### 方法一：使用快速启动脚本
```bash
# 一键启动所有服务
./start-demo.sh
```

#### 方法二：手动启动各个服务
```bash
# 启动后端服务 (终端1)
cd apps/backend
bun run dev
# 或者使用 npm: npm run dev

# 启动支付应用 (终端2)
cd apps/payment
pnpm dev --port 3002

# 启动其他应用 (可选)
cd apps/nextjs-example
pnpm dev --port 3000
```

## 🌐 访问应用

部署成功后，您可以通过以下地址访问各个应用：

- **支付应用**: https://localhost:3002
- **钱包定制 Demo**: https://localhost:3002/customize
- **Next.js 示例**: http://localhost:3000
- **后端 API**: http://localhost:3001
- **API 健康检查**: http://localhost:3001/api/v1/health

## 🔧 配置说明

### 环境变量配置

1. 复制环境变量模板：
```bash
# 后端配置
cp apps/backend/.env.example apps/backend/.env

# 跨链应用配置
cp apps/nextjs-x-chain/.env.example apps/nextjs-x-chain/.env
```

2. 根据需要修改环境变量：
```bash
# 编辑后端环境变量
vim apps/backend/.env
```

### 端口配置

默认端口分配：
- 后端服务: 3001
- 支付应用: 3002
- Next.js 示例: 3000
- UIUX 应用: 3003

如需修改端口，请编辑对应的启动脚本或 package.json 文件。

## 🛠️ 开发模式

### 启动开发环境
```bash
# 启动所有开发服务器
pnpm dev

# 或启动特定应用
pnpm payment              # 支付应用
pnpm payment-c            # 清理并启动支付应用
pnpm example              # Next.js 示例
pnpm uiux                 # UI/UX 应用
```

### 代码格式化和检查
```bash
# 格式化代码
pnpm format

# 运行 linting
pnpm lint

# 运行测试
pnpm test
```

## 📦 生产部署

### 构建生产版本
```bash
# 构建所有应用
pnpm build

# 构建特定应用
pnpm build:payment
pnpm build:example
```

### 启动生产服务
```bash
# 启动生产版本
pnpm start

# 或使用 PM2 进程管理器
npm install -g pm2
pm2 start ecosystem.config.js
```

## 🐛 故障排除

### 常见问题

#### 1. 依赖安装失败
```bash
# 清理缓存并重新安装
pnpm store prune
rm -rf node_modules
rm pnpm-lock.yaml
pnpm install
```

#### 2. 端口被占用
```bash
# 查找占用端口的进程
lsof -i :3001
lsof -i :3002

# 杀死进程
kill -9 <PID>
```

#### 3. 构建失败
```bash
# 清理构建缓存
pnpm clean
pnpm build
```

#### 4. Bun 相关问题
```bash
# 安装 Bun (如果需要)
curl -fsSL https://bun.sh/install | bash

# 或使用 npm 替代 bun
cd apps/backend
npm run dev
```

### 日志查看
```bash
# 查看应用日志
pnpm logs

# 查看特定服务日志
cd apps/backend && bun run dev
cd apps/payment && pnpm dev --port 3002
```

## 🔒 安全注意事项

1. **环境变量**: 确保不要将敏感信息提交到版本控制
2. **HTTPS**: 生产环境建议使用 HTTPS
3. **防火墙**: 配置适当的防火墙规则
4. **更新**: 定期更新依赖包以修复安全漏洞

## 📞 技术支持

如果在部署过程中遇到问题，请：

1. 检查本文档的故障排除部分
2. 查看项目的 README.md 文件
3. 检查 GitHub Issues
4. 联系项目维护者

## 📚 相关文档

- [README.md](./README.md) - 项目概述和基本使用
- [DEMO_GUIDE.md](./DEMO_GUIDE.md) - 演示指南
- [CONTRIBUTING.md](./CONTRIBUTING.md) - 贡献指南
- [DEMO_CHECKLIST.md](./DEMO_CHECKLIST.md) - 演示检查清单

---

🎉 **恭喜！** 您已成功部署 AptoPay 项目。现在可以开始探索这个强大的 Aptos 钱包适配器平台了！