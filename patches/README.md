# Microsserviços: upstreams e patches locais

Os projetos-base são mantidos por FIAP-TCs:

- https://github.com/FIAP-TCs/auth-service
- https://github.com/FIAP-TCs/flag-service
- https://github.com/FIAP-TCs/targeting-service
- https://github.com/FIAP-TCs/evaluation-service
- https://github.com/FIAP-TCs/analytics-service

Na data desta publicação, os metadados públicos não indicavam licença de redistribuição para esses repositórios. Por isso, este repositório não copia nem publica os diretórios-fonte, o conteúdo integral ou os históricos Git upstream. O arquivo `.gitmodules` referencia os repositórios oficiais; os gitlinks fixam os commits-base usados para gerar os patches.

| Serviço | Commit-base upstream |
|---|---|
| auth-service | `56e447f83409bf35b22ef04a9e39c2e30df9af33` |
| flag-service | `21052b1abcf209ea6848350bdd9928b80b7f86fe` |
| targeting-service | `dd9568a583fa409b88a446685779d9e581282fd2` |
| evaluation-service | `5e8ade059f69650d2e8cfbefad0a83cfac25f0a9` |
| analytics-service | `212d7e9b7e50f881c4022bc9e8d2722f08a2a3e2` |

Os arquivos `*-service.patch` registram somente as diferenças locais em relação à respectiva base. Para um clone novo, inicialize os submódulos com `git clone --recurse-submodules`, a partir da raiz aplique cada patch usando o comando do README principal:

```powershell
foreach ($service in @('auth-service','flag-service','targeting-service','evaluation-service','analytics-service')) {
    git -C "services/$service" apply --recount --unidiff-zero --ignore-space-change "../../patches/$service.patch"
}
```

Os patches são mudanças locais sem histórico dos repositórios de serviço. Se um patch não se aplicar a uma base diferente, obtenha a versão correta diretamente da FIAP-TCs e revise o delta antes de adaptar; não substitua o upstream por uma cópia não autorizada. Os patches devem ser reaplicados após cada checkout limpo do submódulo e não devem ser enviados aos repositórios upstream.

`docker-compose.yml` constrói cada aplicação no diretório `services/<service>` e espera o Dockerfile fornecido pelo patch correspondente. A execução completa e as dependências locais estão descritas no README principal.
