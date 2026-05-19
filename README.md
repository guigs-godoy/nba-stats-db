# 🏀 NBA Stats DB

Projeto de portfólio para estudo de SQL com dados da NBA.
Banco de dados relacional da NBA construído do zero com SQLite e Python.
Do SELECT básico até CTEs, subqueries e views — tudo com dados reais.
</div>

💡 Sobre o projeto

Iniciei este projeto com o intuito em desenvolver e me aprofundar conhecimentos em SQL e modelagem de banco de dados relacional, usando a NBA como tema por eu gostar muito de basquete — além disso, pensei na possibilidade de ter uma das estruturas de dados legais para entender e aprender: times, jogadores, partidas e estatísticas e como elas podem se conectar e relacionar.
O banco foi construído do zero: modelagem das tabelas, script de seed em Python com dados reais e queries progressivas organizadas por nível de complexidade.



## 🗄️ Modelo de Dados

┌──────────┐        ┌────────────┐
│  times   │◄───────│  jogadores │
└──────────┘        └─────┬──────┘
     │                    │
     │              ┌─────▼──────┐
     ▼              │estatisticas│
┌──────────┐        └─────┬──────┘
│ partidas │◄─────────────┘
└──────────┘
     ▲
     │
┌────┴─────┐
│temporadas│
└──────────┘

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

## 🛠️ Tecnologias & Ferramentas

- SQLite 3
- Python 3 (sqlite3)
- DB Browser for SQLite

## 📚 Conceitos SQL Praticados

- `SELECT`, `WHERE`, `ORDER BY`, `LIMIT`
- `INNER JOIN`, `LEFT JOIN`
- `GROUP BY`, `COUNT`, `AVG`, `SUM`, `MAX`
- Subqueries e CTEs (`WITH`)
- `VIEWS` e índices
