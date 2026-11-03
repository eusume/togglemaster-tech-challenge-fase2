# Guia de gravação — ToggleMaster

Roteiro operacional de 15 minutos (máximo oficial: 20). As consultas deste guia são de leitura. Não contém comandos para publicar, criar recursos AWS, escalar manualmente, enviar SQS, executar carga, apagar dados ou recriar o Compose.

## 1. Preparação das janelas

1. Abra o workspace `tech-challenge-fase2` no VS Code.
2. Abra no VS Code: `README-PUBLICO-FIAP.md`, `ROTEIRO-VIDEO-FIAP.md` e `docs\entrega\evidencias\RESUMO-PUBLICO-EKS-20261101.md`.
3. Abra PowerShell no diretório raiz interno: `C:\Users\esume\tech-challenge-fase2\tech-challenge-fase2`.
4. Se o EKS estiver realmente ativo e houver uma sessão AWS válida, passe ao script o caminho do kubeconfig fora do repositório, sem abrir nem imprimir seu conteúdo. Caso contrário, use o resumo arquivado como evidência histórica.
5. Inicie a gravação de tela e faça um teste curto de áudio. Mantenha o cursor longe de notificações e de gerenciadores de credenciais.

**Não deixe arquivos brutos de evidência abertos durante a gravação.** Eles contêm DNS, IDs de execução, MessageIds e IDs de eventos. O resumo público e a saída filtrada do script foram preparados para mostrar os resultados sem esses valores.

**Política PowerShell:** neste workspace, a execução direta de `.ps1` está bloqueada pela política local. Não altere a política global para a gravação. Se a execução continuar bloqueada no seu terminal, use os comandos de leitura desta seção manualmente; o script foi validado isoladamente sem persistir mudanças de política.

## 2. Sequência de comandos

### A. Identificar os serviços e o Compose (0:00–3:15)

```powershell
Get-Location
.\DEMO-FIAP.ps1
```

O script lista auth (8001), flag (8002), targeting (8003), evaluation (8004) e analytics (8005), consulta os health checks e lê o estado atual do Compose. Reconheça nove serviços com estado `running` e saúde `healthy`; se divergirem, relate a saída atual sem reiniciar containers.

**Explique:** a demonstração local tem cinco aplicações, dois containers PostgreSQL, Redis e DynamoDB Local. SQS fica desativado no Compose base; não atribua integrações AWS ao teste local.

### B. Kubernetes, EKS e ECR (3:15–6:00)

Se a AWS estiver disponível e você puder confirmar que a sessão é atual, execute o script com o arquivo privado:

```powershell
.\DEMO-FIAP.ps1 -KubeconfigPath "$env:USERPROFILE\.togglemaster\eks.kubeconfig"
```

O script valida que o contexto contém `togglemaster-eks` antes de consultar Kubernetes. Mostra apenas nomes/contagens de Deployments, Services, ConfigMaps, Secrets, HPAs e Ingress. Não imprime dados de Secrets nem endereço do NLB. As consultas AWS são `describe/list/get` e não criam nem alteram recursos.

Se a sessão/cloud não estiver disponível, abra somente o resumo sanitizado:

```powershell
code .\docs\entrega\evidencias\RESUMO-PUBLICO-EKS-20261101.md
```

Identifique na tela a data `01/11/2026 UTC`. O resumo registra EKS, cinco serviços, imagens ECR e dependências gerenciadas. Não apresente esses fatos como consulta ao vivo.

### C. Ingress e rotas (6:00–7:15)

Use a seção de resultados do `DEMO-FIAP.ps1` (ele omite identificadores) ou o resumo público. Não abra `e2e.log` diretamente durante a gravação.

O resultado documentado é que cinco `/health` HTTP 200 passaram pelo NLB → NGINX → serviços, roteados pelo cabeçalho `Host`. Explique que o acesso externo tinha allow-list `/32`; o bloqueio atual de rede não invalida a evidência histórica, mas também não prova disponibilidade de hoje.

### D. Feature flags, Redis, SQS e DynamoDB (7:15–10:45)

Abra `RESUMO-PUBLICO-EKS-20261101.md` ou use os resultados filtrados apresentados pelo script. Não abra os logs brutos durante a gravação.

Reconheça PERCENTAGE 100→`true`, PERCENTAGE 0→`false`, kill switch e flag inexistente. Nos logs, a repetição da avaliação mostra Cache MISS/HIT. No E2E, destaque `evaluation -> SQS real -> analytics -> DynamoDB real` e a idempotência: duas mensagens distintas com o mesmo `event_id` resultaram em um item. O arquivo `sqs-manual.txt` documenta um envio manual e a leitura posterior no DynamoDB. Oculte IDs e payloads.

Não execute de novo o teste E2E durante a gravação: ele grava dados reais em RDS, SQS e DynamoDB. Não envie outra mensagem manual.

### E. Escalabilidade baseada em evidência (10:45–12:45)

Use a seção de escalabilidade do `RESUMO-PUBLICO-EKS-20261101.md` ou a saída resumida do script. O registro histórico informa 49.893 respostas, zero falhas no perfil de 120 rps alvo; HPA evaluation 1→2 e scale-down posterior; analytics 1→2 enquanto processava eventos. Esses são resultados de 01/11, não uma carga desta gravação.

**Não rode** `scripts/eks-load.py`, jobs de carga, `kubectl scale` ou qualquer comando de provisionamento durante a gravação.

### F. Dificuldade real e recuperação do EKS (12:45–14:15)

Use a seção “Dificuldade de operação EKS registrada” do resumo público. O diagnóstico detalhado permanece local e não deve aparecer na gravação. A recuperação documentada foi o ciclo do node group 0→2 durante sessão ativa; não refaça essa operação.

### G. Fechamento (14:15–15:00)

```powershell
code .\README-PUBLICO-FIAP.md
```

Feche com limitações do Academy, pendência de gravação/links/dados dos participantes e a distinção entre validação datada e estado atual.

## 3. Alternativa se AWS estiver indisponível

Use `docs\entrega\evidencias\RESUMO-PUBLICO-EKS-20261101.md` e a saída filtrada do script. A evidência tem data de 01/11/2026. Não abra logs brutos nem use telas antigas como se fossem atuais; não substitua AWS por kind/Compose ao descrever os requisitos de cloud.

## 4. Informações a ocultar

- `.env`, tokens, `MASTER_KEY`, `SERVICE_API_KEY`, senhas e credenciais AWS.
- Conteúdo de kubeconfig, arquivos de Secrets ou o comando de leitura de credenciais.
- URL/IP/DNS do LoadBalancer, IP de origem permitido, endpoint privado de banco/cache.
- Número de conta, identificadores de instâncias/roles, MessageIds, IDs de eventos e payloads.
- Abas de terminal com histórico que revelem esses valores.

O script `DEMO-FIAP.ps1` omite esses campos nas consultas planejadas. Ainda assim, revise a tela antes de compartilhar/gravar.

## 5. Checklist antes de publicar o vídeo

- [ ] Duração final entre 12 e 16 minutos e nunca acima de 20 minutos.
- [ ] Áudio inteligível; tela mostra os arquivos certos e os carimbos de data das evidências.
- [ ] Falas naturais baseadas nos tópicos, sem leitura literal do roteiro.
- [ ] Compose chamado de ambiente local; AWS apresentada como evidência histórica de 01/11 se não houver consulta atual.
- [ ] Sem carga, escrita SQS, deploy, escala, provisionamento ou limpeza durante a gravação.
- [ ] Sem `.env`, credenciais, Secrets, kubeconfig, IP/DNS/conta, IDs ou payloads visíveis.
- [ ] Link do vídeo abre para o avaliador e está incluído no relatório final.
- [ ] README e relatório identificam pendências reais; integrantes, RM, Discord e links foram preenchidos pelo grupo.
