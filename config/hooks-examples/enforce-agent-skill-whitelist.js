#!/usr/bin/env node
/**
 * HOOK S.H.A.R.K. — Enforce skill whitelist por agente
 *
 * Detecta o agente ativo (a partir do prefixo [AGENTE]: ou de .shark/active-agent)
 * e bloqueia invocação de skills que não estejam na whitelist daquele agente.
 *
 * Whitelist espelha docs/protocolos/plugins-por-agente.md.
 */

const fs = require('fs');

const WHITELIST = {
  shiva:    ['frontend-design', 'writing-plans', 'find-skills', 'skill-creator'],
  hades:    ['systematic-debugging', 'writing-plans', 'subagent-driven-development', 'find-skills'],
  atlas:    ['verification-before-completion', 'writing-plans', 'git-commit', 'gh-cli',
             'stripe-best-practices', 'neon-postgres'],
  ravena:   ['webapp-testing', 'playwright-best-practices'],
  kerberos: ['security-review', 'insecure-defaults', 'supply-chain-risk-auditor',
             'semgrep', 'semgrep-rule-creator', 'differential-review', 'find-skills'],
};

let payload = '';
process.stdin.on('data', (chunk) => (payload += chunk));
process.stdin.on('end', () => {
  try {
    const input = JSON.parse(payload || '{}');
    const skillName = input?.tool_input?.skill || '';
    if (!skillName) return process.exit(0);

    // Detecta agente ativo (escrito por cada agente ao iniciar resposta)
    let activeAgent = null;
    try {
      activeAgent = fs.readFileSync('.shark/active-agent', 'utf8').trim().toLowerCase();
    } catch {
      // Sem agente ativo registrado → permitir (modo Red usando Claude livre)
      return process.exit(0);
    }

    const allowed = WHITELIST[activeAgent];
    if (!allowed) return process.exit(0); // agente desconhecido → não bloquear

    if (allowed.includes(skillName)) return process.exit(0);

    // Bloquear
    console.error(`\n🚨 S.H.A.R.K. — SKILL FORA DA WHITELIST\n`);
    console.error(`Agente ativo: ${activeAgent.toUpperCase()}`);
    console.error(`Skill tentada: /${skillName}`);
    console.error(`Skills permitidas: ${allowed.map((s) => '/' + s).join(', ')}\n`);
    console.error(`Esta skill pertence a outro agente. Passe o bastão:`);
    console.error(`  Design → Shiva | Debug → Hades | Execução → Atlas | QA → Ravena | Segurança → Kerberos\n`);
    process.exit(2);
  } catch (err) {
    process.exit(0); // fail-open
  }
});
