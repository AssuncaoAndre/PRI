DROP TABLE IF EXISTS games;
DROP TABLE IF EXISTS players;
DROP TABLE IF EXISTS openings;

create table players (

    id INTEGER PRIMARY KEY AUTOINCREMENT,
    irl_name VARCHAR(32),
    online_name VARCHAR(32),
    title VARCHAR(16) NOT NULL,
    bio text

);

create table openings (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    op_name text NOT NULL,
    code varchar(3) NOT NULL,
    pgn_moves text NOT NULL,
    op_description text,
    is_mainline INTEGER DEFAULT 0

);

create table games (

    id INTEGER PRIMARY KEY AUTOINCREMENT,
    game_link VARCHAR(255) NOT NULL,
    white VARCHAR(32) NOT NULL DEFAULT 'Unknown',
    black VARCHAR(32) NOT NULL DEFAULT 'Unknown',
    result INTEGER NOT NULL,
    white_elo INTEGER NOT NULL,
    black_elo INTEGER NOT NULL,
    opening VARCHAR(255) NOT NULL DEFAULT 'Undetermined',
    eco VARCHAR(8)

);