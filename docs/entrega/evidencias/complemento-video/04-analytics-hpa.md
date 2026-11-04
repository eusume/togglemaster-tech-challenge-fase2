# 04 — Analytics HPA: CPU e réplicas

**Fontes originais:**

- `docs/entrega/evidencias/eks-20261101/hpa-watch.log`, linha 2.
- `docs/entrega/evidencias/eks-20261101/load-3.log`, linhas 2–4.
- `docs/entrega/evidencias/eks-20261101/hpa-watch-3.log`, linha 2.

**Recorte sanitizado — observações históricas de 01/11/2026:**

```text
05:39:10 — analytics-service: CPU 1%/60%; mínimo 1, máximo 2, réplicas 1.
05:57:21Z — carga: alvo 120 req/s por 420 s.
Resultado da carga: 49893 respostas OK; 0 falhas.
06:04:36 — analytics-service: CPU 285%/60%; mínimo 1, máximo 2, réplicas 2.
```

O HPA de analytics escalou com base em CPU. Esse indicador não mede diretamente a profundidade da fila SQS. Os identificadores de execução, flag e Load Balancer foram removidos.
