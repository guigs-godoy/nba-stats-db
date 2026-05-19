-- ============================================
-- NBA Stats DB - Schema
-- Projeto de portfólio para estudo de SQL
-- ============================================

-- Times da NBA
CREATE TABLE IF NOT EXISTS times (
    id          INTEGER PRIMARY KEY AUTOINCREMENT,
    nome        TEXT NOT NULL,
    sigla       TEXT NOT NULL,       -- ex: LAL, GSW, BOS
    cidade      TEXT NOT NULL,
    conferencia TEXT NOT NULL,       -- 'Leste' ou 'Oeste'
    divisao     TEXT NOT NULL        -- ex: Atlântico, Pacífico...
);

-- Jogadores
CREATE TABLE IF NOT EXISTS jogadores (
    id        INTEGER PRIMARY KEY AUTOINCREMENT,
    nome      TEXT NOT NULL,
    posicao   TEXT NOT NULL,         -- PG, SG, SF, PF, C
    altura_cm INTEGER,
    peso_kg   REAL,
    id_time   INTEGER REFERENCES times(id)
);

-- Temporadas
CREATE TABLE IF NOT EXISTS temporadas (
    id         INTEGER PRIMARY KEY AUTOINCREMENT,
    ano_inicio INTEGER NOT NULL,
    ano_fim    INTEGER NOT NULL
);

-- Partidas
CREATE TABLE IF NOT EXISTS partidas (
    id                 INTEGER PRIMARY KEY AUTOINCREMENT,
    id_time_casa       INTEGER NOT NULL REFERENCES times(id),
    id_time_visitante  INTEGER NOT NULL REFERENCES times(id),
    data_partida       TEXT NOT NULL,   -- formato: YYYY-MM-DD
    id_temporada       INTEGER NOT NULL REFERENCES temporadas(id),
    pontos_casa        INTEGER,
    pontos_visitante   INTEGER
);

-- Estatísticas por jogo por jogador
CREATE TABLE IF NOT EXISTS estatisticas (
    id          INTEGER PRIMARY KEY AUTOINCREMENT,
    id_jogador  INTEGER NOT NULL REFERENCES jogadores(id),
    id_partida  INTEGER NOT NULL REFERENCES partidas(id),
    pontos      INTEGER DEFAULT 0,
    rebotes     INTEGER DEFAULT 0,
    assistencias INTEGER DEFAULT 0,
    roubos      INTEGER DEFAULT 0,
    bloqueios   INTEGER DEFAULT 0,
    minutos     REAL DEFAULT 0
);
