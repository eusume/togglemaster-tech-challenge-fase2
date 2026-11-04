# Conteinerização: escopo e reprodução

O enunciado pede cinco Dockerfiles e um `docker-compose.yml` que inicie cinco aplicações e quatro dependências locais (dois PostgreSQL, Redis e DynamoDB Local), totalizando nove contêineres.

## Arquivos publicados

- [`docker-compose.yml`](../../docker-compose.yml): configuração local de cinco aplicações, dois PostgreSQL, Redis e DynamoDB Local.
- [`dockerfiles/`](../../dockerfiles/): cinco Dockerfiles, criados em commits locais atribuídos ao participante. Eles contêm instruções de build, não os fontes dos serviços.
- O Compose foi validado anteriormente no workspace local com nove contêineres `running/healthy`. Esta publicação não reiniciou os contêineres.

## Limite de reprodução deste snapshot

Os diretórios `auth-service/`, `flag-service/`, `targeting-service/`, `evaluation-service/` e `analytics-service/` não estão neste repositório. O Compose pressupõe esses contextos em disco e monta alguns arquivos deles. Portanto, **clonar somente este repositório não basta para executar `docker compose up`**.

Os fontes são fornecidos pela FIAP-TCs e permanecem referenciados no README, sem cópias aqui. Os Dockerfiles foram preparados para as versões locais de trabalho, que incluem alterações além dos arquivos Docker; por exemplo, a versão local de analytics também tem `event_processing.py`. Sem permissão explícita para publicar as versões/patches dos serviços, não se afirma que os fontes upstream sozinhos produzam a release local validada.

Para tentar reproduzir em ambiente autorizado, obtenha os cinco fontes pelos canais FIAP, coloque-os nos diretórios esperados, aplique os Dockerfiles correspondentes e as alterações locais de que esses builds dependem. Execute `.\scripts\setup-local.ps1` para gerar os valores aleatórios necessários em um `.env` local (o script preserva um `.env` existente e não exibe os valores); confirme também que todos os volumes relativos existem. Não use os placeholders AWS do Compose fora de emuladores locais. Não inclua `.env`, credenciais ou arquivos privados no Git.

## Auditoria dos arquivos de build

O Compose pertence ao repositório local de infraestrutura; os cinco Dockerfiles foram adicionados em commits locais atribuídos ao participante. Antes de publicar, foram examinados quanto a chaves AWS, ARNs, números de conta, JWTs, chaves privadas e DNS de recursos; nenhum padrão foi encontrado. O Compose contém os valores literais `local` apenas para autenticação contra emuladores locais, não credenciais AWS utilizáveis.
