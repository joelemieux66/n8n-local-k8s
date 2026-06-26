#!/usr/bin/env bash
set -euo pipefail

NAMESPACE="${NAMESPACE:-n8n}"
N8N_HOST="${N8N_HOST:-n8n.local}"
GRAFANA_HOST="${GRAFANA_HOST:-grafana.local}"
SECRET_NAME="${SECRET_NAME:-n8n-tls}"
CERT_DIR="${CERT_DIR:-$(cd "$(dirname "$0")/.." && pwd)/certs}"

command -v mkcert >/dev/null || { echo "mkcert is required: brew install mkcert"; exit 1; }
command -v kubectl >/dev/null || { echo "kubectl is required"; exit 1; }

mkdir -p "$CERT_DIR"
cd "$CERT_DIR"

echo "Installing mkcert local CA (may prompt for your password)..."
mkcert -install

echo "Generating certificate for ${N8N_HOST} and ${GRAFANA_HOST}..."
mkcert "$N8N_HOST" "$GRAFANA_HOST"

CERT_FILE="${N8N_HOST}+1.pem"
KEY_FILE="${N8N_HOST}+1-key.pem"

kubectl create namespace "$NAMESPACE" --dry-run=client -o yaml | kubectl apply -f -

kubectl -n "$NAMESPACE" create secret tls "$SECRET_NAME" \
  --cert="$CERT_FILE" \
  --key="$KEY_FILE" \
  --dry-run=client -o yaml | kubectl apply -f -

echo "TLS secret ${SECRET_NAME} is ready in namespace ${NAMESPACE}."
