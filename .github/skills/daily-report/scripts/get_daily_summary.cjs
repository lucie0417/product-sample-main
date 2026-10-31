#!/usr/bin/env node

const { execSync } = require('child_process');

function getGitLog() {
  try {
    const today = new Date().toISOString().split('T')[0];
    return execSync(`git log --since="${today} 00:00:00" --pretty=format:"[%h] %s"`, { encoding: 'utf-8' });
  } catch (e) {
    return '無法獲取 Git 紀錄。';
  }
}

function getGitDiff() {
  try {
    return execSync('git diff --stat', { encoding: 'utf-8' });
  } catch (e) {
    return '無未提交的變更。';
  }
}

function getStagedDiff() {
  try {
    return execSync('git diff --cached --stat', { encoding: 'utf-8' });
  } catch (e) {
    return '無暫存的變更。';
  }
}

const today = new Date().toLocaleDateString('zh-TW', { year: 'numeric', month: '2-digit', day: '2-digit' });

console.log(`📋 每日工作日報資料 — ${today}`);
console.log('='.repeat(40));

console.log('\n--- 今日 Git Commits ---');
console.log(getGitLog() || '今日尚無 Commit。');

console.log('\n--- 未提交的變更概覽 ---');
console.log(getGitDiff() || '無未提交的變更。');

console.log('\n--- 暫存區變更概覽 ---');
console.log(getStagedDiff() || '無暫存的變更。');
