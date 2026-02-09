# 💾 Protocolo de Savepoint (S.H.A.R.K.)

Este protocolo define o ritual obrigatório de encerramento de qualquer sessão de trabalho para garantir que o contexto nunca seja perdido, simulando a persistência do "Mission Control".

## 🎯 Gatilhos (Quando acionar?)
O Savepoint **NÃO** depende do tamanho da tarefa, mas sim do **fim da interação**.

1.  **Sempre que eu for te chamar (Notify User)**: Antes de te dar uma resposta final ou pedir sua opinião, eu atualizo o Savepoint. É o meu "relatório de saída".
2.  **Troca de Agente**: Se eu terminar minha parte e for passar a bola para o Atlas ou Hades, eu deixo o Savepoint redondinho.
3.  **Final de Expediente**: Se você disser "tchau" ou "parar por aqui", eu faço o último registro do dia.

## 📝 O Ritual de Encerramento
Antes de finalizar qualquer interação significativa, o agente em comando DEVE:

1.  **Atualizar o `task.md`**: Marcar tarefas concluídas e detalhar o que está "in-progress".
2.  **Atualizar o `WORKING.md`**: Escrever o status atual (ver estrutura abaixo).
3.  **Gerar o Sumário de Handover**:
    -   O que foi feito?
    -   O que ficou pendente?
    -   Qual é o "próximo passo óbvio"?
    -   **Missões Inteligentes (@mentions)**: Usar @Agente no final do `WORKING.md` para dizer quem deve assumir. Ex: `@hades: revise o plano técnico`.

## 📂 Estrutura do `WORKING.md`
O arquivo deve ser mantido no root do projeto com a seguinte estrutura:

```markdown
# 📍 Status Atual (SAVEPOINT)

## 🏗️ O que estamos construindo
[Breve descrição do objetivo atual]

## ✅ Últimos Avanços
- [ ] Item concluído
- [ ] Item concluído

## 🚧 Impedimentos / Pendências
- [ ] O que está travando?
- [ ] O que precisa de decisão do Red?

## 🎯 Próximo Passo Óbvio
[Ação imediata para quem assumir a próxima sessão]

## 📬 Mensagens para o Time
- `@agente`: Instrução específica.
```

## ⚠️ Regra de Ouro
"Se não está escrito no `WORKING.md`, não aconteceu para o próximo agente."
