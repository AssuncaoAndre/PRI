import sys
import sqlite3



def total_games():
    con = sqlite3.connect('database.db')
    cur = con.cursor()
    return 0

def win_distribuition():
    con = sqlite3.connect('database.db')
    cur = con.cursor()
    return 0

def elo_distribuition():
    con = sqlite3.connect('database.db')
    cur = con.cursor()
    return 0

def opening_distribuition():
    con = sqlite3.connect('database.db')
    cur = con.cursor()
    return 0

def win_distr_popular_openings():
    con = sqlite3.connect('database.db')
    cur = con.cursor()
    return 0


if __name__ == "__main__":
    
    if sys.argv[1] == 0:
        total_games()
        return 0
    
    if sys.argv[1] == 1:
        win_distribuition()
        return 0

    if sys.argv[1] == 2:
        elo_distribuition()
        return 0
    
    if sys.argv[1] == 3:
        
        opening_distribuition()
        return 0

    if sys.argv[1] == 4:
        win_distr_popular_openings()
        return 0
    

