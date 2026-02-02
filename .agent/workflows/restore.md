---
description: restaurar snapshot do projeto (voltar savepoint)
---

Este workflow restaura o projeto para um estado anterior usando uma Git tag.

// turbo-all
1. Liste os snapshots disponíveis:
```powershell
git tag -l "snap-*"
```

2. Pergunte qual tag restaurar (ex: snap-20260202-0900) e faça o checkout:
```powershell
git checkout [TAG_NOME]
```

3. Se houver mudanças no banco de dados, aplique as migrations correspondentes:
```powershell
npx supabase db reset
```

> [!WARNING]
> Restaurar um snapshot mudará os arquivos locais. Certifique-se de que não tem trabalhos importantes não salvos.
