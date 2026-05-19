# 🏀 NBA Stats DB
<div align="center">
https://img.shields.io/badge/SQLite-003B57?style=for-the-badge&logo=sqlite&logoColor=white
https://img.shields.io/badge/Python-3776AB?style=for-the-badge&logo=python&logoColor=white
https://img.shields.io/badge/status-conclu%C3%ADdo-1D9E75?style=for-the-badge

Projeto de portfólio para estudo de SQL com dados da NBA.
Banco de dados SQLite com times, jogadores, partidas e estatísticas.

## 📁 Estrutura

```
nba-stats-db/
├── schema.sql          ← criação das tabelas
├── seed.py             ← popula o banco com dados de exemplo
├── nba_stats.db        ← banco gerado (após rodar seed.py)
├── queries/
│   ├── basico.sql      ← SELECT, WHERE, ORDER BY, LIMIT
│   ├── intermediario.sql ← JOINs, GROUP BY, agregações
│   └── avancado.sql    ← CTEs, subqueries, VIEWS
└── README.md
```

## 🚀 Como rodar

**Pré-requisitos:** Python 3.x instalado

```bash
# 1. Clone o repositório
git clone https://github.com/seu-usuario/nba-stats-db.git
cd nba-stats-db

# 2. Gere o banco de dados
python seed.py

# 3. Abra com DB Browser for SQLite (recomendado)
# Ou use a linha de comando:
sqlite3 nba_stats.db
```

## 🗄️ Modelo de Dados

```
times ──────────────── jogadores
  │                        │
  │                        │
partidas ────────── estatisticas
  │
temporadas
```

| Tabela | Descrição |
|--------|-----------|
| `times` | 8 times da NBA com conferência e divisão |
| `jogadores` | 19 jogadores com posição, altura e peso |
| `temporadas` | Temporada 2023-24 |
| `partidas` | 6 partidas com placar |
| `estatisticas` | Stats por jogador por partida |

## 📝 Exemplos de Queries

**Times do Oeste:**
```sql
SELECT nome, cidade FROM times WHERE conferencia = 'Oeste';
```

**Top artilheiros:**
```sql
SELECT j.nome, SUM(e.pontos) AS total_pontos
FROM estatisticas e
JOIN jogadores j ON e.id_jogador = j.id
GROUP BY j.id
ORDER BY total_pontos DESC
LIMIT 5;
```

## 🛠️ Tecnologias

- SQLite 3
- Python 3 (sqlite3)
- DB Browser for SQLite

## 📚 Conceitos SQL Praticados

- `SELECT`, `WHERE`, `ORDER BY`, `LIMIT`
- `INNER JOIN`, `LEFT JOIN`
- `GROUP BY`, `COUNT`, `AVG`, `SUM`, `MAX`
- Subqueries e CTEs (`WITH`)
- `VIEWS` e índices
