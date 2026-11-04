# Roteiro — complemento visual FIAP

**Duração estimada:** aproximadamente 4 minutos e 25 segundos.
**Importante:** todos os trechos abaixo são registros históricos de 01/11/2026. Não execute comandos nem apresente estes arquivos como estado atual do ambiente.

## Preparação

No VS Code, abra a pasta `ENTREGA-FINAL-FIAP/COMPLEMENTO-VIDEO`. Use a visualização Markdown, aumente um pouco o zoom e mantenha só o arquivo da evidência em foco. Em cada etapa, destaque apenas o bloco “Recorte sanitizado”.

## 1. Kubernetes — 35 segundos

- **Abrir:** `01-kubernetes.md`
- **Destacar:** linhas 9–17.
- **Explicar:** “Esse registro de 1º de novembro mostra os dois nós prontos e os cinco Deployments disponíveis. Evaluation e analytics estavam com duas réplicas; os outros três, com uma. Por isso aparecem sete Pods de aplicação no total. É um snapshot histórico.”

## 2. NGINX Ingress — 30 segundos

- **Abrir:** `02-nginx-ingress.md`
- **Destacar:** linhas 9–10.
- **Explicar:** “O teste passou pelo Load Balancer e pelo NGINX e registrou HTTP 200 para as cinco rotas de health check, usando roteamento por Host. O arquivo preservado traz o resultado agregado, não a lista de cada host.”

## 3. Evaluation HPA — 40 segundos

- **Abrir:** `03-evaluation-hpa.md`
- **Destacar:** linhas 12–15.
- **Explicar:** “Aqui dá para comparar o estado inicial com a observação após a carga: o HPA usa CPU, com alvo de 70%, e evaluation foi de uma para duas réplicas. A execução de carga registrada teve alvo de 120 requisições por segundo por sete minutos, sem falhas reportadas.”

## 4. Analytics HPA — 35 segundos

- **Abrir:** `04-analytics-hpa.md`
- **Destacar:** linhas 12–15.
- **Explicar:** “Analytics também escalou de uma para duas réplicas quando a CPU ficou acima do alvo de 60%. É a política compatível com o ambiente usado. CPU ajuda a reagir ao processamento, mas não é uma medida direta do tamanho da fila.”

## 5. SQS — 30 segundos

- **Abrir:** `05-sqs-envio-manual.md`
- **Destacar:** linhas 9–11.
- **Explicar:** “O registro mostra um envio manual para a fila e uma consulta posterior que encontrou o evento processado. O corpo e os identificadores foram retirados para não exibir dados do evento.”

## 6. DynamoDB e idempotência — 35 segundos

- **Abrir:** `06-dynamodb-idempotencia.md`
- **Destacar:** linhas 11–15.
- **Explicar:** “Este teste registrou o fluxo de evaluation até SQS, analytics e DynamoDB. Duas mensagens com a mesma identidade lógica produziram um único item; o log mostra um armazenamento e, depois, a duplicata reconhecida.”

## 7. RDS e Redis — 35 segundos

- **Abrir:** `07-rds-redis.md`
- **Destacar:** linhas 11–23.
- **Explicar:** “O inventário histórico lista três bancos PostgreSQL separados e o Redis. No log da avaliação aparecem Cache MISS e depois Cache HIT para a mesma flag, mostrando a leitura inicial e o uso posterior do cache.”

## Encerramento — 25 segundos

Volte a `01-kubernetes.md` ou deixe a pasta de evidências visível.

**Explicar:** “Esses arquivos são recortes sanitizados de evidências coletadas em 1º de novembro. Eles não mostram o estado atual da AWS nem substituem uma demonstração ao vivo. Removi endpoints, IPs, identificadores e payloads.”

## Limites das evidências preservadas

- **Ingress:** o teste registrado confirma as cinco rotas por um resultado agregado; não preserva hostnames nem um resultado separado por rota.
- **SQS:** o envio manual registra MessageId e consulta posterior no DynamoDB; mensagem e identificadores foram omitidos.
- **Evaluation/analytics HPA:** as amostras de CPU/replicas e o resumo da carga vêm de arquivos de observação distintos. O material mantém cada timestamp original e não inventa uma saída única combinando-os.
- **Estado atual:** nenhuma evidência aqui comprova disponibilidade posterior a 01/11/2026.
