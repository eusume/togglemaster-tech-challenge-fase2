# 01 — Kubernetes: nós, Deployments e Pods

**Momento registrado:** `2026-11-01T06:04:54.7821747Z`
**Fonte original:** `docs/entrega/evidencias/eks-20261101/cluster-state.txt`, linhas 1, 3–4, 6–10 e 20–26.

**Recorte sanitizado — evidência histórica, não estado atual:**

```text
atUtc: 2026-11-01T06:04:54.7821747Z
Nodes: 2 Ready (Kubernetes v1.37.1)
Deployments:
  analytics-service     2/2
  auth-service          1/1
  evaluation-service    2/2
  flag-service          1/1
  targeting-service     1/1
Application Pods: 7/7 Running
```

Os cinco Deployments estavam prontos. Os dois HPA-managed deployments tinham duas réplicas cada; os outros três, uma cada. Nomes de nós, IPs, IDs de Pods, conta AWS e URLs de imagem foram omitidos.
