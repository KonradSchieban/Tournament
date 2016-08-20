<h1>Tournament</h1>

Version 1.0

Implementation of a Tournament database schema using Postgresql and Python.

<h2>1. Content</h2>
    - Tournament
    |-- tournament.sql
    |-- tournament.py
    |-- tournament_test.py

<h2>2. Prerequisites</h2>
The Python content requires the libraries Bleach and Psycopg installed. Psycopg is a Python library which is used
to connect to Postgresql databases and to execute database queries. The library Bleach offers methods to escape
special characters which are inserted into SQL tables. This is necessary to prevent SQL injections.

For more information on how to setup these libraries, visit the websites
 - http://initd.org/psycopg/docs/install.html
 - https://pypi.python.org/pypi/bleach

<h2>3. How to setup and run</h2>
To run the tournament tests in module tournament_test.py you firs need to define the necessary tables and views.
Connect to postgresql by typing

    > psql

and create the tournament database with the command

    > CREATE DATABASE tournament

Connect to the database with the command

    > \c tournament

Import the tables and views from the file tournament.sql with the command

    > \i tournament.sql

Exit the Postgresql with \q and run the test from the terminal with the command

    > python tournament_test.py

<h2>4. Implementation</h2>

<b>4.1 tournament.sql</b>
    This file contains

<b>4.2. tournament.py</b>











