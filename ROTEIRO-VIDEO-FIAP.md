# Roteiro de vídeo — ToggleMaster | FIAP Tech Challenge Fase 2

**Duração-alvo:** 15 minutos. **Limite oficial:** 20 minutos, conforme o PDF do desafio.
**Formato:** demonstração de tela com narração própria; use estes tópicos como lembretes, não como texto para leitura.

## Antes de gravar

- Hoje, o Compose foi conferido com nove containers `running/healthy`.
- A sessão AWS não está autenticada neste workspace. Não apresentar o EKS como estado ao vivo: as evidências cloud disponíveis são de **01/11/2026 UTC**.
- Se não houver AWS ativa durante a gravação, mostrar os arquivos originais e dizer a data. Não reproduzir cargas, envios SQS ou mudanças de infraestrutura para simular o passado.
- A auditoria aponta o PDF original em `%USERPROFILE%\Downloads\POSTECH - Tech Challenge - Fase 2.pdf`; ele limita o vídeo a 20 minutos.
- Deixe à mão este roteiro, [DEMO-FIAP.ps1](./DEMO-FIAP.ps1), [README público](./README-PUBLICO-FIAP.md) e o [resumo público EKS de 01/11](./docs/entrega/evidencias/RESUMO-PUBLICO-EKS-20261101.md). Não deixe logs brutos abertos na gravação.

## Sequência sugerida (15 minutos)

| Tempo | Tela e demonstração | O que comprova / gancho para explicar |
|---|---|---|
| 0:00–0:45 | Terminal na raiz do workspace e README público | Nome do projeto, objetivo (feature flags) e separar fatos ao vivo dos registros datados. |
| 0:45–2:00 | Visão de arquitetura no README público | Percurso da decisão: auth protege flag/targeting; evaluation consulta Redis e os serviços; evento vai por SQS ao analytics e termina no DynamoDB. |
| 2:00–3:15 | PowerShell: estrutura e `docker compose ps` | Cinco repositórios de serviço; baseline local com nove containers saudáveis. Explicar que dois PostgreSQL do Compose não são as três instâncias RDS. |
| 3:15–4:45 | Saída filtrada do script ou resumo público | Deployments, Services, ConfigMaps e HPAs. Sem AWS ativa, apontar o timestamp de 01/11; não chamar o arquivo de estado atual. Secrets nunca são abertos. |
| 4:45–6:00 | Resumo público EKS | Evidência datada das imagens e dependências gerenciadas. Não mostrar conta, endpoint, DNS ou IDs. |
| 6:00–7:15 | Saída filtrada do script e resumo público | Host-based routing por NGINX/NLB; os cinco health checks passaram em 01/11. Explicar que o endereço tinha allow-list /32 e pode não estar acessível agora. |
| 7:15–9:15 | Saída filtrada do script e resumo público | Flags PERCENTAGE 100/0, kill switch, flag ausente e Cache MISS/HIT. Diferenciar teste funcional de uma consulta `/health`. |
| 9:15–10:45 | Resumo público e saída filtrada do script | Evaluation → SQS → Analytics → DynamoDB; envio manual e leitura do item registrados em 01/11. Idempotência: duas mensagens com mesmo `event_id`, um item. |
| 10:45–12:45 | Resumo público EKS | Resultado histórico: 49.893 respostas, zero falhas; HPA de evaluation 1→2 e scale-down; analytics 1→2. Não executar carga na gravação. |
| 12:45–14:15 | Seção de recuperação do resumo público EKS | Dificuldade real: nós substitutos falharam no bootstrap por negação SCP de `ec2:DescribeInstances`. Solução registrada: reciclar node group 0→2 durante sessão ativa; os novos nós ficaram Ready. Não refazer. |
| 14:15–15:00 | README público e modelo do relatório final | Limites do Academy, pendências administrativas e fechamento honesto. |

## Decisões técnicas que vale explicar com palavras próprias

- Redis é cache com TTL curto para avaliação; PostgreSQL guarda configuração transacional; DynamoDB persiste eventos. São papéis diferentes.
- Evaluation publica eventos sem bloquear a resposta HTTP. O consumidor analytics usa escrita condicional por `event_id` para idempotência.
- HPA mede CPU em relação aos requests e só escala até os limites configurados; não cria capacidade de nó nem aumenta RDS.
- No AWS Academy, IAM limitado impediu a identidade de workload pretendida. O caminho temporário usado na sessão tem credenciais de curta duração e precisa ser tratado como limitação, não recomendação geral.
- Não há outbox durável: uma falha definitiva antes de publicar pode perder o evento. Dizer isso como limite atual, sem transformar a correção de idempotência em garantia de entrega.

## Frases a evitar / precisão da apresentação

- Não dizer “a AWS está funcionando agora” se não houver uma consulta ao vivo bem-sucedida.
- Não misturar Compose, kind e EKS. Compose usa dependências locais e desativa SQS; kind usa emuladores; o fluxo AWS real foi registrado em 01/11.
- Não chamar configuração de HPA de prova de scale-out: abrir os logs datados com réplicas observadas.
- Não afirmar benchmark de produção nem repetir uma carga que não foi autorizada para o dia.
- Não mostrar IDs de conta, URL/IP do balanceador, tokens, chaves, `.env`, kubeconfig ou dados de Secrets.
