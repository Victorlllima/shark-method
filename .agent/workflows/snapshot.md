---
description: tirar snapshot do projeto (savepoint)
---

Este workflow cria um ponto de restauração (snapshot) do projeto usando Git tags.

// turbo-all
1. Verifique se há alterações não commitadas e faça o commit:
```powershell
git add .
git commit -m "Snapshot: $(Get-Date -Format 'yyyy-MM-dd HH:mm')"
```

2. Crie uma tag com o timestamp atual:
```powershell
$tagName = "snap-$(Get-Date -Format 'yyyyMMdd-HHmm')"
git tag $tagName
echo "Snapshot criado com a tag: $tagName"
```

3. Envie as alterações e a tag para o GitHub:
```powershell
git push origin dev
git push origin --tags
```

4. Atualize a tabela de snapshots no [asbuilt.md](file:///C:/Users/victo_htyd3kj/OneDrive/Desktop/Projetos/Vibecoding/shark-method/docs/asbuilt.md).
