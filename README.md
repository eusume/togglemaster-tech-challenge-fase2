# ToggleMaster — Tech Challenge FIAP Fase 2

Infraestrutura e materiais de entrega do ToggleMaster. Este repositório não contém cópias dos cinco microsserviços; consulte os upstreams FIAP-TCs listados abaixo. Os resultados AWS descritos são evidências históricas coletadas em 01/11/2026, não uma afirmação sobre o estado atual.

## Microsserviços

- [auth-service](https://github.com/FIAP-TCs/auth-service)
- [flag-service](https://github.com/FIAP-TCs/flag-service)
- [targeting-service](https://github.com/FIAP-TCs/targeting-service)
- [evaluation-service](https://github.com/FIAP-TCs/evaluation-service)
- [analytics-service](https://github.com/FIAP-TCs/analytics-service)

Não distribua cópias ou históricos desses repositórios sem autorização explícita de redistribuição.

## Arquitetura e validação

O fluxo usa avaliação de flags com cache Redis, serviços de autenticação/flags/segmentação, publicação assíncrona em SQS e persistência idempotente no DynamoDB. PostgreSQL mantém os dados de auth, flags e targeting. A infraestrutura inclui Kubernetes, Ingress e autoscaling.

O [resumo público EKS](docs/entrega/evidencias/RESUMO-PUBLICO-EKS-20261101.md) registra resultados reais com data. Os registros brutos continuam locais. A configuração [Docker Compose](docker-compose.yml) e os [Dockerfiles de autoria local](dockerfiles/) estão incluídos, mas os diretórios de código dos serviços não: o Compose, isoladamente, não faz build sem os fontes FIAP e os patches locais correspondentes.

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

## Segurança de publicação

Este snapshot foi criado sem histórico Git do workspace, sem os diretórios dos microsserviços FIAP-TCs, sem credenciais, `.env`, kubeconfig ou evidências brutas. O Compose usa somente placeholders locais para emuladores; não reutilize esses valores em AWS. O Ingress público dos manifests permite entrada de qualquer IPv4 (`0.0.0.0/0`); restrinja o CIDR antes de qualquer implantação. Os manifests são templates, não os aplique nem execute operações AWS sem revisar e configurar todos os valores para o seu ambiente.
