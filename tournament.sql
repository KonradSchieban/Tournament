-- Table definitions for the tournament project.

DROP DATABASE IF EXISTS tournament;
CREATE DATABASE tournament;

\c tournament

CREATE TABLE players (
    id SERIAL PRIMARY KEY,
    name varchar(50) NOT NULL
);

CREATE TABLE matches (
    id SERIAL PRIMARY KEY,
    winner INTEGER NOT NULL references players(id),
    loser INTEGER NOT NULL references players(id)
);

-- View which returns player id and name together with the number of matches he played
CREATE VIEW players_matches_v AS
SELECT players.id,name,COUNT(matches.id) AS num_matches
FROM players
LEFT JOIN matches ON players.id=matches.winner OR players.id=matches.loser
GROUP BY players.id,name;

-- View which return player id and name together with his number of wins and matches he played
-- This view is used to create player ranking, ordered by the number of wins
CREATE VIEW players_wins_matches_v AS
SELECT players_matches_v.id,name,COUNT(matches.winner) AS wins, num_matches
FROM players_matches_v
LEFT JOIN matches ON players_matches_v.id=matches.winner
GROUP BY players_matches_v.id,name,matches.winner,num_matches
ORDER BY wins DESC;

-- View which adds the ranking number to th view players_wins_matches_v
CREATE VIEW players_ranked_v AS
SELECT ROW_NUMBER() OVER (ORDER BY wins DESC) AS rank,
    id,name,wins,num_matches
FROM players_wins_matches_v;

-- View which returns all swiss pairs according to the tables "players" and "matches"
-- It is created by self joining the player ranking view "players_ranked_v".
CREATE VIEW swiss_pairs AS
SELECT p1.id AS p1_id, p1.name AS p1_name, p2.id AS p2_id, p2.name AS p2_name
FROM players_ranked_v p1
JOIN players_ranked_v p2
ON p1.rank+1=p2.rank AND p1.rank%2=1;
