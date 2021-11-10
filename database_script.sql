DROP TABLE IF Exists original_to_wiki;
DROP TABLE IF EXISTS wiki_to_summ;
DROP TABLE IF EXISTS games;

create table original_to_wiki (
original_name text UNIQUE,
wiki_name text,
summ text
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