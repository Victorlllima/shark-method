#  AJUDA DO MÉTODO S.H.A.R.K.

## O QUE É O S.H.A.R.K.?

Sistema de desenvolvimento com 5 agentes especializados que trabalham em equipe para criar aplicações web completas.

---

## OS 5 AGENTES

###  SHIVA - Especificação
- **O que faz:** Entende sua ideia e cria especificação técnica completa
- **Quando usar:** Início de projeto novo
- **Ativar:** `shiva, go!`

###  HADES - Planejamento
- **O que faz:** Traduz especificação em instruções técnicas para execução
- **Quando usar:** Implementar funcionalidades
- **Ativar:** `hades, go!`

###  ATLAS - Execução
- **O que faz:** ÚNICO que executa código (trabalha via Hades)
- **Quando usar:** Automático via Hades
- **Ativar:** Automático

###  RAVENA - Testes (QA)
- **O que faz:** Testa funcionalidades, navegação, UI/UX com Browser Agent
- **Quando usar:** Antes de produção
- **Ativar:** `ravena, go!`

###  KERBEROS - Segurança
- **O que faz:** Auditoria de segurança, pentests, compliance LGPD
- **Quando usar:** Antes de produção (após Ravena)
- **Ativar:** `kerberos, go!`

---

## FLUXO TÍPICO

###  PROJETO NOVO:
```
1. shark status           Ver estado atual
2. shiva, go!             Criar especificação
3. hades, go!             Implementar (Atlas executa)
4. ravena, go!            Testar funcionalidades
5. kerberos, go!          Auditar segurança
6. PRODUÇÃO! 
```

###  PROJETO EXISTENTE:
```
1. shark status           Ver onde parou
2. hades, go!             Continuar implementação
3. ravena, go!            Testar
4. kerberos, go!          Auditar
5. PRODUÇÃO! 
```

---

## COMANDOS DISPONÍVEIS

- `shark ajuda` - Esta ajuda
- `shark status` - Status do projeto atual
- `shiva, go!` - Ativar Shiva (especificação)
- `hades, go!` - Ativar Hades (implementação)
- `ravena, go!` - Ativar Ravena (testes)
- `kerberos, go!` - Ativar Kerberos (segurança)

---

## ARQUIVOS IMPORTANTES

- `docs/asbuilt.md` - Documentação viva do projeto
- `.agent/rules/` - Regras específicas do projeto
- `~/.gemini/` - Configuração global S.H.A.R.K.

---

## STACK TÉCNICA

**Infraestrutura (obrigatória):**
- GitHub - Versionamento
- Supabase - Backend completo
- Vercel - Deploy automático

**Frontend (recomendado):**
- Next.js 15 - Framework
- TypeScript - Type safety
- Tailwind CSS - Estilização
- Shadcn/ui - Componentes

---

## DÚVIDAS?

Digite o nome do agente que quer ativar seguido de `go!`

Exemplo: `shiva, go!`
