const express = require('express');
const bodyParser = require('body-parser');
const open = require('open');
const fs = require('fs');
const path = require('path');
const dotenv = require('dotenv');

// Configuração
const app = express();
const PORT = 3008;
const ROOT_DIR = path.join(__dirname, '..'); // Raiz do projeto (shark-method)

app.use(bodyParser.json());
app.use(express.static(path.join(ROOT_DIR, 'docs'))); // Servir arquivos estáticos (HTML, imagens)
// Servir imagens da raiz também se necessário
app.use('/images', express.static(path.join(ROOT_DIR, 'images')));

// Rota Principal
app.get('/', (req, res) => {
    res.sendFile(path.join(ROOT_DIR, 'docs', 'wizard-mockup.html'));
});

// Endpoint: Validar GitHub (Real)
app.post('/api/validate-github', async (req, res) => {
    const { token } = req.body;
    try {
        const response = await fetch('https://api.github.com/user', {
            headers: {
                'Authorization': `token ${token}`,
                'User-Agent': 'Shark-Method-Wizard'
            }
        });

        if (response.ok) {
            const data = await response.json();
            res.json({ valid: true, user: data.login });
        } else {
            res.json({ valid: false });
        }
    } catch (error) {
        res.json({ valid: false, error: error.message });
    }
});

// Endpoint: Validar Supabase (Global Token)
app.post('/api/validate-supabase', async (req, res) => {
    const { token } = req.body; // Agora esperamos apenas o Token
    try {
        // Validamos listando os projetos na API de Management
        const response = await fetch('https://api.supabase.com/v1/projects', {
            headers: {
                'Authorization': `Bearer ${token}`,
                'Content-Type': 'application/json'
            }
        });

        if (response.ok) {
            res.json({ valid: true });
        } else {
            res.json({ valid: false });
        }
    } catch (error) {
        res.json({ valid: false, error: error.message });
    }
});

const { spawn } = require('child_process');

// Endpoint: Salvar Configurações
app.post('/api/save-config', (req, res) => {
    try {
        const { githubPat, supabaseAccessToken, vercelToken, firecrawlKey } = req.body;

        // 1. Criar/Atualizar .env.local
        let envContent = '';
        if (fs.existsSync(path.join(ROOT_DIR, '.env.local'))) {
            envContent = fs.readFileSync(path.join(ROOT_DIR, '.env.local'), 'utf8');
        }

        // Função auxiliar para atualizar chaves
        const updateEnv = (key, value) => {
            const regex = new RegExp(`^${key}=.*`, 'm');
            if (envContent.match(regex)) {
                envContent = envContent.replace(regex, `${key}=${value}`);
            } else {
                envContent += `\n${key}=${value}`;
            }
        };

        if (githubPat) updateEnv('GITHUB_TOKEN', githubPat);
        if (supabaseAccessToken) updateEnv('SUPABASE_ACCESS_TOKEN', supabaseAccessToken);
        if (vercelToken) updateEnv('VERCEL_TOKEN', vercelToken);
        if (firecrawlKey) updateEnv('FIRECRAWL_KEY', firecrawlKey);

        fs.writeFileSync(path.join(ROOT_DIR, '.env.local'), envContent.trim());

        // 3. Propagar configuracao para o Template (shark-cockpit) SE existir
        const cockpitDir = path.join(ROOT_DIR, 'shark-cockpit');
        let cockpitStarted = false;

        if (fs.existsSync(cockpitDir)) {
            try {
                fs.copyFileSync(path.join(ROOT_DIR, '.env.local'), path.join(cockpitDir, '.env.local'));
                console.log('✅ Configuração propagada para o shark-cockpit com sucesso!');

                // 4. Iniciar o servidor Next.js automaticamente
                console.log('🚀 [HADES]: Iniciando propulsores do Cockpit (npm run dev)...');
                const npmCmd = process.platform === 'win32' ? 'npm.cmd' : 'npm';

                // Spawn do processo em background (mas herdando stdio para logs aparecerem no terminal do Wizard)
                const cockpitProcess = spawn(npmCmd, ['run', 'dev'], {
                    cwd: cockpitDir,
                    stdio: 'inherit',
                    shell: true
                });

                cockpitStarted = true;

            } catch (err) {
                console.error('⚠️ Aviso: Não foi possível configurar automaticamente o shark-cockpit:', err.message);
            }
        }

        console.log('✅ Configurações salvas e ambiente iniciado!');
        res.json({
            success: true,
            message: 'Configurações salvas. Cockpit iniciando...',
            cockpitUrl: 'http://localhost:3000',
            started: cockpitStarted
        });

    } catch (error) {
        console.error('Erro ao salvar:', error);
        res.status(500).json({ success: false, message: 'Erro ao salvar configurações.' });
    }
});

// Iniciar Servidor
app.listen(PORT, async () => {
    console.log(`\n🟣 [SHIVA]: Wizard de Setup do Protocolo S.H.A.R.K. iniciado!`);
    console.log(`🤖 [HADES]: Servidor de configuração rodando na porta ${PORT}.`);
    console.log(`\n🔗 Abra este link no seu navegador para começar:\n👉 http://localhost:${PORT}\n`);
});
