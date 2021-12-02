import sqlite3
import csv
import sys

con = sqlite3.connect('database.db')
cur = con.cursor()

with open(sys.argv[1], "r") as file:
    reader=csv.DictReader(file)
    
    for row in reader:
        try:
            cur.execute("insert into games(white, black, result, white_elo, black_elo, opening, eco) values (?, ?, ?, ?, ?, ?, ?)", (row["White"],row["Black"], row["Result"],row["WhiteElo"],row["BlackElo"], row["Opening"],row["ECO"]))
        except:
            print("Empty Line")
con.commit()
con.close()