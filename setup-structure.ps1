# 🦈 Criando estrutura do S.H.A.R.K...

# Criar pastas
New-Item -ItemType Directory -Force -Path config | Out-Null
New-Item -ItemType Directory -Force -Path commands | Out-Null
New-Item -ItemType Directory -Force -Path agents | Out-Null
New-Item -ItemType Directory -Force -Path scripts | Out-Null

# Criar arquivos vazios
New-Item -ItemType File -Force -Path config/GEMINI.md | Out-Null
New-Item -ItemType File -Force -Path commands/shark-commands.md | Out-Null
New-Item -ItemType File -Force -Path commands/shark-help.md | Out-Null
New-Item -ItemType File -Force -Path commands/shark-status.md | Out-Null
New-Item -ItemType File -Force -Path agents-antigravity/shiva.md | Out-Null
New-Item -ItemType File -Force -Path agents-antigravity/hades.md | Out-Null
New-Item -ItemType File -Force -Path agents-antigravity/ravena.md | Out-Null
New-Item -ItemType File -Force -Path agents-antigravity/kerberos.md | Out-Null
New-Item -ItemType File -Force -Path agents-antigravity/atlas.md | Out-Null
New-Item -ItemType File -Force -Path scripts/shark-status.js | Out-Null
New-Item -ItemType File -Force -Path scripts/package.json | Out-Null
New-Item -ItemType File -Force -Path install.sh | Out-Null
New-Item -ItemType File -Force -Path install.ps1 | Out-Null

Write-Host ""
Write-Host "✅ Estrutura criada!" -ForegroundColor Green
Write-Host ""
Write-Host "📂 Arquivos criados:" -ForegroundColor Yellow
Write-Host ""
Get-ChildItem -Recurse -File | Where-Object { .FullName -notlike "*\.git\*" } | Select-Object FullName
