# Resumo público das evidências EKS — 01/11/2026

Este resumo foi preparado a partir dos registros locais da execução de 01/11/2026, aproximadamente entre 05:30 e 06:20 UTC. Não é uma consulta ao estado atual do cluster. Os registros brutos continuam preservados localmente e não fazem parte deste resumo.

## Resultados documentados

- EKS Kubernetes 1.37 com dois nós Ready e cinco microsserviços disponíveis.
- Cinco Services internos e um NGINX Ingress exposto por Load Balancer; os cinco health checks passaram por roteamento baseado em Host.
- Auth, flag e targeting gravaram/leram em três instâncias PostgreSQL independentes.
- Evaluation confirmou decisões PERCENTAGE 100 (`true`), PERCENTAGE 0 (`false`), kill switch e flag inexistente (`false`); os logs registraram Cache MISS e HIT no Redis.
- Fluxo real evaluation → SQS Standard → analytics → DynamoDB concluiu com seis eventos correlacionados. Duas mensagens com a mesma identidade lógica foram reduzidas a um único item persistido.
- Um envio manual à fila foi posteriormente localizado na tabela DynamoDB.
- Sob carga HTTP com alvo de 120 req/s, foram registradas 49.893 respostas e zero falhas. O HPA de evaluation escalou de uma para duas réplicas; analytics também escalou durante processamento de eventos. O scale-down foi observado depois que a carga cessou.
- PostgreSQL, Redis, SQS, DynamoDB, ECR e o NLB foram verificados como dependências utilizadas pela release naquele período.

## Dificuldade de operação EKS registrada

Ao fim da sessão AWS Academy, instâncias substitutas do Auto Scaling foram iniciadas durante uma janela de restrição organizacional. O bootstrap `nodeadm` falhou ao consultar metadados EC2 e os nós não se registraram. Na sessão ativa seguinte, a reciclagem controlada do node group de zero para dois nós fez os novos nós chegarem a Ready; CoreDNS e Metrics Server também voltaram. O diagnóstico detalhado permanece local para evitar publicar identificadores operacionais.

## Limites e rastreabilidade

- A data da coleta é parte da evidência; não afirmar que o ambiente continua ativo.
- Nenhum número de conta, endereço, IP, ARN, credencial, Secret, MessageId, `event_id` ou payload é reproduzido aqui.
- Os fatos podem ser conferidos nos arquivos locais `e2e.log`, `e2e-service-logs.txt`, `aws-infra.txt`, `cluster-state.txt`, `sqs-manual.txt`, `load-3.log` e `hpa-watch-*.log` da pasta `eks-20261101`.
- Este resumo não substitui os registros originais nem atesta uma repetição posterior da carga.
