// Artillery 性能测试处理器
// 用于自定义测试逻辑和数据处理

const fs = require('fs');
const path = require('path');

module.exports = {
  // 生成随机邮箱
  randomEmail,
  // 生成随机字符串
  randomString,
  // 设置测试数据
  setTestData,
  // 验证响应
  validateResponse,
  // 记录测试结果
  logTestResult
};

/**
 * 生成随机邮箱地址
 */
function randomEmail(context, events, done) {
  const domains = ['test.com', 'example.com', 'demo.org'];
  const randomDomain = domains[Math.floor(Math.random() * domains.length)];
  const randomUser = Math.random().toString(36).substring(7);
  
  context.vars.randomEmail = `${randomUser}@${randomDomain}`;
  return done();
}

/**
 * 生成随机字符串
 */
function randomString(context, events, done) {
  const length = 8;
  const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
  let result = '';
  
  for (let i = 0; i < length; i++) {
    result += chars.charAt(Math.floor(Math.random() * chars.length));
  }
  
  context.vars.randomString = result;
  return done();
}

/**
 * 设置测试数据
 */
function setTestData(context, events, done) {
  // 设置测试用户数据
  context.vars.testUsers = [
    { email: 'user1@test.com', password: 'testPassword123' },
    { email: 'user2@test.com', password: 'testPassword123' },
    { email: 'user3@test.com', password: 'testPassword123' }
  ];
  
  // 设置测试文件路径
  context.vars.testFiles = [
    './test-files/sample.obj',
    './test-files/sample.stl',
    './test-files/sample.ply'
  ];
  
  return done();
}

/**
 * 验证响应数据
 */
function validateResponse(requestParams, response, context, events, done) {
  // 检查响应状态码
  if (response.statusCode >= 400) {
    console.error(`请求失败: ${response.statusCode} - ${response.body}`);
    events.emit('error', new Error(`HTTP ${response.statusCode}`));
  }
  
  // 检查响应时间
  const responseTime = response.timings.response;
  if (responseTime > 5000) {
    console.warn(`响应时间过长: ${responseTime}ms`);
  }
  
  // 验证JSON响应
  if (response.headers['content-type'] && response.headers['content-type'].includes('application/json')) {
    try {
      const jsonBody = JSON.parse(response.body);
      if (jsonBody.error) {
        console.error(`API错误: ${jsonBody.error}`);
      }
    } catch (e) {
      console.error('JSON解析失败:', e.message);
    }
  }
  
  return done();
}

/**
 * 记录测试结果
 */
function logTestResult(context, events, done) {
  const timestamp = new Date().toISOString();
  const logEntry = {
    timestamp,
    scenario: context.scenario?.name || 'unknown',
    userId: context.vars.userId,
    responseTime: context._lastResponseTime,
    statusCode: context._lastStatusCode
  };
  
  // 写入日志文件
  const logFile = path.join(__dirname, 'test-results.log');
  fs.appendFileSync(logFile, JSON.stringify(logEntry) + '\n');
  
  return done();
}