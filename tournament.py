#!/usr/bin/env python
#
# tournament.py -- implementation of a Swiss-system tournament
#

import psycopg2


def connect():
    """Connect to the PostgreSQL database.  Returns a database connection."""
    try:
        return psycopg2.connect("dbname=tournament")
    except ConnectionError:
        print("Connection to database failed")


def deleteMatches():
    """Remove all the match records from the database."""
    conn = connect()
    c = conn.cursor()
    c.execute("DELETE FROM matches;")
    conn.commit()
    conn.close()


def deletePlayers():
    """Remove all the player records from the database."""
    conn = connect()
    c = conn.cursor()
    c.execute("DELETE FROM players;")
    conn.commit()
    conn.close()


def countPlayers():
    """Returns the number of players currently registered."""
    conn = connect()
    c = conn.cursor()
    c.execute("SELECT COUNT(*) FROM players;")
    result = c.fetchone()
    conn.close()

    return result[0]


def registerPlayer(name):
    """Adds a player to the tournament database.

    The database assigns a unique serial id number for the player.  (This
    should be handled by your SQL database schema, not in your Python code.)

    Args:
      name: the player's full name (need not be unique).
    """

    conn = connect()
    c = conn.cursor()
    query = "INSERT INTO players (name) VALUES (%s);"
    c.execute(query, (name, ))
    conn.commit()
    conn.close()


def playerStandings():
    """Returns a list of the players and their win records, sorted by wins.

    The first entry in the list should be the player in first place, or a player
    tied for first place if there is currently a tie.

    Returns:
      A list of tuples, each of which contains (id, name, wins, matches):
        id: the player's unique id (assigned by the database)
        name: the player's full name (as registered)
        wins: the number of matches the player has won
        matches: the number of matches the player has played
    """

    conn = connect()
    c = conn.cursor()
    c.execute("SELECT id, name, wins, num_matches "
              "FROM players_wins_matches_v;")
    rows = c.fetchall()
    conn.close()

    standings_list = []
    for row in rows:
        standings_list.append(row)

    return standings_list


def reportMatch(winner, loser):
    """Records the outcome of a single match between two players.

    Args:
      winner:  the id number of the player who won
      loser:  the id number of the player who lost
    """

    conn = connect()
    c = conn.cursor()
    query = "INSERT INTO matches (winner, loser) VALUES (%s,%s);"
    c.execute(query, (winner, loser, ))
    conn.commit()
    conn.close()


def swissPairings():
    """Returns a list of pairs of players for the next round of a match.

    Assuming that there are an even number of players registered, each player
    appears exactly once in the pairings.  Each player is paired with another
    player with an equal or nearly-equal win record, that is, a player adjacent
    to him or her in the standings.

    Returns:
      A list of tuples, each of which contains (id1, name1, id2, name2)
        id1: the first player's unique id
        name1: the first player's name
        id2: the second player's unique id
        name2: the second player's name
    """

    swiss_pairs_list = []

    players_standings_list = playerStandings()

    ranking_index = 0
    number_players = countPlayers()
    while ranking_index < number_players:
        player1_details = players_standings_list[ranking_index]
        player2_details = players_standings_list[ranking_index + 1]

        player1_id = player1_details[0]
        player1_name = player1_details[1]
        player2_id = player2_details[0]
        player2_name = player2_details[1]

        swiss_pair = (player1_id, player1_name, player2_id, player2_name)

        swiss_pairs_list.append(swiss_pair)

        ranking_index += 2

    return swiss_pairs_list


class ConnectionError(Exception):

    def __init__(self, message):
        self.message = message
