# AptoPay 项目打包检查清单

本文档列出了项目打包时需要包含的所有必要文件和目录。

## ✅ 必需文件和目录

### 📁 根目录文件
- [ ] `package.json` - 项目依赖和脚本配置
- [ ] `pnpm-lock.yaml` - 锁定依赖版本
- [ ] `pnpm-workspace.yaml` - Monorepo 工作区配置
- [ ] `turbo.json` - Turbo 构建配置
- [ ] `README.md` - 项目说明文档
- [ ] `DEPLOYMENT_GUIDE.md` - 部署指南
- [ ] `LICENSE` - 开源许可证
- [ ] `CONTRIBUTING.md` - 贡献指南
- [ ] `DEMO_GUIDE.md` - 演示指南
- [ ] `DEMO_CHECKLIST.md` - 演示检查清单
- [ ] `.gitignore` - Git 忽略文件配置

### 📁 应用程序目录 (apps/)
- [ ] `apps/backend/` - 后端服务
  - [ ] `package.json`
  - [ ] `src/` - 源代码
  - [ ] `tsconfig.json`
  - [ ] `.env.example` - 环境变量模板
- [ ] `apps/payment/` - 支付应用
  - [ ] `package.json`
  - [ ] `src/` - 源代码
  - [ ] `public/` - 静态资源
  - [ ] `next.config.mjs`
  - [ ] `tailwind.config.ts`
  - [ ] `components.json`
- [ ] `apps/nextjs-example/` - Next.js 示例
- [ ] `apps/nextjs-x-chain/` - 跨链应用
- [ ] `apps/UIUX/` - UI/UX 应用

### 📁 核心包目录 (packages/)
- [ ] `packages/wallet-adapter-core/` - 核心适配器
- [ ] `packages/wallet-adapter-react/` - React 适配器
- [ ] `packages/wallet-adapter-vue/` - Vue 适配器
- [ ] `packages/cross-chain-core/` - 跨链核心
- [ ] `packages/derived-wallet-base/` - 派生钱包基础
- [ ] `packages/derived-wallet-ethereum/` - 以太坊派生钱包
- [ ] `packages/derived-wallet-solana/` - Solana 派生钱包
- [ ] `packages/wallet-adapter-ant-design/` - Ant Design 组件
- [ ] `packages/wallet-adapter-mui-design/` - Material-UI 组件
- [ ] `packages/tsconfig/` - TypeScript 配置
- [ ] `packages/eslint-config-adapter/` - ESLint 配置
- [ ] `packages/open-pro-next/` - 开源专业版

### 📁 脚本和工具
- [ ] `start-demo.sh` - 启动演示脚本
- [ ] `stop-demo.sh` - 停止演示脚本
- [ ] `package-project.sh` - 项目打包脚本

### 📁 文档和资源
- [ ] `md/` - 技术文档目录
  - [ ] `业务分析报告.md`
  - [ ] `技术架构分析报告.md`
  - [ ] `数据流程报告.md`
  - [ ] `服务时序报告.md`
- [ ] `image/` - 图片资源
- [ ] `walletselector.png` - 钱包选择器截图

## ❌ 排除的文件和目录

### 🚫 构建产物
- `node_modules/` - 依赖包 (通过 pnpm install 重新安装)
- `.next/` - Next.js 构建缓存
- `dist/` - 构建输出
- `build/` - 构建输出
- `.turbo/` - Turbo 缓存

### 🚫 开发文件
- `.git/` - Git 版本控制信息
- `*.log` - 日志文件
- `.DS_Store` - macOS 系统文件
- `coverage/` - 测试覆盖率报告
- `.nyc_output/` - 测试工具输出

### 🚫 临时文件
- `*.tmp`
- `*.temp`
- `*.swp`
- `*.swo`

### 🚫 压缩包
- `*.tgz`
- `*.tar.gz`
- `*.zip`

## 🔍 打包前检查步骤

### 1. 文件完整性检查
```bash
# 检查关键文件是否存在
ls -la package.json pnpm-lock.yaml README.md
ls -la apps/backend/package.json
ls -la apps/payment/package.json
ls -la packages/wallet-adapter-core/package.json
```

### 2. 依赖检查
```bash
# 确保依赖可以正常安装
pnpm install --frozen-lockfile
```

### 3. 构建检查
```bash
# 确保项目可以正常构建
pnpm build
```

### 4. 脚本权限检查
```bash
# 确保脚本有执行权限
ls -la *.sh
chmod +x start-demo.sh stop-demo.sh package-project.sh
```

## 📦 打包命令

```bash
# 执行打包脚本
./package-project.sh
```

## ✅ 打包后验证

### 1. 压缩包检查
```bash
# 检查压缩包大小和内容
ls -lh AptoPay_*.tar.gz
tar -tzf AptoPay_*.tar.gz | head -20
```

### 2. 解压测试
```bash
# 在临时目录测试解压
mkdir /tmp/test-extract
cd /tmp/test-extract
tar -xzf /path/to/AptoPay_*.tar.gz
cd AptoPay_*
ls -la
```

### 3. 快速部署测试
```bash
# 测试基本安装流程
pnpm install
pnpm build
```

## 📋 发送前最终检查

- [ ] 压缩包大小合理 (通常 < 50MB)
- [ ] 包含所有必需文件
- [ ] 排除了不必要的文件
- [ ] 脚本有执行权限
- [ ] 文档完整且最新
- [ ] 可以成功解压和安装

## 📞 接收者指南

将以下信息一同发送给接收者：

1. **解压命令**: `tar -xzf AptoPay_*.tar.gz`
2. **部署文档**: 参考 `DEPLOYMENT_GUIDE.md`
3. **快速启动**: 运行 `./start-demo.sh`
4. **系统要求**: Node.js >= 20.0.0, pnpm >= 9.15.5

---

✨ **提示**: 建议在不同环境中测试打包和部署流程，确保兼容性。