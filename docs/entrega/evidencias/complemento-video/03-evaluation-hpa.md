# 03 — Evaluation HPA: CPU e carga

**Fontes originais:**

- `docs/entrega/evidencias/eks-20261101/hpa-watch.log`, linha 3.
- `docs/entrega/evidencias/eks-20261101/load-3.log`, linhas 2–4.
- `docs/entrega/evidencias/eks-20261101/hpa-watch-3.log`, linha 3.

**Recorte sanitizado — observações históricas de 01/11/2026:**

```text
05:39:10 — evaluation-service: CPU 1%/70%; mínimo 1, máximo 2, réplicas 1.
05:57:21Z — carga: alvo 120 req/s por 420 s.
Resultado da carga: 49893 respostas OK; 0 falhas.
06:04:36 — evaluation-service: CPU 70%/70%; mínimo 1, máximo 2, réplicas 2.
```

Os registros mostram o HPA por CPU e a passagem de uma para duas réplicas durante a janela histórica de carga. Os identificadores de execução, flag e Load Balancer foram removidos.
