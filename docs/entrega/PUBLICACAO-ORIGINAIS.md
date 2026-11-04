# Proveniência e escopo

Este repositório contém materiais de infraestrutura, automação e documentação do projeto ToggleMaster. Não contém fontes, patches ou históricos dos cinco microsserviços disponibilizados pela FIAP-TCs.

Referências aos projetos upstream:

- [auth-service](https://github.com/FIAP-TCs/auth-service)
- [flag-service](https://github.com/FIAP-TCs/flag-service)
- [targeting-service](https://github.com/FIAP-TCs/targeting-service)
- [evaluation-service](https://github.com/FIAP-TCs/evaluation-service)
- [analytics-service](https://github.com/FIAP-TCs/analytics-service)

Os links identificam os projetos de origem; não os apresentam como repositórios de autoria deste projeto. Não redistribua código ou histórico dos upstreams sem autorização explícita.

O `docker-compose.yml` do projeto de infraestrutura e os cinco arquivos Dockerfile foram verificados como arquivos de configuração criados em commits locais atribuídos ao participante. Foram copiados isoladamente; nenhum fonte de serviço foi copiado. A auditoria de padrões não encontrou credenciais reais, ARNs, números de conta, JWTs, chaves privadas ou DNS de recursos. O Compose contém os valores literais `local` apenas para emuladores locais.

O Compose depende de diretórios/arquivos dos serviços que não acompanham este snapshot e de alterações locais não redistribuídas. Portanto, o repositório público mostra a configuração e templates de build, mas não permite reproduzir sozinho o build/run dos nove contêineres.

O snapshot público foi montado sem histórico Git operacional, diretórios dos serviços, `.env`, kubeconfig, arquivos de configuração privada ou logs brutos. A infraestrutura AWS registrada no resumo é evidência histórica coletada em 01/11/2026, não uma afirmação de disponibilidade atual.
