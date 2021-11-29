from os import execlp
import wikipedia
import time
from wikipedia.exceptions import DisambiguationError, PageError, WikipediaException

import sqlite3

con = sqlite3.connect('database.db')
cur = con.cursor()

total = 0
success = 0

with open("gms.txt", encoding='utf-8', errors='ignore') as gms_file:

    content = gms_file.readline()
    

    while content:
        total +=1
        username = content.split(":")[0]
        name = content.split(":")[1]

        player_bio = ""

        try:
            
            #player_bio = wikipedia.summary(name)
            page = wikipedia.page(name)
            
            time.sleep(0.1)

            categories = page.categories

            if "Chess grandmasters" in page.categories:
               player_bio = page.summary
               success +=1
            else:
                
                player_bio = "Player bio not available"   

        except:
            player_bio = "Player bio not available"


        cur.execute("insert into players(irl_name,online_name,title,bio) values (?, ?, ?, ?)", (name,username,"GM",player_bio))
        content = gms_file.readline()


con.commit()
con.close()
