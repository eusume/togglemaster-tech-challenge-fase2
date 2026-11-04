# 02 — NGINX Ingress: health checks

**Momento registrado:** `2026-11-01T05:37:23.721647+00:00`
**Fonte original:** `docs/entrega/evidencias/eks-20261101/e2e.log`, linhas 1–2.

**Recorte sanitizado — evidência histórica, não teste ao vivo:**

```text
atUtc: 2026-11-01T05:37:23.721647+00:00
PASS NLB -> NGINX -> 5 servicos /health HTTP 200 (roteamento por Host)
```

O registro confirma o resultado agregado das cinco rotas. O log não identifica individualmente os hosts ou os caminhos de cada serviço; nenhum endpoint foi reproduzido aqui.
