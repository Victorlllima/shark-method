# Receita — Instalação do Arsenal de Segurança (Kerberos)

> Black-box para o Atlas instalar quando o Kerberos pedir. Nenhuma exige token/conta.

## TruffleHog — detecta secrets no git history (+800 tipos)
```bash
# Windows (Chocolatey):
choco install trufflehog
# Linux/macOS:
curl -sSfL https://raw.githubusercontent.com/trufflesecurity/trufflehog/main/scripts/install.sh | sh -s -- -b /usr/local/bin
```

## Semgrep — SAST (regras OWASP)
```bash
pip install semgrep
# ou Docker, sem instalar nada:
# docker run --rm -v "${PWD}:/src" semgrep/semgrep semgrep scan --config=auto
```
`semgrep login` só é necessário para Pro rules — a Community Edition já cobre o OWASP Top 10.

## Nuclei — scanner de CVEs (9000+ templates)
```bash
# macOS:
brew install nuclei
# Windows: baixar ZIP em github.com/projectdiscovery/nuclei/releases (nuclei_windows_amd64.zip)
# Qualquer SO com Go:
go install -v github.com/projectdiscovery/nuclei/v3/cmd/nuclei@latest
```
Baixa os templates automaticamente na primeira execução.

## Gitleaks — varre histórico git
```bash
# Windows (Chocolatey):
choco install gitleaks
# macOS:
brew install gitleaks
```

| Ferramenta | Token? |
|---|---|
| TruffleHog | ❌ Não |
| Semgrep (CE) | ❌ Não |
| Nuclei | ❌ Não |
| Gitleaks | ❌ Não |
