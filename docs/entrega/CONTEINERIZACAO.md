# Conteinerização: escopo e reprodução

O enunciado pede cinco Dockerfiles e um `docker-compose.yml` que inicie cinco aplicações e quatro dependências locais (dois PostgreSQL, Redis e DynamoDB Local), totalizando nove contêineres.

## Arquivos publicados

- [`docker-compose.yml`](../../docker-compose.yml): configuração local de cinco aplicações, dois PostgreSQL, Redis e DynamoDB Local.
- [`services/`](../../services/): submódulos que apontam para os cinco repositórios oficiais FIAP-TCs, sem copiar seus fontes ou histórico para o repositório principal.
- [`patches/`](../../patches/): deltas autorais locais em relação aos commits-base fixados pelos submódulos; incluem os Dockerfiles exigidos.
- O Compose foi validado anteriormente no workspace local com nove contêineres `running/healthy`. Esta publicação não reiniciou os contêineres.

## Limite de reprodução deste snapshot

Os cinco projetos não declaram licença de redistribuição nos metadados públicos consultados; os fontes e históricos não foram incorporados ao repositório principal. **Clonar sem submódulos e sem aplicar os patches não basta para executar `docker compose up`**.

O README principal contém os comandos para inicializar os submódulos, aplicar os patches e gerar `.env` com valores aleatórios locais. Os arquivos Compose usam contextos `services/<service>` e os patches fornecem Dockerfiles e demais mudanças desenvolvidas localmente.

As evidências históricas de nove contêineres saudáveis referem-se ao workspace validado em 01/11/2026, não a um build efetuado a partir deste snapshot. Não use os placeholders AWS do Compose fora de emuladores locais. Não inclua `.env`, credenciais ou arquivos privados no Git.

## Proveniência e auditoria

Os patches foram gerados comparando cada commit local atribuído ao participante com o commit-base oficial indicado em `patches/README.md`. O Compose, os patches e o script de inicialização foram examinados quanto a credenciais e identificadores AWS; os placeholders `local` no Compose servem somente para emuladores locais.
