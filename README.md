# 🎬 Formbricks — Estacionkusmedios
## Form Builder Self-Hosted en Fly.io

### Requisitos
- Fly CLI instalado: `curl -L https://fly.io/install.sh | sh`
- Autenticado: `fly auth login`

### Setup inicial
```bash
# Clonar el repo
git clone https://github.com/luisitoys12/formbricks-kusmedios-fly.git
cd formbricks-kusmedios-fly

# Copiar variables de entorno
cp .env.example .env
# Edita .env con tus claves reales (openssl rand -hex 32)

# Deploy en un solo paso
./deploy.sh
```

### Después del deploy
1. Abre https://formbricks-kusmedios.fly.dev
2. Crea tu cuenta admin (primer signup = admin)
3. ¡Empieza a crear formularios con tu branding!

### Dominio personalizado
```bash
fly certs create forms.estacionkusmedios.org --app formbricks-kusmedios
```
Agrega CNAME en tu DNS:
```
forms.estacionkusmedios.org → formbricks-kusmedios.fly.dev
```

### Comandos útiles
```bash
fly logs --app formbricks-kusmedios        # Ver logs
fly ssh console --app formbricks-kusmedios # SSH
fly deploy --app formbricks-kusmedios      # Actualizar
fly status --app formbricks-kusmedios      # Estado
```

### Conectar MCP vía Composio
1. Composio → Add Toolkit → Formbricks
2. URL: `https://formbricks-kusmedios.fly.dev`
3. API Key: Settings → API Keys en tu instancia

### Stack
| Recurso | Spec | Costo est. |
|---|---|---|
| VM | shared-cpu-1x, 1GB RAM | ~$5-7/mes |
| Volume | 5GB uploads | ~$0.50/mes |
| Postgres | shared-cpu-1x, 5GB | ~$5/mes |
| **Total** | | **~$10-12/mes** |

### Seguridad
- `.env` está en `.gitignore` — **nunca** subas tus claves reales
- Usa `.env.example` como plantilla
- Genera claves con: `openssl rand -hex 32`
