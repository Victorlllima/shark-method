#!/usr/bin/env node

const fs = require('fs');
const path = require('path');

function getStatus() {
  const asbuiltPath = path.join(process.cwd(), 'docs', 'asbuilt.md');
  
  if (!fs.existsSync(asbuiltPath)) {
    return {
      exists: false,
      message: 'Arquivo asbuilt.md não encontrado'
    };
  }

  const content = fs.readFileSync(asbuiltPath, 'utf-8');
  
  // Extrair nome do projeto
  const nameMatch = content.match(/^# (.+)/m);
  const projectName = nameMatch ? nameMatch[1] : 'Desconhecido';
  
  // Extrair última atualização
  const updateMatch = content.match(/\*\*Última atualização:\*\* (.+)/);
  const lastUpdate = updateMatch ? updateMatch[1] : 'Desconhecida';
  
  // Extrair fases
  const phaseRegex = /###  FASE (\d+): (.+?)\n\*\*Status:\*\* `(.+?)`\n\*\*Progresso:\*\* (\d+)\/(\d+)/g;
  const phases = [];
  let match;
  
  while ((match = phaseRegex.exec(content)) !== null) {
    phases.push({
      number: match[1],
      name: match[2],
      status: match[3],
      completed: parseInt(match[4]),
      total: parseInt(match[5]),
      percentage: Math.round((parseInt(match[4]) / parseInt(match[5])) * 100)
    });
  }
  
  // Extrair última sessão
  const sessionMatch = content.match(/### Sessão (.+?)\n\*\*Duração:\*\* (.+?)\n\*\*Trabalho Realizado:\*\*([\s\S]*?)\n\*\*Próximos Passos:\*\*([\s\S]*?)(?=\n---|\n##|$)/);
  const lastSession = sessionMatch ? {
    date: sessionMatch[1],
    duration: sessionMatch[2],
    work: sessionMatch[3].trim().split('\n').filter(l => l.trim()),
    next: sessionMatch[4].trim().split('\n').filter(l => l.trim())
  } : null;
  
  // Extrair pendências
  const pendingMatch = content.match(/\*\*Pendências Técnicas:\*\*([\s\S]*?)(?=\n---|\n##|$)/);
  const pending = pendingMatch ? pendingMatch[1].trim().split('\n').filter(l => l.trim()) : [];
  
  // Extrair bloqueios
  const blockersMatch = content.match(/\*\*Bloqueios Atuais:\*\*([\s\S]*?)(?=\n\*\*Pendências|\n---|\n##|$)/);
  const blockers = blockersMatch ? blockersMatch[1].trim().split('\n').filter(l => l.trim()) : [];
  
  const totalPhases = phases.length;
  const completedPhases = phases.filter(p => p.percentage === 100).length;
  
  // Gerar Dashboard Visual
  console.log(`\n🦈 MÉTODO S.H.A.R.K. - DASHBOARD DE STATUS`);
  console.log(`==========================================`);
  console.log(`📂 PROJETO: ${projectName}`);
  console.log(`📅 ÚLTIMA ATUALIZAÇÃO: ${lastUpdate}`);
  console.log(`\n📍 ROADMAP`);
  
  phases.forEach(p => {
    const barLength = 20;
    const filled = Math.round((p.percentage / 100) * barLength);
    const bar = '█'.repeat(filled) + '░'.repeat(barLength - filled);
    const emoji = p.percentage === 100 ? '✅' : (p.percentage > 0 ? '🔄' : '⏳');
    console.log(`${emoji} FASE ${p.number}: ${p.name.padEnd(30)} [${bar}] ${p.percentage}%`);
  });

  if (lastSession) {
    console.log(`\n🕒 ÚLTIMA SESSÃO (${lastSession.date})`);
    console.log(`➖ Trabalho: ${lastSession.work[0] || 'Nenhum'}`);
    console.log(`➖ Próximo: ${lastSession.next[0] || 'Nenhum'}`);
  }

  if (blockers.length > 0) {
    console.log(`\n🚨 BLOQUEIOS:`);
    blockers.forEach(b => console.log(`  - ${b}`));
  }

  console.log(`\n==========================================`);
  
  return {
    exists: true,
    projectName,
    lastUpdate,
    phases,
    lastSession,
    pending,
    blockers
  };
}

if (require.main === module) {
  const status = getStatus();
}

module.exports = { getStatus };
