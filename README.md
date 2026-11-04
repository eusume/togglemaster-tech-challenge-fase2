# ToggleMaster — Tech Challenge FIAP Fase 2

Infraestrutura, patches autorais e materiais de entrega do ToggleMaster. Os códigos-base dos cinco microsserviços são mantidos pela FIAP-TCs e referenciados como submódulos, sem copiar seus fontes ou históricos para este repositório. Os resultados AWS descritos são evidências históricas coletadas em 01/11/2026, não uma afirmação sobre o estado atual.

## Microsserviços

- [auth-service upstream FIAP-TCs, base `56e447f`](https://github.com/FIAP-TCs/auth-service/tree/56e447f83409bf35b22ef04a9e39c2e30df9af33)
- [flag-service upstream FIAP-TCs, base `21052b1`](https://github.com/FIAP-TCs/flag-service/tree/21052b1abcf209ea6848350bdd9928b80b7f86fe)
- [targeting-service upstream FIAP-TCs, base `dd9568a`](https://github.com/FIAP-TCs/targeting-service/tree/dd9568a583fa409b88a446685779d9e581282fd2)
- [evaluation-service upstream FIAP-TCs, base `5e8ade0`](https://github.com/FIAP-TCs/evaluation-service/tree/5e8ade059f69650d2e8cfbefad0a83cfac25f0a9)
- [analytics-service upstream FIAP-TCs, base `212d7e9`](https://github.com/FIAP-TCs/analytics-service/tree/212d7e9b7e50f881c4022bc9e8d2722f08a2a3e2)

Os commits Git do repositório principal apontam para os submódulos nos commits-base necessários. As diferenças desenvolvidas localmente ficam em [patches/](patches/); a licença de redistribuição dos fontes não foi declarada pelos upstreams. Consulte [como obter as bases e aplicar as mudanças](patches/README.md).

## Arquitetura e validação

O fluxo usa avaliação de flags com cache Redis, serviços de autenticação/flags/segmentação, publicação assíncrona em SQS e persistência idempotente no DynamoDB. PostgreSQL mantém os dados de auth, flags e targeting. A infraestrutura inclui Kubernetes, Ingress e autoscaling.

O [resumo público EKS](docs/entrega/evidencias/RESUMO-PUBLICO-EKS-20261101.md) registra resultados reais com data; os [recortes sanitizados para demonstração](docs/entrega/evidencias/complemento-video/) mostram os arquivos de evidência e suas limitações. Os registros brutos continuam locais. A configuração [Docker Compose](docker-compose.yml), os cinco Dockerfiles e os patches autorais estão incluídos. Após clonar os submódulos e aplicar os patches, o Compose usa os caminhos `services/<service>` para construir os cinco microsserviços e quatro dependências, totalizando nove contêineres.

## Infraestrutura incluída

- [Manifests Kubernetes base](k8s/base/)
- [Exemplos de configuração com valores fictícios](k8s/examples/)
- [Scripts e SQL de inicialização PostgreSQL](infra/postgres/)
- [Docker Compose e limitações de reprodução](docs/entrega/CONTEINERIZACAO.md)

## Materiais de demonstração e entrega

- [Roteiro do vídeo de 15 minutos](ROTEIRO-VIDEO-FIAP.md)
- [Guia de gravação](GUIA-GRAVACAO-FIAP.md)
- [Demonstração somente leitura](DEMO-FIAP.ps1)
- [Relatório final de entrega FIAP (TXT)](docs/entrega/RELATORIO-FINAL-FIAP.txt)
- [Limites de publicação e proveniência](docs/entrega/PUBLICACAO-ORIGINAIS.md)
- [Resultados da validação local de publicação](docs/entrega/VALIDACAO-LOCAL-PUBLICACAO.md)

## Execução local do Compose

Requer Git com suporte a submódulos, Docker Engine e Docker Compose. O clone inicializa os upstreams nos commits-base; depois, aplique os patches locais uma vez:

```powershell
git clone --recurse-submodules https://github.com/eusume/togglemaster-tech-challenge-fase2.git
Set-Location togglemaster-tech-challenge-fase2
foreach ($service in @('auth-service','flag-service','targeting-service','evaluation-service','analytics-service')) {
    git -C "services/$service" apply --recount --unidiff-zero --ignore-space-change "../../patches/$service.patch"
}
.\scripts\setup-local.ps1
docker compose up --build -d
docker compose ps
```

O Compose sobe dois PostgreSQL, Redis, DynamoDB Local e os cinco serviços. As chaves aleatórias ficam apenas no `.env` local, ignorado pelo Git; os endpoints AWS no Compose apontam apenas para emuladores locais. Para parar sem apagar dados persistidos, use `docker compose down` (não acrescente `-v` se quiser conservar volumes).

## Segurança de publicação

Este snapshot não inclui o histórico Git operacional do workspace, fontes copiados dos microsserviços, credenciais, `.env`, kubeconfig ou evidências brutas. Os submódulos apontam para os upstreams; os patches contêm somente deltas locais. O Compose usa placeholders locais para emuladores; não reutilize esses valores em AWS. O Ingress público dos manifests permite entrada de qualquer IPv4 (`0.0.0.0/0`); restrinja o CIDR antes de qualquer implantação. Os manifests são templates, não os aplique nem execute operações AWS sem revisar e configurar todos os valores para o seu ambiente.
