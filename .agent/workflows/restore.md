---
description: restaurar snapshot do projeto (voltar savepoint)
---

Este workflow restaura o projeto usando a lista amigável de snapshots.

1. **Listar Episódios**:
   - Leia o arquivo [asbuilt.md](file:///C:/Users/victo_htyd3kj/OneDrive/Desktop/Projetos/Vibecoding/shark-method/docs/asbuilt.md).
   - Mostre ao usuário a lista de snapshots disponíveis com seus nomes amigáveis (ex: "1. snap-xxxx: Aquele em que...").
   - Pergunte: "Qual episódio você deseja reviver, Red?"

2. **Restaurar**:
   - Após a escolha, execute:
   ```powershell
   git checkout [TAG_ESCOLHIDA]
   git checkout . # Garante que os arquivos reflitam o estado da tag
   ```

3. **Ajustar Banco (se necessário)**:
   - Se o projeto usar Supabase e houver migrations, ofereça rodar:
   ```powershell
   npx supabase db reset
   ```

> [!CAUTION]
> Ao voltar em um episódio, mudanças não salvas no estado atual serão perdidas!
