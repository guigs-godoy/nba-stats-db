-- ============================================
-- queries/avancado.sql — Semana 4
-- Conceitos: Subqueries, CTEs, HAVING, VIEWS
-- ============================================


-- ► PARTE 1: HAVING
-- Filtra grupos APÓS o GROUP BY (o WHERE não funciona com agregações)


-- 1. Times com mais de 2 jogadores cadastrados
SELECT t.nome AS time, COUNT(j.id) AS total_jogadores
FROM times t
INNER JOIN jogadores j ON j.id_time = t.id
GROUP BY t.id
HAVING COUNT(j.id) > 2;


-- 2. Jogadores com média de pontos acima de 25
SELECT j.nome AS jogador, ROUND(AVG(e.pontos), 1) AS media_pontos
FROM estatisticas e
INNER JOIN jogadores j ON e.id_jogador = j.id
GROUP BY j.id
HAVING AVG(e.pontos) > 25
ORDER BY media_pontos DESC;


-- 3. Jogadores com pelo menos 2 jogos registrados
SELECT j.nome AS jogador, COUNT(e.id) AS total_jogos
FROM estatisticas e
INNER JOIN jogadores j ON e.id_jogador = j.id
GROUP BY j.id
HAVING COUNT(e.id) >= 2
ORDER BY total_jogos DESC;


-- ► PARTE 2: SUBQUERIES
-- Uma query dentro de outra — resolve problemas em duas etapas


-- 4. Jogadores com pontuação acima da média geral da liga
SELECT j.nome AS jogador, ROUND(AVG(e.pontos), 1) AS media_pontos
FROM estatisticas e
INNER JOIN jogadores j ON e.id_jogador = j.id
GROUP BY j.id
HAVING AVG(e.pontos) > (
    SELECT AVG(pontos) FROM estatisticas
)
ORDER BY media_pontos DESC;


-- 5. Qual foi a maior pontuação individual registrada? Quem fez?
SELECT j.nome AS jogador, e.pontos, p.data_partida
FROM estatisticas e
INNER JOIN jogadores j ON e.id_jogador = j.id
INNER JOIN partidas  p ON e.id_partida  = p.id
WHERE e.pontos = (
    SELECT MAX(pontos) FROM estatisticas
);


-- 6. Jogadores do mesmo time que o LeBron James
SELECT j.nome AS jogador, j.posicao
FROM jogadores j
WHERE j.id_time = (
    SELECT id_time FROM jogadores WHERE nome = 'LeBron James'
)
AND j.nome != 'LeBron James';


-- 7. Times que nunca jogaram como visitante
SELECT t.nome AS time
FROM times t
WHERE t.id NOT IN (
    SELECT id_time_visitante FROM partidas
);


-- ► PARTE 3: CTEs (Common Table Expressions)
-- Cria uma "tabela temporária" com WITH para deixar a query mais legível


-- 8. Top 5 artilheiros usando CTE
WITH artilheiros AS (
    SELECT j.nome AS jogador, SUM(e.pontos) AS total_pontos
    FROM estatisticas e
    INNER JOIN jogadores j ON e.id_jogador = j.id
    GROUP BY j.id
)
SELECT jogador, total_pontos
FROM artilheiros
ORDER BY total_pontos DESC
LIMIT 5;


-- 9. Média da liga e comparação por jogador (usando CTE)
WITH media_liga AS (
    SELECT ROUND(AVG(pontos), 1) AS media
    FROM estatisticas
),
stats_jogadores AS (
    SELECT j.nome AS jogador, ROUND(AVG(e.pontos), 1) AS media_pts
    FROM estatisticas e
    INNER JOIN jogadores j ON e.id_jogador = j.id
    GROUP BY j.id
)
SELECT
    s.jogador,
    s.media_pts,
    m.media AS media_liga,
    CASE
        WHEN s.media_pts > m.media THEN '↑ acima da média'
        WHEN s.media_pts < m.media THEN '↓ abaixo da média'
        ELSE '= na média'
    END AS status
FROM stats_jogadores s, media_liga m
ORDER BY s.media_pts DESC;


-- 10. Duplos-duplos e triplos-duplos por jogador
WITH performances AS (
    SELECT
        e.id_jogador,
        e.id_partida,
        CASE WHEN e.pontos      >= 10 THEN 1 ELSE 0 END AS cat_pts,
        CASE WHEN e.rebotes     >= 10 THEN 1 ELSE 0 END AS cat_reb,
        CASE WHEN e.assistencias >= 10 THEN 1 ELSE 0 END AS cat_ast
    FROM estatisticas e
)
SELECT
    j.nome AS jogador,
    SUM(CASE WHEN (cat_pts + cat_reb + cat_ast) >= 2 THEN 1 ELSE 0 END) AS duplos_duplos,
    SUM(CASE WHEN (cat_pts + cat_reb + cat_ast) >= 3 THEN 1 ELSE 0 END) AS triplos_duplos
FROM performances p
INNER JOIN jogadores j ON p.id_jogador = j.id
GROUP BY j.id
HAVING duplos_duplos > 0
ORDER BY triplos_duplos DESC, duplos_duplos DESC;


-- ► PARTE 4: VIEWS
-- Salva uma query como se fosse uma tabela reutilizável


-- 11. Criar uma view de ranking de artilheiros
CREATE VIEW IF NOT EXISTS vw_artilheiros AS
SELECT
    j.nome                          AS jogador,
    t.nome                          AS time,
    COUNT(e.id)                     AS jogos,
    SUM(e.pontos)                   AS total_pontos,
    ROUND(AVG(e.pontos), 1)        AS media_pontos,
    ROUND(AVG(e.rebotes), 1)       AS media_rebotes,
    ROUND(AVG(e.assistencias), 1)  AS media_assistencias
FROM estatisticas e
INNER JOIN jogadores j ON e.id_jogador = j.id
INNER JOIN times     t ON j.id_time    = t.id
GROUP BY j.id
ORDER BY media_pontos DESC;

-- Após criar a view, use assim:
SELECT * FROM vw_artilheiros;
SELECT * FROM vw_artilheiros WHERE time = 'Los Angeles Lakers';
SELECT * FROM vw_artilheiros LIMIT 5;


-- 12. Criar uma view de resultados de partidas
CREATE VIEW IF NOT EXISTS vw_resultados AS
SELECT
    p.data_partida,
    t_casa.nome                     AS time_casa,
    p.pontos_casa,
    p.pontos_visitante,
    t_visit.nome                    AS time_visitante,
    CASE
        WHEN p.pontos_casa > p.pontos_visitante THEN t_casa.nome
        ELSE t_visit.nome
    END                             AS vencedor,
    ABS(p.pontos_casa - p.pontos_visitante) AS diferenca_pontos
FROM partidas p
INNER JOIN times t_casa  ON p.id_time_casa      = t_casa.id
INNER JOIN times t_visit ON p.id_time_visitante  = t_visit.id
ORDER BY p.data_partida;

-- Após criar a view, use assim:
SELECT * FROM vw_resultados;
SELECT * FROM vw_resultados ORDER BY diferenca_pontos DESC;
