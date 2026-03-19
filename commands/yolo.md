---
name: yolo
description: >
  Ativa/desativa o YOLO Mode — modo de execução autônoma onde a IA
  NÃO para por nada: sem confirmações, sem pausas, sem perguntas.
  Execute tudo até completar todas as pendências.
  Use quando disser "yolo", "não para", "executa tudo", "modo autônomo", "roda sem parar".
argument-hint: "on|off|status [contexto opcional]"
---

# YOLO MODE — Execução Autônoma Total

## O que é o YOLO Mode

Modo de execução autônoma onde o agente **não para por nada**:
- Sem confirmações de ação
- Sem pausas para perguntar detalhes
- Sem interrupções no meio da execução
- Erros são corrigidos automaticamente e a execução continua

## Como ativar

Diga qualquer uma destas frases:
- `yolo`
- `yolo on`
- `/yolo`
- `não para`
- `executa tudo`
- `modo autônomo`

## Como desativar

Diga:
- `yolo off`
- `/yolo off`

## Como verificar o estado

Diga:
- `yolo status`
- `/yolo status`

## REGRAS DURANTE YOLO MODE

1. **NUNCA pergunte** "posso continuar?", "devo prosseguir?"
2. **NUNCA pare** no meio de uma implementação para confirmar detalhes
3. **EXECUTE TUDO** necessário para completar a tarefa
4. **SE houver erro**, corrija automaticamente sem parar
5. **Se não especificou detalhes**, tome a decisão mais razoável e execute

## Mensagens de Resposta

Ao ativar:
```
[ATLAS]: YOLO MODE ATIVADO — execução autônoma total. Sem confirmações, sem pausas.
Para desativar: yolo off
```

Ao desativar:
```
[ATLAS]: YOLO MODE DESATIVADO — comportamento normal restaurado.
```
