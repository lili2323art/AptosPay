#!/bin/bash

# AptoPay项目打包脚本
# 此脚本将创建一个可分发的项目压缩包

echo "🚀 开始打包AptoPay项目..."

# 设置变量
PROJECT_NAME="AptoPay"
DATE=$(date +"%Y%m%d_%H%M%S")
PACKAGE_NAME="${PROJECT_NAME}_${DATE}"
TEMP_DIR="/tmp/${PACKAGE_NAME}"
CURRENT_DIR=$(pwd)

# 创建临时目录
echo "📁 创建临时目录: ${TEMP_DIR}"
mkdir -p "${TEMP_DIR}"

# 复制项目文件，排除不必要的文件和目录
echo "📋 复制项目文件..."
rsync -av --progress \
  --exclude='node_modules' \
  --exclude='.git' \
  --exclude='.next' \
  --exclude='dist' \
  --exclude='build' \
  --exclude='.turbo' \
  --exclude='*.log' \
  --exclude='.DS_Store' \
  --exclude='coverage' \
  --exclude='.nyc_output' \
  --exclude='*.tgz' \
  --exclude='*.tar.gz' \
  --exclude='*.zip' \
  "${CURRENT_DIR}/" "${TEMP_DIR}/"

# 创建压缩包
echo "📦 创建压缩包..."
cd /tmp
tar -czf "${PACKAGE_NAME}.tar.gz" "${PACKAGE_NAME}"

# 移动压缩包到当前目录
mv "${PACKAGE_NAME}.tar.gz" "${CURRENT_DIR}/"

# 清理临时目录
echo "🧹 清理临时文件..."
rm -rf "${TEMP_DIR}"

# 显示结果
echo "✅ 打包完成！"
echo "📦 压缩包位置: ${CURRENT_DIR}/${PACKAGE_NAME}.tar.gz"
echo "📊 压缩包大小: $(du -h "${CURRENT_DIR}/${PACKAGE_NAME}.tar.gz" | cut -f1)"
echo ""
echo "🎯 接下来的步骤:"
echo "1. 将 ${PACKAGE_NAME}.tar.gz 发送给接收者"
echo "2. 接收者需要解压: tar -xzf ${PACKAGE_NAME}.tar.gz"
echo "3. 按照 DEPLOYMENT_GUIDE.md 中的说明运行项目"
echo ""
echo "💡 提示: 请确保接收者已安装 Node.js (v18+) 和 pnpm"