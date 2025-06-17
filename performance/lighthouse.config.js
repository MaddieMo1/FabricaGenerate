// Lighthouse 性能测试配置
// 用于前端性能和用户体验测试

module.exports = {
  // 扩展默认配置
  extends: 'lighthouse:default',
  
  // 测试设置
  settings: {
    // 测试设备类型
    formFactor: 'desktop',
    
    // 网络节流
    throttling: {
      rttMs: 40,
      throughputKbps: 10240,
      cpuSlowdownMultiplier: 1,
      requestLatencyMs: 0,
      downloadThroughputKbps: 0,
      uploadThroughputKbps: 0
    },
    
    // 屏幕模拟
    screenEmulation: {
      mobile: false,
      width: 1350,
      height: 940,
      deviceScaleFactor: 1,
      disabled: false
    },
    
    // 用户代理
    emulatedUserAgent: 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/98.0.4758.109 Safari/537.36 lighthouse',
    
    // 审计设置
    onlyAudits: [
      'first-contentful-paint',
      'largest-contentful-paint',
      'first-meaningful-paint',
      'speed-index',
      'interactive',
      'cumulative-layout-shift',
      'total-blocking-time'
    ],
    
    // 输出格式
    output: ['json', 'html'],
    
    // 最大等待时间
    maxWaitForLoad: 45000,
    
    // 跳过审计
    skipAudits: [
      'uses-http2',
      'uses-long-cache-ttl'
    ]
  },
  
  // 自定义审计
  audits: [
    'metrics/first-contentful-paint',
    'metrics/largest-contentful-paint',
    'metrics/cumulative-layout-shift',
    'metrics/total-blocking-time'
  ],
  
  // 类别配置
  categories: {
    performance: {
      title: '性能',
      description: '这些检查确保您的页面针对速度进行了优化。',
      auditRefs: [
        { id: 'first-contentful-paint', weight: 10, group: 'metrics' },
        { id: 'largest-contentful-paint', weight: 25, group: 'metrics' },
        { id: 'first-meaningful-paint', weight: 10, group: 'metrics' },
        { id: 'speed-index', weight: 10, group: 'metrics' },
        { id: 'interactive', weight: 10, group: 'metrics' },
        { id: 'cumulative-layout-shift', weight: 25, group: 'metrics' },
        { id: 'total-blocking-time', weight: 30, group: 'metrics' }
      ]
    }
  },
  
  // 组配置
  groups: {
    metrics: {
      title: '指标'
    }
  }
};