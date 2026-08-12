#!/usr/bin/env node
/**
 * HOOK S.H.A.R.K. — Log de atividade de QA (Ravena)
 *
 * Captura toda invocação de browser MCPs (Playwright, Chrome DevTools, Dev-Browser)
 * em .shark/logs/qa-<YYYY-MM-DD>.jsonl para observabilidade e debugging de regressões.
 *
 * Não bloqueia. Não interfere. Só registra.
 */

const fs = require('fs');
const path = require('path');

let payload = '';
process.stdin.on('data', (chunk) => (payload += chunk));
process.stdin.on('end', () => {
  try {
    const input = JSON.parse(payload || '{}');
    const toolName = input?.tool_name || 'unknown';
    const toolInput = input?.tool_input || {};

    const logDir = '.shark/logs';
    fs.mkdirSync(logDir, { recursive: true });

    const date = new Date().toISOString().slice(0, 10);
    const logFile = path.join(logDir, `qa-${date}.jsonl`);

    const entry = {
      timestamp: new Date().toISOString(),
      tool: toolName,
      input: toolInput,
    };

    fs.appendFileSync(logFile, JSON.stringify(entry) + '\n');
    process.exit(0);
  } catch (err) {
    process.exit(0); // fail-open
  }
});
