-- ============================================
-- queries/basico.sql — Semana 1
-- Conceitos: SELECT, WHERE, ORDER BY, LIMIT
-- ============================================


-- 1. Liste todos os times
SELECT * FROM times;


-- 2. Liste todos os jogadores
SELECT nome, posicao FROM jogadores;


-- 3. Quais times são da conferência Oeste?
SELECT nome, cidade
FROM times
WHERE conferencia = 'Oeste';


-- 4. Quais jogadores são da posição Center (C)?
SELECT nome, posicao
FROM jogadores
WHERE posicao = 'C';


-- 5. Liste os jogadores em ordem alfabética
SELECT nome, posicao
FROM jogadores
ORDER BY nome ASC;


-- 6. Quais os 5 jogadores mais altos?
SELECT nome, altura_cm
FROM jogadores
ORDER BY altura_cm DESC
LIMIT 5;


-- 7. Quais os 5 jogadores mais pesados?
SELECT nome, peso_kg
FROM jogadores
ORDER BY peso_kg DESC
LIMIT 5;


-- 8. Quais partidas aconteceram em 2023-10-24?
SELECT *
FROM partidas
WHERE data_partida = '2023-10-24';


-- 9. Quais partidas o time casa fez mais de 115 pontos?
SELECT *
FROM partidas
WHERE pontos_casa > 115;


-- 10. Liste as partidas ordenadas por data
SELECT *
FROM partidas
ORDER BY data_partida ASC;
