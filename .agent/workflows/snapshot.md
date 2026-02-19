---
description: tirar snapshot do projeto (savepoint)
---

Este workflow cria um ponto de restauração (snapshot) com um nome amigável estilo "Friends" ("Aquele em que...").

1. **Definir o Nome do Episódio**:
   - Analise as últimas alterações no código.
   - Pergunte ao usuário: \"Como se chama esse 'episódio', [NOME]? (Sugestão: Aquele em que...)\"\r\n   - Garanta que o nome comece com "Aquele em que..." ou "Aquele com...".

2. **Commit e Tag**:
   - Execute o commit com o nome amigável:
   ```powershell
   git add .
   git commit -m "Snapshot: [NOME_DO_EPISODIO]"
   ```
   - Crie a tag técnica:
   ```powershell
   $tagName = "snap-$(Get-Date -Format 'yyyyMMdd-HHmm')"
   git tag $tagName
   ```

3. **Atualizar AsBuilt**:
   - Adicione uma nova linha na tabela de Snapshots em [asbuilt.md](file:///C:/Users/victo_htyd3kj/OneDrive/Desktop/Projetos/Vibecoding/shark-method/docs/asbuilt.md) contendo a Data, a Tag, o Nome Amigável e o Status ✅.

4. **Sincronizar**:
   ```powershell
   git push origin main
   git push origin --tags
   ```
