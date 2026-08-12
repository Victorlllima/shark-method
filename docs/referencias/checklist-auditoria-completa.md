# Checklist de Auditoria Completa — Aplicação, Negócio e Privacidade

> Referência consultada pelo **KERBEROS** nas Fases 8 e 9 do protocolo de auditoria.
> Não leia este arquivo inteiro de uma vez — abra a seção da fase que você está executando.
>
> **Base:** OWASP Top 10:2025 · OWASP ASVS 5.0 · OWASP API Security Top 10 · LGPD (Lei 13.709/2018).
> **Escopo:** este arquivo cobre o que o pentest de codebase (Fases 1–7) **não** alcança —
> lógica de aplicação, regras de negócio e tratamento de dados pessoais.

---

## 📏 COMO CLASSIFICAR CADA ITEM

Todo item recebe **um** destes quatro status. Não existe meio-termo.

| Status | Quando usar | O que é obrigatório |
|---|---|---|
| ✅ **ATENDE** | A proteção existe **e** você viu a evidência | arquivo:linha, policy, config ou output de teste |
| 🟡 **ATENDE PARCIALMENTE** | Existe, mas com furo, exceção ou cobertura incompleta | evidência do que existe **+** onde falha |
| ❌ **NÃO ATENDE** | Você procurou e a proteção não existe | onde deveria estar e não está |
| ⬜ **NÃO FOI POSSÍVEL VERIFICAR** | Sem acesso (produção, infra de terceiro, credencial ausente) | o que faltou para verificar |

### 🚨 A REGRA DA EVIDÊNCIA (não negociável)

> **Nunca marque ATENDE porque o desenvolvedor disse que existe.**
> Comentário no código, item de README, mensagem no chat e nome de função
> (`validateAccess()`) **não são evidência** — são intenção.

Evidência válida é uma destas:
- `arquivo:linha` com o código que executa a proteção
- policy RLS retornada pelo banco (`SELECT ... FROM pg_policies`)
- output real de um teste que você rodou
- header HTTP capturado na resposta
- config de infra (WAF, bucket, CORS) lida da fonte

**Sem evidência → ⬜ NÃO FOI POSSÍVEL VERIFICAR.** Nunca ✅.

---

## 1️⃣ CONTROLE DE ACESSO — `A01:2025 Broken Access Control`

> Categoria #1 do OWASP há duas edições seguidas. Em 2025 absorveu também o SSRF.

- [ ] **RBAC existe e a hierarquia é explícita** — há uma tabela/enum de cargos e um mapa cargo→permissão. Não vale "if user.isAdmin" espalhado.
- [ ] **Autorização roda no SERVIDOR** — esconder o botão no frontend não é autorização. Teste: chame o endpoint direto (curl/Postman) sem passar pela UI.
- [ ] **IDOR / BOLA** — logado como User A, troque o ID do recurso para o de User B. `200 OK` em recurso alheio = confirmado.
- [ ] **Isolamento entre organizações (multi-tenant)** — o `tenant_id`/`clinica_id` vem do **token do servidor**, nunca do body/query do cliente. Um usuário da Clínica A não enxerga nada da Clínica B.
- [ ] **Deny by default** — rota nova sem regra explícita nasce **negada**. Teste: crie um endpoint sem middleware de auth e veja se ele responde.
- [ ] **Menor privilégio** — cada papel tem o mínimo necessário. Conta de serviço não usa `service_role`/superuser para tarefa que um papel restrito resolve.
- [ ] **Escalada vertical** — usuário comum consegue chamar endpoint de admin?
- [ ] **Escalada horizontal** — usuário consegue alterar o próprio `role`/`plano` via PATCH no próprio perfil?
- [ ] **SSRF (agora dentro de A01)** — endpoint que aceita URL do cliente e faz request server-side. Teste com `http://169.254.169.254/` (metadata da cloud) e `http://localhost:`.

**🔴 Reprovação automática:** IDOR confirmado · vazamento entre tenants · autorização só no frontend.

---

## 2️⃣ AUTENTICAÇÃO E RECUPERAÇÃO DE CONTA — `A07:2025 Authentication Failures`

- [ ] **Política de senha** — mínimo 8 caracteres (ASVS 5.0 recomenda 12+), verificação contra lista de senhas vazadas (HIBP/Pwned). **Não** exigir troca periódica sem motivo — ASVS 5.0 desaconselha.
- [ ] **Hashing** — bcrypt/argon2/scrypt com salt. Nunca MD5, SHA1 ou SHA256 puro.
- [ ] **Primeiro acesso** — convite com token de uso único e expiração. Nunca senha padrão previsível (`Mudar@123`).
- [ ] **Redefinição de senha** — token aleatório (≥128 bits), uso único, expiração curta (≤1h), invalidado ao ser usado.
- [ ] **Enumeração de usuários** — a resposta de "esqueci a senha" é **idêntica** para e-mail existente e inexistente? Compare também o **tempo de resposta** (timing attack) e o código HTTP.
- [ ] **Força bruta** — bloqueio progressivo após N tentativas, por conta **e** por IP. Teste: 20 logins errados seguidos.
- [ ] **Confirmação de senha em ação crítica** — trocar e-mail, trocar senha, apagar conta, mudar cargo de outro usuário, exportar base.
- [ ] **Revogação de sessões após troca de senha** — trocou a senha, **todas** as outras sessões caem. Teste: logue em dois browsers, troque a senha em um, recarregue o outro.
- [ ] **MFA** — disponível ao menos para contas administrativas.

**🔴 Reprovação automática:** senha em texto plano ou hash reversível · reset sem expiração de token · sessões sobrevivem à troca de senha.

---

## 3️⃣ GERENCIAMENTO DE SESSÕES

- [ ] **Onde o token mora** — cookie `HttpOnly` + `Secure` + `SameSite=Lax/Strict` é o padrão seguro. Token em `localStorage` é legível por qualquer XSS.
- [ ] **Rotação de token** — o identificador de sessão muda **no momento do login** (defesa contra fixação de sessão).
- [ ] **Refresh token** — rotativo, com detecção de reuso. Reuso de refresh já consumido = revogar a família inteira.
- [ ] **Logout local** — invalida a sessão **no servidor**, não só apaga o cookie no browser.
- [ ] **Logout global** — o usuário consegue derrubar todas as sessões de todos os dispositivos.
- [ ] **Expiração por inatividade** — sessão morre sozinha. Absoluta também (ex.: 12h), não só por inatividade.
- [ ] **Sessões simultâneas** — há limite ou ao menos visibilidade de quais dispositivos estão logados.
- [ ] **Dispositivo novo** — notificação ao titular quando há login de dispositivo/local não reconhecido.
- [ ] **Replay** — token capturado continua válido depois do logout? Teste com o token antigo após sair.

**🔴 Reprovação automática:** sessão não invalida no servidor no logout · token de sessão sem expiração.

---

## 4️⃣ INJECTION (complemento) — `A05:2025 Injection`

> As Fases 3 e 6 já cobrem SQLi e XSS. Aqui ficam os vetores que elas não alcançam.

- [ ] **NoSQL injection** — objeto onde se espera string (`{"$ne": null}`, `{"$gt": ""}`) em Mongo/Firestore.
- [ ] **Command injection** — input do usuário chegando em `exec`, `spawn`, `system`, `os.popen`. Teste: `; ls`, `| whoami`, `$(id)`.
- [ ] **Queries parametrizadas em 100% dos casos** — procure concatenação de string em SQL. Um único ponto basta.
- [ ] **RPCs e stored procedures** — função `SECURITY DEFINER` que recebe parâmetro do cliente e monta SQL dinâmico é o furo clássico do Supabase.
- [ ] **Filtros e ordenação vindos do cliente** — `?orderBy=`, `?sort=`, `?filter=` interpolados na query permitem exfiltração de coluna. Use allowlist de colunas.
- [ ] **IDs recebidos do cliente** — sempre validados contra o tipo esperado (UUID, int) **e** contra ownership.
- [ ] **Path traversal** — `../`, `..%2f`, `%2e%2e%2f` em qualquer parâmetro que vire caminho de arquivo.
- [ ] **Nome de arquivo em upload** — sanitizado, sem extensão dupla (`foto.php.jpg`), armazenado fora do webroot, servido com `Content-Disposition`.

**🔴 Reprovação automática:** concatenação de input em SQL · path traversal confirmado.

---

## 5️⃣ XSS E CONTEÚDO NÃO CONFIÁVEL (complemento)

> A Fase 6 já testa XSS refletido e armazenado. Aqui, o que sobra.

- [ ] **DOM XSS** — `innerHTML`, `outerHTML`, `document.write`, `eval`, `setTimeout(string)` recebendo dado de URL/hash.
- [ ] **Sanitização contextual** — HTML, atributo, URL e JS exigem escapes **diferentes**. Escape genérico não cobre atributo `href="javascript:"`.
- [ ] **CSV Injection (formula injection)** — célula de export começando com `=`, `+`, `-`, `@` executa fórmula no Excel. Prefixe com aspa simples.
- [ ] **Geração de PDF** — engine que renderiza HTML (Puppeteer, wkhtmltopdf) com conteúdo do usuário pode virar SSRF ou leitura de arquivo local.
- [ ] **CSP sem `unsafe-inline` e sem `unsafe-eval`** — CSP com `unsafe-inline` no `script-src` não protege contra XSS.

---

## 6️⃣ CSRF, CORS E ORIGENS (complemento)

- [ ] **Se autentica por cookie → precisa de anti-CSRF** — token sincronizado ou `SameSite=Strict`. Bearer token em header é naturalmente imune.
- [ ] **Validação de `Origin`/`Referer`** em toda mutação de estado.
- [ ] **Requisição SEM header `Origin`** — o servidor aceita? Deve rejeitar em mutação.
- [ ] **CORS por allowlist explícita** — nunca refletir o `Origin` recebido de volta no `Access-Control-Allow-Origin`.
- [ ] **`Allow-Credentials: true` + `Allow-Origin: *`** — combinação proibida (o browser bloqueia, mas a config revela descuido).
- [ ] **Métodos e headers permitidos** — só os que a API realmente usa.

---

## 7️⃣ APIs — `OWASP API Security Top 10`

- [ ] **API1 BOLA** — ver domínio 1 (IDOR).
- [ ] **API3 Exposição excessiva de dados** — o endpoint devolve o objeto inteiro do banco e o frontend filtra? `SELECT *` que retorna `password_hash`, `cpf`, `role` é vazamento mesmo que a UI não mostre.
- [ ] **API5 Autorização em nível de função** — endpoint administrativo protegido por papel, não por obscuridade da URL.
- [ ] **API6 Mass assignment** — `PATCH /users/me` com `{"role":"admin"}` no body. O servidor tem allowlist de campos editáveis?
- [ ] **API4 Consumo irrestrito de recursos** — payload sem limite de tamanho, array sem limite de itens, upload sem teto.
- [ ] **Validação de schema** — todo payload validado (Zod/Joi/Pydantic) **antes** de tocar a lógica. Campo desconhecido é rejeitado, não ignorado.
- [ ] **Paginação obrigatória** — endpoint de listagem sem `limit` permite dump da base inteira.
- [ ] **Mensagens de erro** — sem stack trace, sem nome de tabela, sem query SQL, sem versão de framework.
- [ ] **Endpoints públicos** — inventário do que é público **de propósito**. Endpoint de debug, `/health` com dados internos, docs Swagger abertas em produção.
- [ ] **Versionamento** — versão antiga da API continua no ar sem as correções da nova?

**🔴 Reprovação automática:** mass assignment de `role`/`plano` · listagem sem paginação em tabela com dado pessoal.

---

## 8️⃣ RATE LIMITING E ABUSO

- [ ] **Login** — limite por conta **e** por IP (só por IP não protege credential stuffing distribuído; só por conta permite bloquear a vítima de propósito).
- [ ] **Recuperação de senha** — limite por e-mail e por IP (evita usar seu servidor como spammer).
- [ ] **Criação de registros** — cadastro em massa, spam de formulário.
- [ ] **Exportações e relatórios** — endpoint caro sem limite é DoS de graça.
- [ ] **Limite por endpoint, não global** — teto único no gateway não protege o endpoint caro.
- [ ] **Bloqueio temporário progressivo** — 1min → 5min → 30min, e não bloqueio permanente (vira DoS contra o usuário legítimo).
- [ ] **Proteção contra automação** — CAPTCHA/turnstile nos fluxos sensíveis, ou detecção de comportamento.
- [ ] **O limite é aplicado no servidor** — throttle só no frontend não existe.

**🔴 Reprovação automática:** login sem rate limit.

---

## 9️⃣ PROTEÇÃO DE DADOS — `A04:2025 Cryptographic Failures`

- [ ] **Em trânsito** — HTTPS em tudo, HSTS ativo, redirect de HTTP→HTTPS. Chamada interna entre serviços também.
- [ ] **Em repouso** — disco/banco criptografado (a maioria dos provedores gerenciados já faz — **confirme, não presuma**).
- [ ] **Campos sensíveis** — CPF, dados de saúde, dados financeiros com criptografia adicional em coluna, quando o modelo de ameaça pedir.
- [ ] **Dados no navegador** — o que está em `localStorage`/`sessionStorage`/IndexedDB? Token, CPF, prontuário ali é exposto a qualquer XSS.
- [ ] **URLs assinadas** — arquivo em Storage servido por URL com expiração curta, não por link público permanente.
- [ ] **Logs com dado pessoal** — `console.log(user)` que despeja o objeto inteiro. Grep por log de objeto de usuário, request body e header de auth.
- [ ] **Minimização** — o sistema coleta campo que ninguém usa? Cada campo precisa de justificativa de uso.
- [ ] **Mascaramento** — CPF/cartão exibidos parcialmente (`***.456.789-**`) quando o uso não exige o valor completo.
- [ ] **Retenção e descarte** — existe prazo definido e rotina que **efetivamente apaga**? Soft delete (`deleted_at`) não é descarte.

**🔴 Reprovação automática:** dado pessoal sensível em log · Storage público com arquivo de titular · HTTP sem redirect.

---

## 🔟 SEGREDOS (complemento)

> As Fases 1 e 2 já cobrem secrets no código e no histórico git. Aqui, o resto.

- [ ] **Chave administrativa no frontend** — `service_role`, chave de admin ou secret de API em bundle client-side. Grep no build final, não só no source.
- [ ] **`.env` versionado** — inclusive `.env.example` com valor real dentro.
- [ ] **Tokens em log** — header `Authorization` logado pelo middleware de request.
- [ ] **Rotação de credenciais** — existe processo e periodicidade? Quando alguém sai do time, o que é rotacionado?
- [ ] **Secret scanning no CI** — a proteção roda a cada push, não só quando o Kerberos audita.
- [ ] **Privilégio da conta de serviço** — o token do CI/deploy tem escopo mínimo ou é admin da org?

---

## 1️⃣1️⃣ CONFIGURAÇÃO E INFRA — `A02:2025 Security Misconfiguration`

> Subiu de #5 (2021) para **#2** em 2025. Não trate como item menor.

- [ ] **Headers** — CSP, HSTS, X-Frame-Options, X-Content-Type-Options, Referrer-Policy, Permissions-Policy (já na Fase 5).
- [ ] **Modo debug desligado em produção** — `DEBUG=true`, `NODE_ENV≠production`, source maps públicos.
- [ ] **Mensagens internas expostas** — página de erro do framework com stack trace.
- [ ] **Buckets/Storage** — política de bucket público. Liste os buckets e cheque cada um; upload de usuário nunca vai para bucket público por padrão.
- [ ] **RLS** — já coberto na Fase 4. Confirme que **toda** tabela nova nasce com RLS.
- [ ] **WAF** — existe na frente da aplicação? (Cloudflare, Vercel Firewall, etc.)
- [ ] **Ambientes separados** — dev/hml/prod com **bancos e credenciais diferentes**. Dev apontando para banco de produção é falha crítica.
- [ ] **Dados reais em ambiente de dev** — base de produção copiada para dev sem anonimização é vazamento.

**🔴 Reprovação automática:** dev/hml apontando para banco de produção · bucket com dado de titular público.

---

## 1️⃣2️⃣ DEPENDÊNCIAS — `A03:2025 Software Supply Chain Failures`

> Categoria **nova e ampliada** em 2025 — agora cobre todo o ecossistema, não só "componente desatualizado".

- [ ] `npm audit` / equivalente sem CRITICAL (já na Fase 2).
- [ ] **Pacotes abandonados** — última publicação há anos, mantenedor único, repositório arquivado.
- [ ] **Lockfile commitado** e respeitado no CI (`npm ci`, não `npm install`).
- [ ] **Integridade do build** — o que roda em produção veio do commit que você acha que veio? Build reproduzível, artefato assinado.
- [ ] **Atualização automatizada** — Dependabot/Renovate ativo.
- [ ] **Dependência comprometida** — scripts `postinstall` suspeitos, registry não-oficial (já na Fase 2).
- [ ] **Ações de CI de terceiros** — GitHub Action pinada por SHA, não por tag móvel (`@v3` pode ser reescrita).

---

## 1️⃣3️⃣ LOGS, AUDITORIA E MONITORAMENTO — `A09:2025 Security Logging & Alerting Failures`

> Em 2025 o nome mudou para enfatizar **alerting**: logar sem alertar não conta.

- [ ] **Eventos de auth logados** — login, falha de login, logout, troca de senha, troca de e-mail, MFA.
- [ ] **Ações administrativas logadas** — quem mudou o cargo de quem, quem apagou o quê, quem exportou a base.
- [ ] **Conteúdo do log** — quem (user id), o quê, quando (timestamp com timezone), de onde (IP), resultado.
- [ ] **Log imutável** — append-only. Se o admin da aplicação consegue editar/apagar o log de auditoria, ele não é auditoria.
- [ ] **Alertas ativos** — alguém é **notificado** em comportamento suspeito. Log que ninguém lê é arquivo morto.
- [ ] **Sem senha/token no log** — grep no que é logado.
- [ ] **Retenção do log** definida (e compatível com o item 16).

**🔴 Reprovação automática:** log de auditoria editável pela própria aplicação · senha/token em log.

---

## 1️⃣4️⃣ REGRAS DE NEGÓCIO — `A06:2025 Insecure Design`

> Nenhuma ferramenta automática pega isso. É leitura de fluxo com cabeça de fraudador.

- [ ] **Ordem das operações** — dá para pular etapa? (confirmar pedido sem pagar; aprovar sem revisar; agendar sem cadastro)
- [ ] **Repetição de solicitação (replay)** — enviar a mesma requisição 2x gera efeito duplicado? Operação financeira precisa de **chave de idempotência**.
- [ ] **Concorrência (race condition)** — duas requisições simultâneas conseguem gastar o mesmo saldo/cupom/vaga duas vezes? Exige lock ou constraint no banco, não `if` na aplicação.
- [ ] **Dupla aprovação** — onde o processo exige duas pessoas, o sistema impede que seja a mesma?
- [ ] **Alteração de cargo** — quem pode promover quem? Alguém se autopromove? Último admin consegue se rebaixar e travar a conta?
- [ ] **Limites de negócio** — desconto negativo, quantidade negativa, data no passado, valor acima do teto.

---

## 1️⃣5️⃣ TRATAMENTO DE ERROS — `A10:2025 Mishandling of Exceptional Conditions`

> **Categoria nova em 2025**, com 24 CWEs. Trata exatamente do que segue.

- [ ] **Fail secure, nunca fail open** — se o serviço de autorização cair, o sistema **nega**. `try { checkAuth() } catch { /* segue */ }` é a falha canônica.
- [ ] **Transação parcial** — operação de múltiplos passos que falha no meio deixa dado inconsistente? (cobrou e não entregou)
- [ ] **Rollback de banco** — a transação é atômica de verdade (`BEGIN/COMMIT`), não uma sequência de writes soltos.
- [ ] **Indisponibilidade de terceiro** — gateway de pagamento/WhatsApp/e-mail fora do ar: o sistema degrada com segurança ou libera acesso?
- [ ] **Exceção que libera acesso** — `catch` genérico que retorna `true`, ou middleware que deixa passar quando o token não parseia.
- [ ] **Timeout** — chamada externa sem timeout trava worker e vira DoS.

**🔴 Reprovação automática:** fail open em verificação de autenticação ou autorização.

---

## 1️⃣6️⃣ LGPD E PRIVACIDADE

> **Lei 13.709/2018.** Não é opcional para nenhum sistema brasileiro que trate dado pessoal.
>
> ⚠️ **Divisão de responsabilidade:** finalidade, base legal e retenção são decisões de
> **especificação** (Shiva, na Descoberta), não de auditoria. O Kerberos verifica se foram
> tomadas e se o código as respeita. Se nunca foram definidas, o achado é **de processo**:
> o Kerberos reporta e o caso volta para a Shiva.

- [ ] **Finalidade (art. 6º, I)** — cada dado coletado tem finalidade declarada e específica.
- [ ] **Necessidade / minimização (art. 6º, III)** — coleta limitada ao mínimo para a finalidade. Campo "por via das dúvidas" é violação.
- [ ] **Base legal (art. 7º)** — cada tratamento tem uma: consentimento, execução de contrato, obrigação legal, legítimo interesse, tutela da saúde…
- [ ] **Transparência (art. 9º)** — política de privacidade acessível, em linguagem clara, dizendo o que é coletado, por quê e com quem é compartilhado.
- [ ] **Consentimento** — quando essa é a base: livre, informado, específico, **registrado** (data, hora, versão do texto aceito) e **revogável** com a mesma facilidade.
- [ ] **Direitos do titular (art. 18)** — o sistema permite: confirmação de tratamento, **acesso**, correção, anonimização/eliminação, **portabilidade** (formato legível por máquina), revogação. Existe canal e prazo?
- [ ] **Retenção** — prazo definido por tipo de dado + rotina de descarte que **efetivamente apaga**.
- [ ] **Resposta a incidente (art. 48)** — existe plano? Comunicação à ANPD e aos titulares em prazo razoável.
- [ ] **Dados de saúde (art. 11 — dado sensível)** — exigem base legal específica, controle de acesso mais rígido, log de **todo acesso** ao prontuário, e criptografia. **Isto se aplica a qualquer sistema de clínica.**
- [ ] **Operadores e subprocessadores** — lista de terceiros que tratam dados (Supabase, Vercel, OpenAI, Evolution, gateway). Há contrato/DPA? Onde os dados ficam hospedados? Transferência internacional tem salvaguarda?
- [ ] **⚠️ Dado pessoal enviado para LLM** — mandar prontuário/CPF para API de IA é compartilhamento com operador estrangeiro. Precisa de base legal, DPA e ciência do titular. **Falha frequente e invisível em projeto com IA.**
- [ ] **Encarregado (DPO)** — indicado e com contato publicado.

**🔴 Reprovação automática:** dado de saúde sem controle de acesso e log · dado pessoal enviado a terceiro sem base legal.

---

## 1️⃣7️⃣ TESTES OFENSIVOS

- [ ] **SAST** — Semgrep no CI (já na Fase 3), não só sob demanda.
- [ ] **DAST** — OWASP ZAP (`zap-baseline.py -t <url>`) ou Nuclei contra a aplicação **rodando** (Fase 7 cobre parte).
- [ ] **Fuzzing** — `ffuf` para descoberta de endpoint não documentado; fuzz de parâmetro com valores extremos (negativo, gigante, unicode, null byte).
- [ ] **Teste automatizado de autorização** — o mais valioso e o mais raro: uma suíte que, para cada endpoint, tenta acessar como (a) anônimo, (b) usuário de outro tenant, (c) usuário de papel inferior. Roda no CI e falha o build.
- [ ] **Teste manual** de IDOR, XSS, injection e broken auth (Fase 6).
- [ ] **Regressão de segurança** — toda vulnerabilidade corrigida ganhou um teste que impede o retorno?

---

## 📤 SEÇÕES OBRIGATÓRIAS DO RELATÓRIO FINAL

Quando a auditoria usar este checklist, o relatório precisa das 7 seções:

1. **Resumo executivo** — veredicto, contagem por status, os 3 riscos que mais importam ao negócio.
2. **Achados por severidade** — 🔴 crítico / 🟠 alto / 🟡 médio / 🟢 baixo.
3. **Cenário real de exploração** — por achado: quem ataca, o que precisa ter, passo a passo, o que ganha. Sem cenário plausível, o achado é teórico e desce de severidade.
4. **Evidência técnica** — arquivo:linha, policy, header, screenshot ou output.
5. **Recomendação** — correção concreta, endereçada ao Atlas.
6. **Teste que comprova a correção** — o comando/teste específico que, ao passar, prova que fechou. Não vale "re-testar".
7. **⬜ Riscos que permaneceram sem verificação** — tudo que ficou em NÃO FOI POSSÍVEL VERIFICAR, com o motivo e o que seria preciso para verificar.

> **A seção 7 é obrigatória mesmo quando vazia.** Auditoria que omite o que não conseguiu
> olhar transmite uma sensação falsa de cobertura — e é assim que um sistema é aprovado
> com um furo que ninguém chegou a procurar.
