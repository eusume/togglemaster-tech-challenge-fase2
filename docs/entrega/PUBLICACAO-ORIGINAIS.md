# Proveniência e escopo

Este repositório contém infraestrutura, automação, documentação, referências Git aos cinco microsserviços FIAP-TCs e patches das alterações locais atribuídas ao participante. Não incorpora os fontes-base nem o histórico dos upstreams no repositório principal.

Referências aos projetos upstream:

- [auth-service](https://github.com/FIAP-TCs/auth-service)
- [flag-service](https://github.com/FIAP-TCs/flag-service)
- [targeting-service](https://github.com/FIAP-TCs/targeting-service)
- [evaluation-service](https://github.com/FIAP-TCs/evaluation-service)
- [analytics-service](https://github.com/FIAP-TCs/analytics-service)

Os projetos de origem estão identificados como upstreams, não como repositórios de autoria do participante. Os serviços são vinculados como submódulos nos commits-base usados para preparar as alterações. Os metadados públicos consultados não indicaram licenças de redistribuição; por isso, seus fontes e históricos não foram copiados para este repositório.

Os arquivos em `patches/` foram gerados das diferenças entre os commits locais atribuídos ao participante e os commits-base dos upstreams; não preservam o histórico operacional dos serviços. Eles contêm alterações de aplicação/configuração e Dockerfiles necessários ao Compose. A auditoria de padrões não encontrou credenciais reais, ARNs, números de conta, JWTs, chaves privadas ou DNS de recursos. O Compose contém os valores literais `local` apenas para emuladores locais.

Para reproduzir os diretórios de trabalho, clone com `--recurse-submodules` e aplique os patches conforme o README principal. O Compose usa os diretórios `services/<service>` como contextos de build; `.env` é criado localmente pelo script e não deve ser versionado. A execução depende também de Docker e acesso a registries para as imagens das dependências.

O snapshot público foi montado sem o histórico Git operacional do workspace, cópias dos fontes upstream no repositório principal, `.env`, kubeconfig, arquivos privados ou logs brutos. A infraestrutura AWS registrada no resumo é evidência histórica coletada em 01/11/2026, não uma afirmação de disponibilidade atual.
