#!/usr/bin/env node
/**
 * HOOK S.H.A.R.K. — Dispara reminder de /security-review ao editar arquivos sensíveis
 *
 * Sempre que o Atlas (ou qualquer agente) editar arquivos em paths sensíveis
 * (auth, api, migrations, .env*), adiciona um additional_context informando
 * que o Kerberos deve auditar antes do merge.
 *
 * Não bloqueia — apenas alerta o modelo no próximo turno.
 */

const path = require('path');

const SENSITIVE_PATTERNS = [
  /^app\/api\//,
  /^pages\/api\//,
  /^src\/api\//,
  /^lib\/auth\//,
  /^src\/auth\//,
  /^supabase\/migrations\//,
  /^prisma\/migrations\//,
  /\.env(\.|$)/,
  /middleware\.(ts|js)$/,
  /^lib\/rls\//,
];

let payload = '';
process.stdin.on('data', (chunk) => (payload += chunk));
process.stdin.on('end', () => {
  try {
    const input = JSON.parse(payload || '{}');
    const filePath = input?.tool_input?.file_path || '';
    if (!filePath) return process.exit(0);

    // Normaliza path relativo ao cwd
    const cwd = process.cwd();
    const rel = path.relative(cwd, filePath).replace(/\\/g, '/');

    const isSensitive = SENSITIVE_PATTERNS.some((re) => re.test(rel));
    if (!isSensitive) return process.exit(0);

    // Output JSON com additional_context para o próximo turno do modelo
    const output = {
      additional_context: `🛡️ S.H.A.R.K. ALERT — arquivo sensível modificado: ${rel}\n\n` +
        `Kerberos DEVE auditar antes do merge para hml/main.\n` +
        `Sugestão: convocar Kerberos com "Kerberos, audita as mudanças recentes" antes de continuar.`,
    };

    process.stdout.write(JSON.stringify(output));
    process.exit(0);
  } catch (err) {
    process.exit(0); // fail-open
  }
});
