# 06 — DynamoDB: persistência e idempotência

**Fontes originais:**

- `docs/entrega/evidencias/eks-20261101/e2e.log`, linhas 1, 7–8.
- `docs/entrega/evidencias/eks-20261101/e2e-service-logs.txt`, linhas 9–16.

**Recorte sanitizado — evidência histórica de 01/11/2026:**

```text
atUtc: 2026-11-01T05:37:23.721647+00:00
PASS evaluation -> SQS real -> analytics -> DynamoDB real: 6 eventos
PASS idempotencia: 2 mensagens SQS distintas com o mesmo event_id => 1 item DynamoDB; fila drenada
2026-11-01 05:38:32,737 - INFO - Event processed: stored
2026-11-01 05:38:32,851 - INFO - Event processed: duplicate
```

IDs de execução, event_id, MessageIds, chaves e conteúdo dos eventos foram omitidos. Os dois últimos registros mostram o processamento de um evento e a detecção de duplicata.
