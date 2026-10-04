# Memória Urbana Inteligente

MVP acadêmico desenvolvido para o Projeto Integrador de Tecnologia da Informação da UFMS.

## Objetivo

Registrar ocorrências urbanas, preservar o histórico e identificar problemas recorrentes por tipo e região.

## Funcionalidades

- Cadastro de ocorrência urbana;
- Seleção de categoria, localização e descrição;
- Anexo opcional de imagem;
- Registro automático de data e hora;
- Exibição em mapa com Leaflet/OpenStreetMap;
- Histórico com filtros por tipo, bairro, situação e período;
- Identificação automática de recorrência por tipo + bairro;
- Área administrativa demonstrativa para atualização da situação;
- Persistência local no navegador usando `localStorage`;
- Interface responsiva e elementos semânticos/acessíveis.

## Tecnologias

- HTML5 semântico;
- CSS3 responsivo;
- Vue 3 via CDN;
- Leaflet + OpenStreetMap;
- JavaScript ES6+;
- localStorage e sessionStorage para persistência de demonstração;
- SQLite e SQL para a modelagem e manipulação relacional desenvolvida no Módulo 3;
- Git e GitHub para controle de versão.

## Banco de dados

A pasta `database/` contém a modelagem e os scripts SQL da atividade do Módulo 3:

- `modelo-dados.md`: entidades, relacionamentos, restrições e diagrama ER;
- `schema.sql`: criação das tabelas, chaves, restrições e índices;
- `seed.sql`: carga inicial de dados baseada nos registros demonstrativos do MVP;
- `crud.sql`: operações de inserção, consulta, atualização e remoção;
- `queries.sql`: consultas de listagem, filtros, histórico e identificação de recorrências.

### Execução com SQLite

Com o SQLite instalado, execute os comandos abaixo na raiz do projeto:

```bash
sqlite3 memoria_urbana.db < database/schema.sql
sqlite3 memoria_urbana.db < database/seed.sql
sqlite3 memoria_urbana.db < database/queries.sql
sqlite3 memoria_urbana.db < database/crud.sql
```

Também é possível abrir o arquivo `memoria_urbana.db` em uma ferramenta gráfica compatível com SQLite e executar os scripts individualmente.

> O frontend atual continua usando `localStorage`, pois é um MVP sem backend. Os scripts SQL representam a evolução da camada de persistência e atendem à etapa de modelagem e manipulação de banco de dados do projeto.

## Como executar a aplicação

A forma mais simples é abrir `index.html` em um navegador com acesso à internet.

Também é possível servir a pasta localmente:

```bash
python -m http.server 8080
```

Depois acesse `http://localhost:8080`.

## Acesso administrativo de demonstração

- Usuário: `admin`
- Senha: `memoria2026`

> A autenticação é apenas uma simulação de MVP. Em produção, deverá ser substituída por autenticação real no backend, com armazenamento seguro de credenciais e controle de acesso.

## Controle de versão

O projeto é versionado com Git e publicado no GitHub. As alterações são registradas em commits descritivos, separando documentação, estrutura do banco, carga de dados, operações CRUD e consultas.

Repositório:

`https://github.com/ClaytonPrado9/memoria-urbana-inteligente`

## Observações de escopo

O MVP usa armazenamento local para permitir demonstração sem servidor. A versão futura prevista no planejamento deve possuir API versionada, integração efetiva com banco de dados e autenticação real, conforme os requisitos não funcionais definidos no projeto.
