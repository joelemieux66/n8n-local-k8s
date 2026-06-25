# n8n Enterprise Kubernetes Lab

Features:

- Multi-main n8n deployment
- Queue mode with Redis
- PostgreSQL backend
- Worker scaling
- KEDA autoscaling
- Grafana monitoring
- Prometheus metrics
- Loki logging
- Tempo tracing
- OpenTelemetry
- Cloudflare Tunnel
- Ollama self-hosted model runtime

Architecture:

This repository provides a Kubernetes-only lab environment for self-hosting n8n Enterprise with observability, autoscaling, and an in-cluster Ollama model runtime. The Helm chart at the repository root is the source of truth.

## Setup

1. Create the namespace:
   ```bash
   kubectl create namespace n8n
   ```
2. Create the required secrets:
   ```bash
   kubectl -n n8n create secret generic n8n-secrets \
     --from-literal=POSTGRES_PASSWORD='replace-me' \
     --from-literal=N8N_ENCRYPTION_KEY='replace-me'

   kubectl -n n8n create secret generic cloudflared-token \
     --from-literal=TUNNEL_TOKEN='replace-me'
   ```
3. Copy the local values template and update it for your cluster:
   ```bash
   cp values.local.example.yaml values.local.yaml
   ```
4. Review `values.yaml` and `values.local.yaml`, especially `n8n.publicUrl` and `ollama`.
5. Install the chart:
   ```bash
   helm upgrade --install n8n-local . --namespace n8n -f values.local.yaml
   ```

## Notes

- KEDA must be installed in the cluster before the `ScaledObject` can work.
- Cloudflared requires a valid tunnel token in the `cloudflared-token` secret.
- Ollama is included as an in-cluster self-hosted model runtime.
- Commit `values.yaml` and `values.local.example.yaml`; keep `values.local.yaml` private.
- To create secrets through Helm for a local-only lab, set `secrets.create=true` and provide secret values with `--set` or a private values file.
- After cleanup, initialize the repository and commit:
  ```bash
  git init
  git add .
  git commit -m "Initial Kubernetes chart"
  ```
