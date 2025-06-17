#!/bin/bash
# FabricaGenerate 备份脚本

set -e

# 配置
BACKUP_DIR="/var/backups/fabricagenerate"
DATE=$(date +"%Y%m%d_%H%M%S")
RETENTION_DAYS=30

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

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

# 创建备份目录
create_backup_dir() {
    log_info "创建备份目录..."
    
    mkdir -p "$BACKUP_DIR/$DATE"
    
    log_success "备份目录已创建: $BACKUP_DIR/$DATE"
}

# 备份数据库
backup_database() {
    log_info "备份 PostgreSQL 数据库..."
    
    docker-compose exec -T postgres pg_dump -U fabrica_user fabrica_db > "$BACKUP_DIR/$DATE/database.sql"
    
    # 压缩数据库备份
    gzip "$BACKUP_DIR/$DATE/database.sql"
    
    log_success "数据库备份完成"
}

# 备份 Redis 数据
backup_redis() {
    log_info "备份 Redis 数据..."
    
    docker-compose exec -T redis redis-cli BGSAVE
    sleep 5
    docker cp $(docker-compose ps -q redis):/data/dump.rdb "$BACKUP_DIR/$DATE/redis.rdb"
    
    log_success "Redis 备份完成"
}

# 备份上传文件
backup_uploads() {
    log_info "备份上传文件..."
    
    if [ -d "./uploads" ]; then
        tar -czf "$BACKUP_DIR/$DATE/uploads.tar.gz" ./uploads
        log_success "上传文件备份完成"
    else
        log_warning "上传目录不存在，跳过文件备份"
    fi
}

# 备份配置文件
backup_configs() {
    log_info "备份配置文件..."
    
    tar -czf "$BACKUP_DIR/$DATE/configs.tar.gz" \
        .env.prod \
        docker-compose.prod.yml \
        nginx/ \
        monitoring/ \
        security/ \
        --exclude='*.log' \
        --exclude='*.tmp'
    
    log_success "配置文件备份完成"
}

# 清理旧备份
cleanup_old_backups() {
    log_info "清理 $RETENTION_DAYS 天前的备份..."
    
    find "$BACKUP_DIR" -type d -mtime +$RETENTION_DAYS -exec rm -rf {} + 2>/dev/null || true
    
    log_success "旧备份清理完成"
}

# 验证备份
validate_backup() {
    log_info "验证备份完整性..."
    
    local backup_path="$BACKUP_DIR/$DATE"
    
    # 检查文件是否存在
    if [ ! -f "$backup_path/database.sql.gz" ]; then
        log_error "数据库备份文件不存在"
        exit 1
    fi
    
    if [ ! -f "$backup_path/redis.rdb" ]; then
        log_error "Redis 备份文件不存在"
        exit 1
    fi
    
    if [ ! -f "$backup_path/configs.tar.gz" ]; then
        log_error "配置备份文件不存在"
        exit 1
    fi
    
    # 检查文件大小
    if [ ! -s "$backup_path/database.sql.gz" ]; then
        log_error "数据库备份文件为空"
        exit 1
    fi
    
    log_success "备份验证通过"
}

# 发送通知
send_notification() {
    log_info "发送备份通知..."
    
    local backup_size=$(du -sh "$BACKUP_DIR/$DATE" | cut -f1)
    local message="FabricaGenerate 备份完成\n日期: $DATE\n大小: $backup_size\n路径: $BACKUP_DIR/$DATE"
    
    # 这里可以集成邮件、Slack 或其他通知服务
    echo -e "$message"
    
    log_success "通知已发送"
}

# 主函数
main() {
    log_info "开始备份 FabricaGenerate..."
    
    create_backup_dir
    backup_database
    backup_redis
    backup_uploads
    backup_configs
    validate_backup
    cleanup_old_backups
    send_notification
    
    log_success "备份完成！"
}

# 执行主函数
main "$@"