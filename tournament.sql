-- Table definitions for the tournament project.
--
-- Put your SQL 'create table' statements in this file; also 'create view'
-- statements if you choose to use it.
--
-- You can write comments in this file by starting them with two dashes, like
-- these lines here.
DROP TABLE IF EXISTS players CASCADE;
CREATE TABLE players (id SERIAL PRIMARY KEY,
                     name varchar(50) NOT NULL);


DROP TABLE IF EXISTS matches CASCADE;
CREATE TABLE matches (id SERIAL PRIMARY KEY,
                      winner INTEGER NOT NULL,
                      loser INTEGER NOT NULL);

CREATE VIEW players_matches_v AS
SELECT players.id,name,COUNT(matches.id) AS num_matches
FROM players
LEFT JOIN matches ON players.id=matches.winner OR players.id=matches.loser
GROUP BY players.id,name;

CREATE VIEW players_wins_matches_v AS
SELECT players_matches_v.id,name,COUNT(matches.winner) AS wins, num_matches
FROM players_matches_v
LEFT JOIN matches ON players_matches_v.id=matches.winner
GROUP BY players_matches_v.id,name,matches.winner,num_matches
ORDER BY wins DESC;
