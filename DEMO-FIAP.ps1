[CmdletBinding()]
param(
    [string]$KubeconfigPath = ''
)

$ErrorActionPreference = 'Continue'
$root = $PSScriptRoot
$composeFile = Join-Path $root 'docker-compose.yml'
$evidenceDir = Join-Path $root 'docs\entrega\evidencias\eks-20261101'
$servicePorts = @(
    [pscustomobject]@{ Name = 'auth-service'; Port = 8001 },
    [pscustomobject]@{ Name = 'flag-service'; Port = 8002 },
    [pscustomobject]@{ Name = 'targeting-service'; Port = 8003 },
    [pscustomobject]@{ Name = 'evaluation-service'; Port = 8004 },
    [pscustomobject]@{ Name = 'analytics-service'; Port = 8005 }
)
$routeHosts = @('auth', 'flags', 'targeting', 'evaluate', 'analytics')
$script:cloudEvidenceShown = $false

function Write-Section {
    param([string]$Title)
    Write-Host ''
    Write-Host ('=' * 72) -ForegroundColor DarkCyan
    Write-Host $Title -ForegroundColor Cyan
    Write-Host ('=' * 72) -ForegroundColor DarkCyan
}

function Write-EvidenceNote {
    param([string]$Message)
    Write-Host "[EVIDENCIA 01/11/2026 UTC] $Message" -ForegroundColor Yellow
}

function Show-CloudEvidence {
    $script:cloudEvidenceShown = $true
    Write-EvidenceNote 'EKS, ECR, Ingress, SQS/DynamoDB, E2E e HPA: evidencias arquivadas, nao estado cloud ao vivo.'
    Write-Host "E2E: $(Join-Path $evidenceDir 'e2e.log')"
    Write-Host "Infra/ECR: $(Join-Path $evidenceDir 'aws-infra.txt')"
    Write-Host "HPA: $(Join-Path $evidenceDir 'hpa-watch-2.log'), hpa-watch-3.log e load-3.log"

    $e2ePath = Join-Path $evidenceDir 'e2e.log'
    if (Test-Path $e2ePath) {
        Get-Content $e2ePath |
            Select-String -Pattern '^PASS ' |
            ForEach-Object {
                $safeLine = $_.Line -replace 'eks-e2e-[0-9a-f]+', '[run omitido]'
                Write-Host $safeLine
            }
    } else {
        Write-Host '[AVISO] Evidencia E2E nao encontrada.'
    }

    $serviceLogsPath = Join-Path $evidenceDir 'e2e-service-logs.txt'
    if (Test-Path $serviceLogsPath) {
        $serviceLines = Get-Content $serviceLogsPath
        $cacheMiss = @($serviceLines | Select-String -Pattern 'Cache MISS').Count
        $cacheHit = @($serviceLines | Select-String -Pattern 'Cache HIT').Count
        $stored = @($serviceLines | Select-String -Pattern 'Event processed: stored').Count
        $duplicate = @($serviceLines | Select-String -Pattern 'Event processed: duplicate').Count
        Write-Host "Evaluation: Cache MISS=$cacheMiss, HIT=$cacheHit; analytics: stored=$stored, duplicate=$duplicate."
    } else {
        Write-Host '[AVISO] Logs de evaluation/analytics nao encontrados.'
    }

    $manualPath = Join-Path $evidenceDir 'sqs-manual.txt'
    if (Test-Path $manualPath) {
        $manualLines = Get-Content $manualPath
        if (($manualLines -match 'send-message -> MessageId') -and ($manualLines -match 'dynamodb get-item.*encontrado')) {
            Write-Host 'SQS manual -> DynamoDB confirmado na evidencia; IDs e payload omitidos.'
        } else {
            Write-Host '[AVISO] Confirmacao de SQS/DynamoDB nao encontrada no registro manual.'
        }
    }

    $loadPath = Join-Path $evidenceDir 'load-3.log'
    if (Test-Path $loadPath) {
        $loadLines = Get-Content $loadPath
        $resultLine = $loadLines | Select-String -Pattern '"ok":|"failed":|"result": "PASS"' |
            ForEach-Object { $_.Line -replace 'hpa-eks-[0-9a-f]+', '[run omitido]' }
        Write-Host 'Carga historica aprovada (01/11; nao executar carga novamente):'
        $resultLine | ForEach-Object { Write-Host $_ }
    }

    Write-Host 'Resumo historico: evaluation 1->2 sob carga (120 rps alvo; 49.893 respostas, 0 falhas); analytics 1->2; scale-down observado.'
}

Write-Section '1. Cinco microservicos'
foreach ($service in $servicePorts) {
    $servicePath = Join-Path $root $service.Name
    $dockerfile = Join-Path $servicePath 'Dockerfile'
    $readme = Join-Path $servicePath 'README.md'
    [pscustomobject]@{
        Servico = $service.Name
        Diretorio = Test-Path $servicePath
        Dockerfile = Test-Path $dockerfile
        README = Test-Path $readme
        Porta = $service.Port
    }
}

Write-Section '2. Docker Compose local (somente leitura)'
if (-not (Get-Command docker -ErrorAction SilentlyContinue)) {
    Write-Host '[ERRO] Docker CLI nao esta instalado.'
} elseif (-not (Test-Path $composeFile)) {
    Write-Host "[ERRO] Compose nao encontrado: $composeFile"
} else {
    $composeOutput = & docker compose -f $composeFile ps --format json 2>&1
    $composeExit = $LASTEXITCODE
    if ($composeExit -ne 0) {
        Write-Host "[ERRO] docker compose ps terminou com codigo $composeExit."
        $composeOutput | ForEach-Object { Write-Host $_ }
    } else {
        $containers = @()
        foreach ($line in $composeOutput) {
            if (-not [string]::IsNullOrWhiteSpace([string]$line)) {
                try {
                    $containers += ConvertFrom-Json -InputObject ([string]$line)
                } catch {
                    Write-Host '[ERRO] Nao foi possivel interpretar uma linha do estado do Compose.'
                }
            }
        }
        if ($containers.Count -gt 0) {
            $containers |
                Select-Object Service, State, Health |
                Format-Table -AutoSize
            $running = @($containers | Where-Object { $_.State -eq 'running' }).Count
            $healthy = @($containers | Where-Object { $_.Health -eq 'healthy' }).Count
            Write-Host "Resumo local: $($containers.Count) containers; $running running; $healthy healthy."
        } else {
            Write-Host 'Compose nao reporta containers ativos para este projeto.'
        }
    }
}

Write-Section '3. Health checks locais (GET)'
foreach ($service in $servicePorts) {
    try {
        $response = Invoke-RestMethod -Method Get -Uri "http://127.0.0.1:$($service.Port)/health" -TimeoutSec 3
        Write-Host "$($service.Name): $($response.status)"
    } catch {
        Write-Host "$($service.Name): indisponivel neste host (nao iniciar nem recriar servicos automaticamente)."
    }
}
Write-Host 'O Compose base usa DynamoDB Local; SQS esta desativado nele. Isso nao comprova integracao AWS.'

Write-Section '4. Kubernetes/EKS (consultas somente leitura)'
if (-not $KubeconfigPath) {
    if ($env:KUBECONFIG) {
        $KubeconfigPath = ($env:KUBECONFIG -split ';')[0]
    } else {
        $KubeconfigPath = Join-Path $env:USERPROFILE '.togglemaster\eks.kubeconfig'
    }
}

$liveKubernetes = $false
if ((Get-Command kubectl -ErrorAction SilentlyContinue) -and (Test-Path $KubeconfigPath)) {
    $contextName = & kubectl --kubeconfig $KubeconfigPath config current-context 2>$null
    if ($LASTEXITCODE -eq 0 -and $contextName -match 'togglemaster-eks') {
        $namespace = & kubectl --kubeconfig $KubeconfigPath get namespace togglemaster -o name `
            --request-timeout=8s 2>$null
        if ($LASTEXITCODE -eq 0 -and $namespace -eq 'namespace/togglemaster') {
            $liveKubernetes = $true
            Write-Host 'Contexto ToggleMaster identificado; dados/Secrets e conteudo do kubeconfig nao serao exibidos.'
            & kubectl --kubeconfig $KubeconfigPath get deployments -n togglemaster `
                -o 'custom-columns=NAME:.metadata.name,READY:.status.readyReplicas,DESIRED:.spec.replicas'
            & kubectl --kubeconfig $KubeconfigPath get services -n togglemaster `
                -o 'custom-columns=NAME:.metadata.name,TYPE:.spec.type,PORTS:.spec.ports[*].port'
            & kubectl --kubeconfig $KubeconfigPath get configmaps -n togglemaster `
                -o 'custom-columns=NAME:.metadata.name'
            & kubectl --kubeconfig $KubeconfigPath get secrets -n togglemaster `
                -o 'custom-columns=NAME:.metadata.name,TYPE:.type'
            & kubectl --kubeconfig $KubeconfigPath get hpa -n togglemaster `
                -o 'custom-columns=NAME:.metadata.name,CPU:.status.currentMetrics[*].resource.current.averageUtilization,TARGET:.spec.metrics[*].resource.target.averageUtilization,REPLICAS:.status.currentReplicas,DESIRED:.status.desiredReplicas'
            & kubectl --kubeconfig $KubeconfigPath get ingress -n togglemaster `
                -o 'custom-columns=NAME:.metadata.name,CLASS:.spec.ingressClassName,HOSTS:.spec.rules[*].host,PATHS:.spec.rules[*].http.paths[*].path'
            & kubectl --kubeconfig $KubeconfigPath get services -n nginx-ingress `
                -o 'custom-columns=NAME:.metadata.name,TYPE:.spec.type,PORTS:.spec.ports[*].port'

            $loadBalancerHost = & kubectl --kubeconfig $KubeconfigPath get service `
                togglemaster-nginx-nginx-ingress-controller -n nginx-ingress `
                -o 'jsonpath={.status.loadBalancer.ingress[0].hostname}' --request-timeout=8s 2>$null
            if ($LASTEXITCODE -eq 0 -and $loadBalancerHost -and (Get-Command curl.exe -ErrorAction SilentlyContinue)) {
                foreach ($routeHost in $routeHosts) {
                    $httpCode = & curl.exe --silent --output NUL --write-out '%{http_code}' --max-time 5 `
                        --header "Host: $routeHost.togglemaster.test" "http://$loadBalancerHost/health" 2>$null
                    if ($LASTEXITCODE -eq 0 -and $httpCode -eq '200') {
                        Write-Host "[ROTA] $routeHost`: HTTP 200"
                    } else {
                        Write-Host "[ROTA] $routeHost`: sem resposta 200 (indisponivel ou fora do allow-list)."
                    }
                }
            } else {
                Write-Host 'Rota externa nao consultada; conferir a evidencia E2E arquivada.'
            }

            $evaluationLogs = & kubectl --kubeconfig $KubeconfigPath logs deployment/evaluation-service `
                -n togglemaster --since=15m 2>$null
            if ($LASTEXITCODE -eq 0) {
                $missCount = @($evaluationLogs | Select-String -Pattern 'Cache MISS').Count
                $hitCount = @($evaluationLogs | Select-String -Pattern 'Cache HIT').Count
                Write-Host "Evaluation nos logs atuais: Cache MISS=$missCount, HIT=$hitCount."
            } else {
                Write-Host 'Logs de evaluation indisponiveis nesta consulta.'
            }

            $analyticsLogs = & kubectl --kubeconfig $KubeconfigPath logs deployment/analytics-service `
                -n togglemaster --since=15m 2>$null
            if ($LASTEXITCODE -eq 0) {
                $storedCount = @($analyticsLogs | Select-String -Pattern 'Event processed: stored').Count
                $duplicateCount = @($analyticsLogs | Select-String -Pattern 'Event processed: duplicate').Count
                Write-Host "Analytics nos logs atuais: stored=$storedCount, duplicate=$duplicateCount."
            } else {
                Write-Host 'Logs de analytics indisponiveis nesta consulta.'
            }
        } else {
            Write-Host 'Namespace EKS nao respondeu; usando evidencias arquivadas.'
        }
    } else {
        Write-Host 'Contexto nao identificado como o EKS ToggleMaster; nenhuma consulta Kubernetes foi feita.'
    }
} else {
    Write-Host 'Kubeconfig EKS/kubectl indisponivel; usando apenas evidencias arquivadas.'
}
if (-not $liveKubernetes) {
    Write-Host 'Estado Kubernetes ao vivo indisponivel ou nao confirmado.'
}
Show-CloudEvidence

Write-Section '5. EKS/ECR e servicos AWS (consultas somente leitura)'
$awsAuthenticated = $false
if (Get-Command aws -ErrorAction SilentlyContinue) {
    $null = & aws sts get-caller-identity --query Account --output text 2>$null
    $awsAuthenticated = ($LASTEXITCODE -eq 0)
}

if ($awsAuthenticated) {
    Write-Host 'Sessao AWS valida; consultas abaixo sao somente leitura e omitem conta, endpoints e credenciais.'
    $awsReadCommands = @(
        @{ Label = 'EKS'; Args = @('eks','describe-cluster','--region','us-east-1','--name','togglemaster-eks','--query','cluster.[name,status,version]','--output','table') },
        @{ Label = 'ECR (repositorios/tags imutaveis)'; Args = @('ecr','describe-repositories','--region','us-east-1','--query','repositories[].{name:repositoryName,mutability:imageTagMutability}','--output','table') },
        @{ Label = 'RDS PostgreSQL'; Args = @('rds','describe-db-instances','--region','us-east-1','--query','DBInstances[].{name:DBInstanceIdentifier,status:DBInstanceStatus,engine:EngineVersion,public:PubliclyAccessible}','--output','table') },
        @{ Label = 'ElastiCache Redis'; Args = @('elasticache','describe-replication-groups','--region','us-east-1','--query','ReplicationGroups[].{name:ReplicationGroupId,status:Status,tls:TransitEncryptionEnabled,auth:AuthTokenEnabled}','--output','table') },
        @{ Label = 'DynamoDB'; Args = @('dynamodb','describe-table','--region','us-east-1','--table-name','ToggleMasterAnalytics','--query','Table.{status:TableStatus,items:ItemCount,key:KeySchema[0].AttributeName}','--output','table') }
    )
    foreach ($entry in $awsReadCommands) {
        Write-Host "-- $($entry.Label)"
        $awsArgs = $entry.Args
        $awsOutput = & aws @awsArgs 2>$null
        if ($LASTEXITCODE -eq 0) {
            $awsOutput | ForEach-Object { Write-Host $_ }
        } else {
            Write-Host '[INDISPONIVEL] Consulta sem autorizacao ou recurso fora do ar; conferir evidencia datada.'
        }
    }
    foreach ($repository in @(
        'togglemaster-auth',
        'togglemaster-flag',
        'togglemaster-targeting',
        'togglemaster-evaluation',
        'togglemaster-analytics'
    )) {
        Write-Host "-- ECR $repository / fase2-20261030-rc1"
        $imageOutput = & aws ecr describe-images --region us-east-1 --repository-name $repository `
            --image-ids imageTag=fase2-20261030-rc1 `
            --query 'imageDetails[0].[imageTags[0],imageDigest]' --output table 2>$null
        if ($LASTEXITCODE -eq 0) {
            $imageOutput | ForEach-Object { Write-Host $_ }
        } else {
            Write-Host '[INDISPONIVEL] Imagem nao consultada; conferir aws-infra.txt, evidencia de 01/11.'
        }
    }
    $queueUrl = & aws sqs get-queue-url --region us-east-1 --queue-name togglemaster-events --query QueueUrl --output text 2>$null
    if ($LASTEXITCODE -eq 0 -and $queueUrl) {
        Write-Host '-- SQS: contagens aproximadas (URL ocultada)'
        & aws sqs get-queue-attributes --region us-east-1 --queue-url $queueUrl `
            --attribute-names ApproximateNumberOfMessages ApproximateNumberOfMessagesNotVisible `
            --query Attributes --output table 2>$null
    } else {
        Write-Host '[INDISPONIVEL] Consulta SQS nao concluida; conferir a evidencia E2E de 01/11.'
    }
} else {
    Write-Host 'AWS CLI sem sessao valida; nenhuma operacao AWS foi executada alem da verificacao de identidade.'
}
if (-not $script:cloudEvidenceShown) {
    Show-CloudEvidence
}

Write-Section '6. Limites e seguranca'
Write-Host 'Nenhuma criacao/alteracao/remocao AWS ou Kubernetes, envio SQS, carga, deploy ou escala foi executado.'
Write-Host 'Nao abra .env, kubeconfig, Secrets, credenciais AWS, IP permitido no NLB ou valores de ConfigMaps.'
Write-Host 'EKS/ECR/Ingress/E2E/HPA arquivados foram observados em 01/11/2026 UTC; nao sao estado atual garantido.'
