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
  
  return {
    exists: true,
    projectName,
    lastUpdate,
    phases,
    lastSession,
    pending,
    blockers,
    totalPhases: phases.length,
    completedPhases: phases.filter(p => p.percentage === 100).length,
    currentPhase: phases.find(p => p.percentage > 0 && p.percentage < 100)
  };
}

if (require.main === module) {
  const status = getStatus();
  console.log(JSON.stringify(status, null, 2));
}

module.exports = { getStatus };
