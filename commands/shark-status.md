#  STATUS DO PROJETO S.H.A.R.K.

## VERIFICANDO STATUS...

Vou ler o arquivo `docs/asbuilt.md` para mostrar o estado atual do projeto.

---

## LEITURA DO ASBUILT

[Aqui o agente deve ler docs/asbuilt.md e extrair:]

- Nome do projeto
- Última atualização
- Fases (status e progresso)
- Última sessão
- Pendências
- Bloqueios

---

## SE NÃO EXISTIR asbuilt.md:

 **Este projeto ainda não está usando o Método S.H.A.R.K.**

**Para começar:**

### Projeto NOVO:
Digite: `shiva, go!`
- Shiva vai criar a especificação completa
- Depois Hades implementa

### Projeto EXISTENTE:
Digite: `hades, go!`
- Hades vai criar o asbuilt.md
- Depois continua a implementação

---

## FORMATO DO DASHBOARD

Quando encontrar asbuilt.md, mostrar:
```
 PROJETO: [Nome]
 Última atualização: [Data]



 ROADMAP

FASE 01: [Nome] -  Completa (100%)
FASE 02: [Nome] -  Em Andamento (60%)
FASE 03: [Nome] -  Aguardando (0%)
FASE 04: [Nome] -  Aguardando (0%)



 ÚLTIMA SESSÃO: [Data]
Trabalho: [Resumo]
Próximo: [Próximo passo]



 PENDÊNCIAS:
- [Lista de pendências]

 BLOQUEIOS:
- [Lista de bloqueios ou "Nenhum"]


```

---

## PRÓXIMOS PASSOS

Com base no status, sugira:
- Se fase incompleta: `hades, go!` para continuar
- Se pronto para testes: `ravena, go!`
- Se testado: `kerberos, go!`
- Se auditado: Deploy para produção!
