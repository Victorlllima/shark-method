# COMANDOS S.H.A.R.K. - DEFINIÇÕES

Este arquivo define todos os comandos reconhecidos pelo sistema S.H.A.R.K.

## COMANDOS DE AJUDA

### shark ajuda
- **Aliases:** `shark help`, `ajuda`, `/shark-help`
- **Ação:** Carregar `~/.gemini/commands/shark-help.md`
- **Descrição:** Mostra ajuda completa do método

### shark status
- **Aliases:** `status`, `/shark-status`
- **Ação:** Carregar `~/.gemini/commands/shark-status.md`
- **Descrição:** Mostra status do projeto atual (lê asbuilt.md)

---

## COMANDOS DE ATIVAÇÃO DE AGENTES

### shiva, go!
- **Aliases:** `shiva go`, `ativar shiva`, `/shiva-start`
- **Ação:** Carregar `~/.gemini/agents/shiva.md`
- **Descrição:** Ativa SHIVA para especificação de produto

### hades, go!
- **Aliases:** `hades go`, `ativar hades`, `/hades-start`
- **Ação:** Carregar `~/.gemini/agents/hades.md`
- **Descrição:** Ativa HADES para planejamento técnico

### ravena, go!
- **Aliases:** `ravena go`, `ativar ravena`, `/ravena-start`
- **Ação:** Carregar `~/.gemini/agents/ravena.md`
- **Descrição:** Ativa RAVENA para testes e QA

### kerberos, go!
- **Aliases:** `kerberos go`, `ativar kerberos`, `/kerberos-start`
- **Ação:** Carregar `~/.gemini/agents/kerberos.md`
- **Descrição:** Ativa KERBEROS para auditoria de segurança

---

## COMPORTAMENTO

Ao reconhecer qualquer destes comandos, o sistema deve:

1.  Reconhecer IMEDIATAMENTE (sem pedir confirmação)
2.  Carregar o arquivo correspondente
3.  Assumir a personalidade do agente
4.  Iniciar o protocolo apropriado

---

## NOTAS

- ATLAS não tem comando de ativação (trabalha via HADES)
- Comandos são case-insensitive
- Aceita variações com/sem vírgula e exclamação
