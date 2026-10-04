PRAGMA foreign_keys = ON;

-- =========================================================
-- CREATE - inserção de uma nova ocorrência
-- =========================================================
INSERT INTO ocorrencia
    (categoria_id, bairro_id, endereco, descricao, latitude, longitude, status, data_hora)
VALUES
    (
        5,
        1,
        'Rua de demonstração, 100',
        'Trecho de calçada danificado utilizado para demonstrar uma operação de inserção.',
        -20.4680,
        -54.6200,
        'Aberta',
        CURRENT_TIMESTAMP
    );

-- =========================================================
-- READ - consulta do registro recém-inserido
-- =========================================================
SELECT
    o.id,
    c.nome AS categoria,
    b.nome AS bairro,
    o.endereco,
    o.descricao,
    o.status,
    o.data_hora
FROM ocorrencia o
JOIN categoria c ON c.id = o.categoria_id
JOIN bairro b ON b.id = o.bairro_id
WHERE o.id = (SELECT MAX(id) FROM ocorrencia);

-- =========================================================
-- UPDATE - alteração do status
-- =========================================================
UPDATE ocorrencia
SET status = 'Em análise'
WHERE id = (SELECT MAX(id) FROM ocorrencia);

INSERT INTO historico_status
    (ocorrencia_id, usuario_admin_id, status_anterior, status_novo, observacao)
VALUES
    (
        (SELECT MAX(id) FROM ocorrencia),
        1,
        'Aberta',
        'Em análise',
        'Alteração realizada pelo script de demonstração CRUD.'
    );

-- Conferência após atualização.
SELECT id, status
FROM ocorrencia
WHERE id = (SELECT MAX(id) FROM ocorrencia);

-- =========================================================
-- DELETE - remoção da ocorrência de demonstração
-- O histórico vinculado é removido por ON DELETE CASCADE.
-- =========================================================
DELETE FROM ocorrencia
WHERE id = (SELECT MAX(id) FROM ocorrencia);

-- Conferência final: a consulta deve retornar zero linhas para o
-- registro que foi removido.
SELECT *
FROM ocorrencia
WHERE endereco = 'Rua de demonstração, 100';
