# Modelo de dados - Memória Urbana Inteligente

O banco foi modelado para representar as ocorrências urbanas registradas pela aplicação e preservar informações necessárias para consultas históricas e administrativas.

## Entidades

- **categoria**: tipos de problema urbano, como alagamento, buraco e iluminação.
- **bairro**: bairros utilizados para agrupamento e análise das ocorrências.
- **usuario_admin**: usuários responsáveis por ações administrativas.
- **ocorrencia**: registro principal do problema urbano.
- **imagem_ocorrencia**: imagens vinculadas a uma ocorrência.
- **historico_status**: histórico das alterações de situação de cada ocorrência.

## Relacionamentos

- Uma categoria pode possuir várias ocorrências.
- Um bairro pode possuir várias ocorrências.
- Uma ocorrência pode possuir várias imagens.
- Uma ocorrência pode possuir vários registros de histórico.
- Um usuário administrativo pode ser responsável por várias alterações de status.

## Diagrama ER

```mermaid
erDiagram
    CATEGORIA ||--o{ OCORRENCIA : classifica
    BAIRRO ||--o{ OCORRENCIA : localiza
    OCORRENCIA ||--o{ IMAGEM_OCORRENCIA : possui
    OCORRENCIA ||--o{ HISTORICO_STATUS : registra
    USUARIO_ADMIN ||--o{ HISTORICO_STATUS : realiza

    CATEGORIA {
        INTEGER id PK
        TEXT nome UK
        INTEGER ativo
    }

    BAIRRO {
        INTEGER id PK
        TEXT nome UK
    }

    USUARIO_ADMIN {
        INTEGER id PK
        TEXT nome
        TEXT login UK
        TEXT senha_hash
        INTEGER ativo
    }

    OCORRENCIA {
        INTEGER id PK
        INTEGER categoria_id FK
        INTEGER bairro_id FK
        TEXT endereco
        TEXT descricao
        REAL latitude
        REAL longitude
        TEXT status
        DATETIME data_hora
    }

    IMAGEM_OCORRENCIA {
        INTEGER id PK
        INTEGER ocorrencia_id FK
        TEXT caminho
        TEXT descricao
    }

    HISTORICO_STATUS {
        INTEGER id PK
        INTEGER ocorrencia_id FK
        INTEGER usuario_admin_id FK
        TEXT status_anterior
        TEXT status_novo
        TEXT observacao
        DATETIME data_alteracao
    }
```

## Restrições principais

- Nomes de categorias e bairros não podem se repetir.
- Login administrativo deve ser único.
- Toda ocorrência deve estar associada a uma categoria e a um bairro existentes.
- Latitude deve estar entre -90 e 90.
- Longitude deve estar entre -180 e 180.
- O status da ocorrência deve ser `Aberta`, `Em análise` ou `Resolvida`.
- Imagens e registros de histórico são removidos automaticamente quando a ocorrência correspondente é excluída.
