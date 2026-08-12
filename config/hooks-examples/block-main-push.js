#!/usr/bin/env node
/**
 * HOOK S.H.A.R.K. — Bloqueia git push para main sem aprovação dupla
 *
 * Lê stdin JSON do harness do Claude Code, verifica se o comando Bash é
 * `git push origin main` (ou variações), e exige aprovação prévia de
 * Ravena (QA) e Kerberos (segurança) registrada em .shark/approvals/.
 *
 * Como Ravena/Kerberos aprovam:
 *   Ao final do relatório APROVADO, cada agente executa:
 *     mkdir -p .shark/approvals
 *     touch .shark/approvals/ravena-approved-<commit-hash>
 *     touch .shark/approvals/kerberos-approved-<commit-hash>
 *
 * Exit codes:
 *   0 → permitir
 *   2 → bloquear (mensagem em stderr é mostrada ao modelo)
 */

const fs = require('fs');
const { execSync } = require('child_process');

let payload = '';
process.stdin.on('data', (chunk) => (payload += chunk));
process.stdin.on('end', () => {
  try {
    const input = JSON.parse(payload || '{}');
    const command = input?.tool_input?.command || '';

    // Detecta variações de push para main
    const isPushToMain = /\bgit\s+push\b.*\b(origin|upstream)\b.*\bmain\b/i.test(command)
      || /\bgit\s+push\b.*\bmain\b/i.test(command);

    if (!isPushToMain) {
      process.exit(0);
    }

    // Captura hash do commit HEAD
    let commitHash;
    try {
      commitHash = execSync('git rev-parse HEAD', { encoding: 'utf8' }).trim();
    } catch {
      console.error('❌ S.H.A.R.K. hook: não foi possível ler git HEAD — abortando push.');
      process.exit(2);
    }

    const approvalsDir = '.shark/approvals';
    const ravenaApproval = `${approvalsDir}/ravena-approved-${commitHash}`;
    const kerberosApproval = `${approvalsDir}/kerberos-approved-${commitHash}`;

    const ravenaOk = fs.existsSync(ravenaApproval);
    const kerberosOk = fs.existsSync(kerberosApproval);

    if (ravenaOk && kerberosOk) {
      process.exit(0);
    }

    const missing = [];
    if (!ravenaOk) missing.push('RAVENA (QA)');
    if (!kerberosOk) missing.push('KERBEROS (segurança)');

    console.error(`\n🚨 S.H.A.R.K. — PUSH PARA MAIN BLOQUEADO\n`);
    console.error(`Commit: ${commitHash}`);
    console.error(`Aprovações faltando: ${missing.join(' + ')}\n`);
    console.error(`Para destravar, esses agentes devem aprovar primeiro:`);
    console.error(`  → Convoque a Ravena: "Ravena, faz o QA completo"`);
    console.error(`  → Convoque o Kerberos: "Kerberos, audita pra produção"`);
    console.error(`\nNenhum push para main é permitido sem aprovação dupla.\n`);
    process.exit(2);
  } catch (err) {
    console.error(`S.H.A.R.K. hook error: ${err.message}`);
    process.exit(0); // fail-open em caso de erro do hook para não travar Red
  }
});
