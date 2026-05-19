"""
seed.py — Popula o banco nba_stats.db com dados de exemplo.
Execute: python seed.py
"""

import sqlite3
import os

DB_PATH = "nba_stats.db"
SCHEMA_PATH = "schema.sql"


def criar_banco():
    """Cria o banco e as tabelas a partir do schema.sql."""
    with open(SCHEMA_PATH, "r", encoding="utf-8") as f:
        schema = f.read()

    conn = sqlite3.connect(DB_PATH)
    conn.executescript(schema)
    conn.commit()
    print("✅ Banco criado com sucesso!")
    return conn


def inserir_times(conn):
    times = [
        ("Los Angeles Lakers",    "LAL", "Los Angeles",   "Oeste", "Pacífico"),
        ("Golden State Warriors", "GSW", "San Francisco", "Oeste", "Pacífico"),
        ("Boston Celtics",        "BOS", "Boston",        "Leste",  "Atlântico"),
        ("Miami Heat",            "MIA", "Miami",         "Leste",  "Sudeste"),
        ("Denver Nuggets",        "DEN", "Denver",        "Oeste", "Noroeste"),
        ("Phoenix Suns",          "PHX", "Phoenix",       "Oeste", "Pacífico"),
        ("Milwaukee Bucks",       "MIL", "Milwaukee",     "Leste",  "Central"),
        ("Philadelphia 76ers",    "PHI", "Philadelphia",  "Leste",  "Atlântico"),
    ]
    conn.executemany(
        "INSERT INTO times (nome, sigla, cidade, conferencia, divisao) VALUES (?,?,?,?,?)",
        times
    )
    conn.commit()
    print(f"✅ {len(times)} times inseridos!")


def inserir_temporada(conn):
    conn.execute(
        "INSERT INTO temporadas (ano_inicio, ano_fim) VALUES (?,?)",
        (2023, 2024)
    )
    conn.commit()
    print("✅ Temporada 2023-24 inserida!")


def inserir_jogadores(conn):
    # (nome, posicao, altura_cm, peso_kg, id_time)
    jogadores = [
        # Lakers (id=1)
        ("LeBron James",       "SF", 206, 113.4, 1),
        ("Anthony Davis",      "C",  208, 114.8, 1),
        ("Austin Reaves",      "SG", 196,  90.7, 1),
        # Warriors (id=2)
        ("Stephen Curry",      "PG", 188,  83.9, 2),
        ("Klay Thompson",      "SG", 198,  98.4, 2),
        ("Draymond Green",     "PF", 198, 104.3, 2),
        # Celtics (id=3)
        ("Jayson Tatum",       "SF", 203,  95.3, 3),
        ("Jaylen Brown",       "SG", 198,  101.2, 3),
        ("Al Horford",         "C",  208, 109.8, 3),
        # Heat (id=4)
        ("Jimmy Butler",       "SF", 201,  104.3, 4),
        ("Bam Adebayo",        "C",  208,  115.7, 4),
        # Nuggets (id=5)
        ("Nikola Jokic",       "C",  211,  128.8, 5),
        ("Jamal Murray",       "PG", 193,   95.3, 5),
        # Suns (id=6)
        ("Kevin Durant",       "SF", 208,  109.3, 6),
        ("Devin Booker",       "SG", 196,   95.3, 6),
        # Bucks (id=7)
        ("Giannis Antetokounmpo", "PF", 211, 109.8, 7),
        ("Damian Lillard",     "PG", 188,   88.5, 7),
        # 76ers (id=8)
        ("Joel Embiid",        "C",  213,  127.0, 8),
        ("Tyrese Maxey",       "PG", 188,   82.6, 8),
    ]
    conn.executemany(
        "INSERT INTO jogadores (nome, posicao, altura_cm, peso_kg, id_time) VALUES (?,?,?,?,?)",
        jogadores
    )
    conn.commit()
    print(f"✅ {len(jogadores)} jogadores inseridos!")


def inserir_partidas_e_stats(conn):
    """Insere partidas de exemplo com estatísticas."""
    partidas = [
        # (id_time_casa, id_time_visitante, data, id_temporada, pts_casa, pts_visit)
        (1, 2, "2023-10-24", 1, 108, 119),  # Lakers vs Warriors
        (3, 4, "2023-10-24", 1, 126, 120),  # Celtics vs Heat
        (5, 6, "2023-10-25", 1, 115, 110),  # Nuggets vs Suns
        (7, 8, "2023-10-25", 1, 118, 107),  # Bucks vs 76ers
        (2, 3, "2023-10-27", 1, 104, 121),  # Warriors vs Celtics
        (1, 5, "2023-10-28", 1, 114, 121),  # Lakers vs Nuggets
    ]
    conn.executemany(
        """INSERT INTO partidas
           (id_time_casa, id_time_visitante, data_partida, id_temporada, pontos_casa, pontos_visitante)
           VALUES (?,?,?,?,?,?)""",
        partidas
    )
    conn.commit()
    print(f"✅ {len(partidas)} partidas inseridas!")

    # Estatísticas por jogador por partida
    # (id_jogador, id_partida, pontos, rebotes, assistencias, roubos, bloqueios, minutos)
    stats = [
        # Partida 1: Lakers(1) vs Warriors(2)
        (1,  1, 28,  8, 7, 1, 1, 35.0),   # LeBron
        (2,  1, 22, 12, 3, 0, 3, 32.0),   # Davis
        (3,  1, 14,  4, 5, 2, 0, 30.0),   # Reaves
        (4,  1, 31,  5, 8, 2, 0, 36.0),   # Curry
        (5,  1, 24,  5, 3, 1, 0, 34.0),   # Klay
        (6,  1,  8, 10, 7, 2, 1, 28.0),   # Draymond
        # Partida 2: Celtics(3) vs Heat(4)
        (7,  2, 32,  8, 4, 1, 0, 36.0),   # Tatum
        (8,  2, 28,  6, 3, 2, 0, 34.0),   # Brown
        (9,  2, 10,  9, 2, 0, 2, 28.0),   # Horford
        (10, 2, 24,  7, 5, 2, 0, 35.0),   # Butler
        (11, 2, 18, 11, 3, 1, 2, 32.0),   # Adebayo
        # Partida 3: Nuggets(5) vs Suns(6)
        (12, 3, 30, 14, 9, 1, 2, 35.0),   # Jokic
        (13, 3, 22,  4, 7, 2, 0, 33.0),   # Murray
        (14, 3, 27,  6, 3, 1, 1, 34.0),   # Durant
        (15, 3, 22,  5, 4, 2, 0, 33.0),   # Booker
        # Partida 4: Bucks(7) vs 76ers(8)
        (16, 4, 35, 12, 6, 2, 2, 36.0),   # Giannis
        (17, 4, 21,  4, 8, 1, 0, 34.0),   # Lillard
        (18, 4, 29, 10, 3, 1, 4, 35.0),   # Embiid
        (19, 4, 18,  3, 6, 2, 0, 32.0),   # Maxey
        # Partida 5: Warriors(2) vs Celtics(3)
        (4,  5, 27,  4, 9, 3, 0, 36.0),   # Curry
        (5,  5, 18,  4, 2, 1, 0, 32.0),   # Klay
        (7,  5, 35,  9, 5, 2, 1, 38.0),   # Tatum
        (8,  5, 29,  5, 4, 3, 0, 36.0),   # Brown
        # Partida 6: Lakers(1) vs Nuggets(5)
        (1,  6, 31,  7, 9, 2, 1, 37.0),   # LeBron
        (2,  6, 18, 13, 2, 0, 4, 33.0),   # Davis
        (12, 6, 28, 15, 8, 2, 3, 36.0),   # Jokic
        (13, 6, 24,  5, 6, 1, 0, 34.0),   # Murray
    ]
    conn.executemany(
        """INSERT INTO estatisticas
           (id_jogador, id_partida, pontos, rebotes, assistencias, roubos, bloqueios, minutos)
           VALUES (?,?,?,?,?,?,?,?)""",
        stats
    )
    conn.commit()
    print(f"✅ {len(stats)} registros de estatísticas inseridos!")


def verificar(conn):
    """Exibe um resumo do que foi inserido."""
    print("\n📊 Resumo do banco:")
    for tabela in ["times", "jogadores", "temporadas", "partidas", "estatisticas"]:
        count = conn.execute(f"SELECT COUNT(*) FROM {tabela}").fetchone()[0]
        print(f"   {tabela:<15} → {count} registros")


def main():
    if os.path.exists(DB_PATH):
        os.remove(DB_PATH)
        print(f"🗑️  Banco anterior removido.")

    conn = criar_banco()
    inserir_times(conn)
    inserir_temporada(conn)
    inserir_jogadores(conn)
    inserir_partidas_e_stats(conn)
    verificar(conn)
    conn.close()
    print(f"\n🏀 Banco '{DB_PATH}' pronto para uso!")


if __name__ == "__main__":
    main()
