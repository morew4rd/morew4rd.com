#!/usr/bin/env node
const fs = require('fs');
const path = require('path');

if (process.argv.length < 3) {
  console.error('Usage: create-short <title>');
  process.exit(1);
}
const body = process.argv.slice(2).join(' ');

// Determine next numeric filename in content/blog/shorts
const shortsDir = path.resolve(__dirname, '../content/blog/shorts');
const files = fs.readdirSync(shortsDir)
  .filter(f => /^\d+\.md$/.test(f))
  .map(f => parseInt(f.split('.md')[0], 10));

const nextNum = (files.length ? Math.max(...files) + 1 : 1).toString().padStart(4, '0');
const newFile = path.join(shortsDir, `${nextNum}.md`);

// Eleventy front‑matter with timestamp
const now = new Date(new Date() - (new Date().getTimezoneOffset() * 60000))
const postDate = now.toISOString();

const content = `---
date: ${postDate}
---

${body}
`;

fs.writeFileSync(newFile, content);
console.log(`Created ${newFile}`);
