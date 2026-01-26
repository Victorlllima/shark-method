# 🐳 Receita: Setup Supabase Local (Docker) - Custo Zero

Este guia é para você que quer desenvolver sem custos de infraestrutura, rodando o banco de dados do Supabase diretamente no seu computador.

---

## 🛠️ PASO 1: INSTALAR DOCKER (O Motor)

O Supabase precisa do Docker para rodar na sua máquina.

### **No Windows:**
1.  Baixe o [Docker Desktop para Windows](https://www.docker.com/products/docker-desktop/).
2.  Instale seguindo o assistente. 
3.  **Importante:** Se o instalador pedir para ativar o **WSL 2**, aceite.
4.  Reinicie o computador após a instalação.
5.  Abra o Docker Desktop e espere o ícone da baleia ficar parado (verde).

### **No Mac:**
1.  Baixe o [Docker Desktop para Mac](https://www.docker.com/products/docker-desktop/) (escolha a versão correta: Apple Chip ou Intel).
2.  Arraste para a pasta Applications.
3.  Abra o Docker e aceite os termos.

---

## 🚀 PASSO 2: INICIALIZAR SUPABASE NO PROJETO

Com o Docker aberto, Atlas cuidará da inicialização.

### **Comandos que o Atlas executará:**
```bash
# Iniciar o Supabase localmente
npx supabase init
npx supabase start
```

---

## 💡 POR QUE USAR LOCAL?

1.  **Custo Zero:** Você não gasta nada dos limites do plano gratuito do Supabase.
2.  **Branches Infinitas:** Você pode criar quantas "versões" do banco quiser sem pagar por *Database Branches* extras.
3.  **Velocidade:** O acesso ao banco é instantâneo, sem latência de rede.
4.  **Desenvolvimento Offline:** Você pode trabalhar sem internet.

---

## ⚠️ NOTA SOBRE RECURSOS
O Docker consome memória RAM. Se o seu computador estiver lento, você pode fechar o Docker quando não estiver programando.

---

**Última atualização:** Método S.H.A.R.K. v2.1
