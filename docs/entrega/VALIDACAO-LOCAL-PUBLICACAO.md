# Validação local da publicação

**Data:** 03/11/2026 (horário local).
**Escopo:** validação da cópia com submódulos FIAP-TCs nos commits-base e patches autorais aplicados. Nenhuma operação AWS foi executada.

## Resultados

- `docker compose config --services`: válido; listou os cinco serviços e quatro dependências, nove serviços Compose no total.
- `docker compose build`: sucesso para as cinco imagens (auth, flag, targeting, evaluation e analytics). Os contêineres não foram iniciados nesta validação.
- Evaluation: `Dockerfile.events-test` executou `go test -race -p 2 -count=1 -v ./...`; todos os testes passaram, incluindo a cadeia de credenciais simulada em loopback, sem acesso AWS.
- Analytics: `python -m unittest discover -s tests -v` executado na imagem local construída; 22 testes passaram.
- Patchset: os cinco patches foram conferidos e aplicados aos commits-base fixados pelos submódulos; o comando documentado no README foi testado.
- Segurança: `.env` não foi criado nem publicado; a configuração e patches foram verificados por padrões de credenciais AWS, tokens, chaves privadas, ARNs e identificadores de conta; nenhum padrão sensível foi encontrado.

## Limites

- Não há diretórios de teste dedicados em auth-service, flag-service ou targeting-service; a compilação dessas imagens passou.
- Os testes unitários de analytics falharam inicialmente no Python local porque `botocore` não está instalado nesse interpretador. Foram executados com sucesso dentro da imagem que já instala as dependências do serviço.
- Não houve `docker compose up`, teste integrado local dos nove contêineres, deploy ou chamada AWS nesta validação. O sucesso do build não é apresentado como teste de prontidão/saúde em execução.
- Evidências de EKS/SQS/DynamoDB/RDS/Redis continuam históricas, datadas de 01/11/2026; consulte o resumo público e os recortes complementares sanitizados.
