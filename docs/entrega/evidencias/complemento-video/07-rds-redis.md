# 07 — RDS PostgreSQL e Redis

**Fontes originais:**

- `docs/entrega/evidencias/eks-20261101/aws-infra.txt`, linhas 1, 6–11.
- `docs/entrega/evidencias/eks-20261101/e2e-service-logs.txt`, linhas 2–3.

**Recorte sanitizado — inventário registrado em 01/11/2026:**

```text
atUtc: 2026-11-01T05:39:54.7572575Z
RDS PostgreSQL 16.15:
  togglemaster-auth      available
  togglemaster-flag      available
  togglemaster-targeting available
ElastiCache Redis: togglemaster-redis available
```

**Cache registrado durante a avaliação:**

```text
2026/11/01 05:38:19 Cache MISS para flag [nome omitido]
2026/11/01 05:38:19 Cache HIT para flag [nome omitido]
```

Endpoints, identificadores de recursos e nomes de flags foram omitidos. As linhas de cache e o inventário vieram de registros separados.
