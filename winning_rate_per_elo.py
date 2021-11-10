from os import sendfile
import sqlite3
import csv
import time
import sys

con = sqlite3.connect('database.db')
cur = con.cursor()
cur.execute('SELECT original_name from original_to_wiki')
exec=cur.fetchall()
for row in exec :
    print("Opening "+row[0])
    for i in range (0,1):
        win=0
        lose=0
        draw=0
        for row2 in cur.execute('SELECT result from games where opening=?',(row[0],)):
            if(row2[0]==0):
                win=win+1
            if(row2[0]==1):
                draw=draw+1
            if(row2[0]==2):
                lose=lose+1

        sum=win+lose+draw
        if(sum!=0):
            print("\t white:{} draw:{} black:{}".format(round(win/sum*100,2),round(draw/sum*100,2),round(lose/sum*100,2)))

con.commit()
con.close()