# 📸 Sistema de Snapshots (Savepoints)

**Objetivo:** Permitir que você salve seu progresso no projeto e possa voltar a qualquer momento caso algo dê errado. É como o 'Save' de um videogame.

## Como usar

### 1. Criar um Snapshot (Salvar)
Sempre que você terminar uma fase importante ou antes de começar uma mudança arriscada, peça ao Atlas:
> "Atlas, tirar snapshot" ou "/snapshot"

**O que acontece:**
- Seus arquivos são salvos e commitados.
- Uma "etiqueta" (tag) com a data e hora é criada.
- Tudo é enviado para o seu GitHub.

### 2. Restaurar um Snapshot (Voltar no tempo)
Se o projeto quebrou e você quer voltar para quando estava funcionando:
> "Atlas, restaurar snapshot" ou "/restore"

**O que acontece:**
- O Atlas vai listar os pontos de salvamento.
- Você escolhe um, e ele restaura os arquivos exatamente como estavam.

---

## Dicas de Boas Práticas
- **Dê nomes:** Se quiser, pode pedir "Atlas, tirar snapshot da fase de login".
- **Não tenha medo:** Se algo der errado, o snapshot é sua rede de segurança.

> [!IMPORTANT]
> O sistema usa **Git Tags** por baixo dos panos. É uma forma profissional e segura de gerenciar versões!
