PRAGMA foreign_keys = ON;

INSERT OR IGNORE INTO categoria (id, nome, ativo) VALUES
    (1, 'Iluminação', 1),
    (2, 'Buraco', 1),
    (3, 'Alagamento', 1),
    (4, 'Semáforo', 1),
    (5, 'Calçada', 1);

INSERT OR IGNORE INTO bairro (id, nome) VALUES
    (1, 'Centro'),
    (2, 'Jardim dos Estados');

INSERT OR IGNORE INTO usuario_admin (id, nome, login, senha_hash, ativo) VALUES
    (1, 'Administrador de demonstração', 'admin', 'DEMO_NAO_USAR_EM_PRODUCAO', 1);

INSERT OR IGNORE INTO ocorrencia
    (id, categoria_id, bairro_id, endereco, descricao, latitude, longitude, status, data_hora)
VALUES
    (
        1001, 1, 1,
        'Rua 14 de Julho, próximo à praça',
        'Poste permanece apagado durante a noite e reduz a visibilidade no trecho.',
        -20.4633, -54.6155,
        'Em análise',
        '2026-09-16 19:20:00'
    ),
    (
        1002, 2, 1,
        'Cruzamento da Rua Dom Aquino com via secundária',
        'Buraco de tamanho médio próximo à faixa de rolamento, com aumento após chuvas.',
        -20.4598, -54.6132,
        'Aberta',
        '2026-09-18 08:40:00'
    ),
    (
        1003, 1, 1,
        'Trecho entre duas quadras da região central',
        'Nova ocorrência de falta de iluminação na mesma região, registrada por outro morador.',
        -20.4650, -54.6172,
        'Aberta',
        '2026-09-19 20:10:00'
    ),
    (
        1004, 3, 2,
        'Avenida principal, próximo ao ponto de ônibus',
        'Acúmulo de água durante chuva forte, dificultando a passagem de pedestres.',
        -20.4521, -54.5907,
        'Resolvida',
        '2026-09-14 17:35:00'
    );

INSERT OR IGNORE INTO historico_status
    (id, ocorrencia_id, usuario_admin_id, status_anterior, status_novo, observacao, data_alteracao)
VALUES
    (1, 1001, 1, 'Aberta', 'Em análise', 'Ocorrência encaminhada para análise.', '2026-09-16 20:00:00'),
    (2, 1004, 1, 'Em análise', 'Resolvida', 'Situação marcada como resolvida no MVP.', '2026-09-15 10:30:00');
