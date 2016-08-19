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

CREATE VIEW players_ranked_v AS
SELECT ROW_NUMBER() OVER (ORDER BY wins DESC) AS rank,
    id,name,wins,num_matches
FROM players_wins_matches_v;

CREATE VIEW swiss_pairs AS
SELECT p1.id AS p1_id, p1.name AS p1_name, p2.id AS p2_id, p2.name AS p2_name
FROM players_ranked_v p1
JOIN players_ranked_v p2
ON p1.rank+1=p2.rank AND p1.rank%2=1;
