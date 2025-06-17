# FabricaGenerate

一个基于AI的3D模型生成和管理平台，集成了多种AI服务和现代化的部署架构。

## 🌟 核心功能

### 3D模型生成
- **AI驱动的3D模型生成**：集成多种AI模型生成服务
- **实时3D预览**：基于Three.js的交互式3D模型查看器
- **多格式支持**：支持GLB、OBJ、FBX等主流3D格式
- **批量处理**：支持批量生成和处理3D模型

### 用户管理
- **用户认证系统**：JWT令牌认证，支持多种登录方式
- **权限管理**：基于角色的访问控制(RBAC)
- **用户作品管理**：个人作品库和分享功能
- **API使用统计**：详细的API调用记录和统计

### 文件管理
- **云存储集成**：支持多种云存储服务
- **文件版本控制**：自动版本管理和回滚
- **安全上传**：文件类型验证和安全扫描
- **CDN加速**：全球内容分发网络支持

## 🏗️ 技术架构

### 前端技术栈
- **Three.js** - 3D图形渲染和交互
- **Webpack** - 模块打包和构建
- **Babel** - JavaScript转译
- **ESLint** - 代码质量检查
- **Jest** - 单元测试框架

### 后端技术栈
- **Node.js** - 服务器运行时
- **Express.js** - Web应用框架
- **PostgreSQL** - 主数据库
- **Redis** - 缓存和会话存储
- **JWT** - 身份认证
- **Multer** - 文件上传处理

### 基础设施
- **Docker** - 容器化部署
- **Docker Compose** - 多容器编排
- **Nginx** - 反向代理和负载均衡
- **Prometheus** - 监控和指标收集
- **Grafana** - 数据可视化
- **ELK Stack** - 日志管理

## 📁 项目结构

```
FabricaGenerate/
├── Generate/                 # 前端应用
│   ├── js/                  # JavaScript模块
│   ├── css/                 # 样式文件
│   ├── imgs/                # 图片资源
│   └── tests/               # 前端测试
├── fabrica-backend/         # 后端API服务
│   ├── routes/              # API路由
│   ├── models/              # 数据模型
│   ├── middleware/          # 中间件
│   ├── config/              # 配置文件
│   └── tests/               # 后端测试
├── scripts/                 # 部署和管理脚本
├── monitoring/              # 监控配置
├── nginx/                   # Nginx配置
├── security/                # 安全配置
└── performance/             # 性能测试
```

## 🚀 快速开始

### 环境要求
- Node.js 16+
- Docker & Docker Compose
- PostgreSQL 13+
- Redis 6+

### 本地开发

1. **克隆项目**
```bash
git clone https://github.com/MaddieMo1/FabricaGenerate.git
cd FabricaGenerate
```

2. **启动开发环境**
```bash
# 使用Docker Compose启动所有服务
docker-compose up -d

# 或者分别启动前后端
cd Generate && npm install && npm start
cd fabrica-backend && npm install && npm run dev
```

3. **访问应用**
- 前端: http://localhost:3000
- 后端API: http://localhost:5000
- API文档: http://localhost:5000/api-docs

### 生产部署

使用自动化部署脚本：

```bash
# 部署到生产环境
./scripts/deploy.sh --env production --branch main

# 部署到测试环境
./scripts/deploy.sh --env testing --branch develop
```

## 📊 监控和运维

### 监控面板
- **Grafana**: http://localhost:3001 (监控仪表板)
- **Prometheus**: http://localhost:9090 (指标收集)
- **Kibana**: http://localhost:5601 (日志分析)

### 健康检查
```bash
# 检查服务状态
./scripts/health-check.sh

# 查看部署状态
./scripts/deploy.sh status
```

### 备份和恢复
```bash
# 创建备份
./scripts/backup.sh

# 恢复数据
./scripts/backup-restore.sh /path/to/backup
```

## 🔒 安全特性

- **容器安全扫描**：集成Trivy安全扫描
- **依赖漏洞检测**：Snyk安全监控
- **SSL/TLS加密**：自动SSL证书管理
- **API限流**：防止API滥用
- **输入验证**：严格的数据验证和清理

## 🧪 测试

```bash
# 运行前端测试
cd Generate && npm test

# 运行后端测试
cd fabrica-backend && npm test

# 运行集成测试
npm run test:integration

# 性能测试
./scripts/performance-monitor.sh
```

## 📈 性能优化

- **CDN集成**：静态资源全球分发
- **缓存策略**：多层缓存优化
- **数据库优化**：索引和查询优化
- **图片压缩**：自动图片优化
- **代码分割**：按需加载优化

## 🤝 贡献指南

1. Fork 项目
2. 创建功能分支 (`git checkout -b feature/AmazingFeature`)
3. 提交更改 (`git commit -m 'Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 打开 Pull Request

详细贡献指南请参考 [CONTRIBUTING.md](CONTRIBUTING.md)

## 📄 许可证

本项目采用 MIT 许可证 - 查看 [LICENSE](LICENSE) 文件了解详情

## 📞 支持

- 📧 邮箱: support@fabricagenerate.com
- 🐛 问题反馈: [GitHub Issues](https://github.com/MaddieMo1/FabricaGenerate/issues)
- 📖 文档: [项目文档](https://docs.fabricagenerate.com)

## 🙏 致谢

感谢所有为这个项目做出贡献的开发者和社区成员！

---

⭐ 如果这个项目对你有帮助，请给我们一个星标！