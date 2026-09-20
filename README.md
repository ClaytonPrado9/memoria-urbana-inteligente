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
- localStorage e sessionStorage para persistência de demonstração.

## Como executar

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

## Observações de escopo

O MVP usa armazenamento local para permitir demonstração sem servidor. A versão futura prevista no planejamento deve possuir API versionada, banco de dados e autenticação real, conforme os requisitos não funcionais definidos no projeto.
