-- ============================================
-- queries/intermediario.sql — Semana 2 e 3
-- Conceitos: JOIN, GROUP BY, COUNT, AVG, SUM
-- ============================================


-- ► PARTE 1: JOINs
-- Combina dados de duas ou mais tabelas


-- 1. Liste o nome do jogador e o nome do time dele
SELECT j.nome AS jogador, t.nome AS time
FROM jogadores j
INNER JOIN times t ON j.id_time = t.id;


-- 2. Liste jogadores com o nome do time e a conferência
SELECT j.nome AS jogador, j.posicao, t.nome AS time, t.conferencia
FROM jogadores j
INNER JOIN times t ON j.id_time = t.id
ORDER BY t.conferencia, j.nome;


-- 3. Quais jogadores são do time Los Angeles Lakers?
SELECT j.nome, j.posicao
FROM jogadores j
INNER JOIN times t ON j.id_time = t.id
WHERE t.nome = 'Los Angeles Lakers';


-- 4. Liste as partidas com o nome dos dois times
SELECT
    t_casa.nome       AS time_casa,
    p.pontos_casa,
    p.pontos_visitante,
    t_visit.nome      AS time_visitante,
    p.data_partida
FROM partidas p
INNER JOIN times t_casa  ON p.id_time_casa      = t_casa.id
INNER JOIN times t_visit ON p.id_time_visitante  = t_visit.id
ORDER BY p.data_partida;


-- 5. Quem ganhou cada partida? (time com mais pontos)
SELECT
    t_casa.nome  AS time_casa,
    p.pontos_casa,
    p.pontos_visitante,
    t_visit.nome AS time_visitante,
    CASE
        WHEN p.pontos_casa > p.pontos_visitante THEN t_casa.nome
        ELSE t_visit.nome
    END AS vencedor
FROM partidas p
INNER JOIN times t_casa  ON p.id_time_casa     = t_casa.id
INNER JOIN times t_visit ON p.id_time_visitante = t_visit.id;


-- 6. Liste as estatísticas com o nome do jogador e data da partida
SELECT
    j.nome         AS jogador,
    e.pontos,
    e.rebotes,
    e.assistencias,
    p.data_partida
FROM estatisticas e
INNER JOIN jogadores j ON e.id_jogador = j.id
INNER JOIN partidas  p ON e.id_partida  = p.id
ORDER BY p.data_partida, e.pontos DESC;


-- ► PARTE 2: GROUP BY + Agregações
-- Resume dados em grupos


-- 7. Quantos jogadores tem cada time?
SELECT t.nome AS time, COUNT(j.id) AS total_jogadores
FROM times t
INNER JOIN jogadores j ON j.id_time = t.id
GROUP BY t.id
ORDER BY total_jogadores DESC;


-- 8. Total de pontos por jogador (em todas as partidas)
SELECT j.nome AS jogador, SUM(e.pontos) AS total_pontos
FROM estatisticas e
INNER JOIN jogadores j ON e.id_jogador = j.id
GROUP BY j.id
ORDER BY total_pontos DESC;


-- 9. Média de pontos por jogador
SELECT j.nome AS jogador, ROUND(AVG(e.pontos), 1) AS media_pontos
FROM estatisticas e
INNER JOIN jogadores j ON e.id_jogador = j.id
GROUP BY j.id
ORDER BY media_pontos DESC;


-- 10. Jogador com mais rebotes no total
SELECT j.nome AS jogador, SUM(e.rebotes) AS total_rebotes
FROM estatisticas e
INNER JOIN jogadores j ON e.id_jogador = j.id
GROUP BY j.id
ORDER BY total_rebotes DESC
LIMIT 1;


-- 11. Média de pontos, rebotes e assistências por jogador
SELECT
    j.nome                          AS jogador,
    ROUND(AVG(e.pontos), 1)        AS media_pts,
    ROUND(AVG(e.rebotes), 1)       AS media_reb,
    ROUND(AVG(e.assistencias), 1)  AS media_ast
FROM estatisticas e
INNER JOIN jogadores j ON e.id_jogador = j.id
GROUP BY j.id
ORDER BY media_pts DESC;


-- 12. Quantas partidas cada time jogou como mandante?
SELECT t.nome AS time, COUNT(p.id) AS jogos_em_casa
FROM partidas p
INNER JOIN times t ON p.id_time_casa = t.id
GROUP BY t.id
ORDER BY jogos_em_casa DESC;


-- 13. Total de pontos marcados por conferência
SELECT t.conferencia, SUM(e.pontos) AS total_pontos
FROM estatisticas e
INNER JOIN jogadores j ON e.id_jogador = j.id
INNER JOIN times     t ON j.id_time    = t.id
GROUP BY t.conferencia;


-- 14. Jogadores que fizeram duplo-duplo (10+ pontos E 10+ rebotes)
SELECT j.nome AS jogador, e.pontos, e.rebotes, p.data_partida
FROM estatisticas e
INNER JOIN jogadores j ON e.id_jogador = j.id
INNER JOIN partidas  p ON e.id_partida  = p.id
WHERE e.pontos >= 10 AND e.rebotes >= 10;
