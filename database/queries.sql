PRAGMA foreign_keys = ON;

-- 1. Lista completa de ocorrências com categoria e bairro.
SELECT
    o.id,
    c.nome AS categoria,
    b.nome AS bairro,
    o.endereco,
    o.status,
    o.data_hora
FROM ocorrencia o
JOIN categoria c ON c.id = o.categoria_id
JOIN bairro b ON b.id = o.bairro_id
ORDER BY o.data_hora DESC;

-- 2. Quantidade de ocorrências por status.
SELECT
    status,
    COUNT(*) AS quantidade
FROM ocorrencia
GROUP BY status
ORDER BY quantidade DESC;

-- 3. Problemas recorrentes por categoria e bairro.
-- A mesma combinação com duas ou mais ocorrências é considerada recorrente.
SELECT
    c.nome AS categoria,
    b.nome AS bairro,
    COUNT(*) AS quantidade
FROM ocorrencia o
JOIN categoria c ON c.id = o.categoria_id
JOIN bairro b ON b.id = o.bairro_id
GROUP BY c.id, c.nome, b.id, b.nome
HAVING COUNT(*) >= 2
ORDER BY quantidade DESC, categoria, bairro;

-- 4. Ocorrências em aberto ou em análise.
SELECT
    o.id,
    c.nome AS categoria,
    b.nome AS bairro,
    o.endereco,
    o.status
FROM ocorrencia o
JOIN categoria c ON c.id = o.categoria_id
JOIN bairro b ON b.id = o.bairro_id
WHERE o.status IN ('Aberta', 'Em análise')
ORDER BY o.data_hora DESC;

-- 5. Consulta por período.
SELECT
    o.id,
    c.nome AS categoria,
    b.nome AS bairro,
    o.status,
    o.data_hora
FROM ocorrencia o
JOIN categoria c ON c.id = o.categoria_id
JOIN bairro b ON b.id = o.bairro_id
WHERE DATE(o.data_hora) BETWEEN DATE('2026-09-14') AND DATE('2026-09-30')
ORDER BY o.data_hora;

-- 6. Histórico de alterações de situação.
SELECT
    h.id,
    h.ocorrencia_id,
    h.status_anterior,
    h.status_novo,
    h.observacao,
    h.data_alteracao,
    u.nome AS alterado_por
FROM historico_status h
LEFT JOIN usuario_admin u ON u.id = h.usuario_admin_id
ORDER BY h.data_alteracao DESC;

-- 7. Quantidade de ocorrências por bairro.
SELECT
    b.nome AS bairro,
    COUNT(o.id) AS total_ocorrencias
FROM bairro b
LEFT JOIN ocorrencia o ON o.bairro_id = b.id
GROUP BY b.id, b.nome
ORDER BY total_ocorrencias DESC, bairro;
