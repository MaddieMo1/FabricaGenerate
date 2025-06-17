#!/bin/bash
# FabricaGenerate 部署脚本

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 日志函数
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# 检查必要的工具
check_requirements() {
    log_info "检查部署要求..."
    
    command -v docker >/dev/null 2>&1 || { log_error "Docker 未安装"; exit 1; }
    command -v docker-compose >/dev/null 2>&1 || { log_error "Docker Compose 未安装"; exit 1; }
    command -v git >/dev/null 2>&1 || { log_error "Git 未安装"; exit 1; }
    
    log_success "所有要求已满足"
}

# 设置环境变量
setup_environment() {
    log_info "设置环境变量..."
    
    if [ ! -f ".env.prod" ]; then
        if [ -f ".env.prod.example" ]; then
            cp .env.prod.example .env.prod
            log_warning "已创建 .env.prod 文件，请编辑并填入实际值"
            exit 1
        else
            log_error ".env.prod.example 文件不存在"
            exit 1
        fi
    fi
    
    source .env.prod
    log_success "环境变量已加载"
}

# 构建镜像
build_images() {
    log_info "构建 Docker 镜像..."
    
    docker-compose -f docker-compose.prod.yml build --no-cache
    
    log_success "镜像构建完成"
}

# 运行数据库迁移
run_migrations() {
    log_info "运行数据库迁移..."
    
    docker-compose -f docker-compose.prod.yml run --rm backend npm run migrate
    
    log_success "数据库迁移完成"
}

# 启动服务
start_services() {
    log_info "启动服务..."
    
    docker-compose -f docker-compose.prod.yml up -d
    
    log_success "服务已启动"
}

# 健康检查
health_check() {
    log_info "执行健康检查..."
    
    # 等待服务启动
    sleep 30
    
    # 检查后端服务
    if curl -f http://localhost/api/health >/dev/null 2>&1; then
        log_success "后端服务健康"
    else
        log_error "后端服务不健康"
        exit 1
    fi
    
    # 检查前端服务
    if curl -f http://localhost/ >/dev/null 2>&1; then
        log_success "前端服务健康"
    else
        log_error "前端服务不健康"
        exit 1
    fi
}

# 清理旧资源
cleanup() {
    log_info "清理旧资源..."
    
    docker system prune -f
    docker volume prune -f
    
    log_success "清理完成"
}

# 主函数
main() {
    log_info "开始部署 FabricaGenerate..."
    
    check_requirements
    setup_environment
    build_images
    run_migrations
    start_services
    health_check
    cleanup
    
    log_success "部署完成！"
    log_info "应用已在 http://localhost 运行"
}

# 执行主函数
main "$@"