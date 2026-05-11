#!/bin/bash
set -e

APP_NAME="formbricks-kusmedios"
ORG="estacionkus-medios"
REGION="dfw"

echo "🚀 Desplegando Formbricks en Fly.io para Estacionkusmedios..."

# 1. Crear la app
echo "📦 Creando app..."
fly apps create $APP_NAME --org $ORG 2>/dev/null || echo "App ya existe, continuando..."

# 2. Crear volumen para uploads
echo "💾 Creando volumen para uploads..."
fly volumes create formbricks_uploads \
  --app $APP_NAME \
  --region $REGION \
  --size 5 2>/dev/null || echo "Volumen ya existe, continuando..."

# 3. Crear base de datos Postgres
echo "🐘 Creando base de datos PostgreSQL..."
fly postgres create \
  --name "${APP_NAME}-db" \
  --org $ORG \
  --region $REGION \
  --vm-size shared-cpu-1x \
  --volume-size 5 \
  --initial-cluster-size 1 2>/dev/null || echo "DB ya existe, continuando..."

# 4. Adjuntar Postgres a la app (genera DATABASE_URL automáticamente)
echo "🔗 Adjuntando Postgres..."
fly postgres attach "${APP_NAME}-db" --app $APP_NAME 2>/dev/null || echo "Ya adjuntado, continuando..."

# 5. Cargar secrets desde .env
echo "🔐 Cargando secrets..."
source .env

fly secrets set \
  NEXTAUTH_SECRET="$NEXTAUTH_SECRET" \
  ENCRYPTION_KEY="$ENCRYPTION_KEY" \
  CRON_SECRET="$CRON_SECRET" \
  WEBAPP_URL="$WEBAPP_URL" \
  NEXTAUTH_URL="$NEXTAUTH_URL" \
  EMAIL_VERIFICATION_DISABLED="1" \
  PASSWORD_RESET_DISABLED="1" \
  --app $APP_NAME

# 6. Deploy
echo "🛸 Desplegando..."
fly deploy --app $APP_NAME --ha=false

echo ""
echo "✅ ¡Formbricks desplegado!"
echo "🌐 URL: https://${APP_NAME}.fly.dev"
echo "📊 Dashboard: https://${APP_NAME}.fly.dev/auth/signup (primer usuario = admin)"
