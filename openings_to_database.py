import sqlite3
import csv
import sys

con = sqlite3.connect('database.db')
cur = con.cursor()

with open(sys.argv[1], "r") as file:
    reader=csv.DictReader(file,delimiter="\t")
    for row in reader:
        cur.execute("insert into openings(op_name, code, pgn_moves) values (?, ?, ?)", (row["name"],row["eco"],row["pgn"]))
con.commit()
con.close()