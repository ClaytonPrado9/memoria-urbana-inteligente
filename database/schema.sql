PRAGMA foreign_keys = ON;

CREATE TABLE IF NOT EXISTS categoria (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nome TEXT NOT NULL UNIQUE,
    ativo INTEGER NOT NULL DEFAULT 1 CHECK (ativo IN (0, 1))
);

CREATE TABLE IF NOT EXISTS bairro (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nome TEXT NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS usuario_admin (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nome TEXT NOT NULL,
    login TEXT NOT NULL UNIQUE,
    senha_hash TEXT NOT NULL,
    ativo INTEGER NOT NULL DEFAULT 1 CHECK (ativo IN (0, 1))
);

CREATE TABLE IF NOT EXISTS ocorrencia (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    categoria_id INTEGER NOT NULL,
    bairro_id INTEGER NOT NULL,
    endereco TEXT NOT NULL,
    descricao TEXT NOT NULL,
    latitude REAL,
    longitude REAL,
    status TEXT NOT NULL DEFAULT 'Aberta'
        CHECK (status IN ('Aberta', 'Em análise', 'Resolvida')),
    data_hora DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_ocorrencia_categoria
        FOREIGN KEY (categoria_id)
        REFERENCES categoria(id),

    CONSTRAINT fk_ocorrencia_bairro
        FOREIGN KEY (bairro_id)
        REFERENCES bairro(id),

    CONSTRAINT ck_latitude
        CHECK (latitude IS NULL OR (latitude >= -90 AND latitude <= 90)),

    CONSTRAINT ck_longitude
        CHECK (longitude IS NULL OR (longitude >= -180 AND longitude <= 180))
);

CREATE TABLE IF NOT EXISTS imagem_ocorrencia (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    ocorrencia_id INTEGER NOT NULL,
    caminho TEXT NOT NULL,
    descricao TEXT,

    CONSTRAINT fk_imagem_ocorrencia
        FOREIGN KEY (ocorrencia_id)
        REFERENCES ocorrencia(id)
        ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS historico_status (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    ocorrencia_id INTEGER NOT NULL,
    usuario_admin_id INTEGER,
    status_anterior TEXT
        CHECK (status_anterior IS NULL OR status_anterior IN ('Aberta', 'Em análise', 'Resolvida')),
    status_novo TEXT NOT NULL
        CHECK (status_novo IN ('Aberta', 'Em análise', 'Resolvida')),
    observacao TEXT,
    data_alteracao DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_historico_ocorrencia
        FOREIGN KEY (ocorrencia_id)
        REFERENCES ocorrencia(id)
        ON DELETE CASCADE,

    CONSTRAINT fk_historico_usuario
        FOREIGN KEY (usuario_admin_id)
        REFERENCES usuario_admin(id)
        ON DELETE SET NULL
);

CREATE INDEX IF NOT EXISTS idx_ocorrencia_categoria
    ON ocorrencia(categoria_id);

CREATE INDEX IF NOT EXISTS idx_ocorrencia_bairro
    ON ocorrencia(bairro_id);

CREATE INDEX IF NOT EXISTS idx_ocorrencia_status
    ON ocorrencia(status);

CREATE INDEX IF NOT EXISTS idx_ocorrencia_data_hora
    ON ocorrencia(data_hora);
