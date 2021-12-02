from os import execlp
import wikipedia
import time
from wikipedia.exceptions import DisambiguationError, PageError, WikipediaException

import sqlite3


def solvePageError(key):
    
    search_query = key
    
    if("Queen's Indian Defense" in key):
        search_query = "Queen s Indian Defence"

    else:
        if("Defense" in key):
            print("Replacing Key Defense to Defence")
            search_query = key.replace("Defense","Defence")
        if("'" in key):
            search_query = key.replace("'","")
            print("Removing ' from key")

    try:
        time.sleep(0.1)

        print("SPE: Looking for " + search_query)
        
        page = wikipedia.page(search_query)
        categories = page.categories

        if "Chess openings" in categories:
            
            print("SPE: Obtained Page for " + search_query)
            
            summ = page.summary
            dict[key] = summ
        else:
            dict[key] = "Undefined Description"
    except:
        dict[key] = "Undefined Description"
        print("Unknown Error for " + key + "Opening ")  



con = sqlite3.connect('database.db')
cur = con.cursor()

dict = {}
sidelines = 0
for row in cur.execute('SELECT op_name from openings'):

    opening = row[0]

    if opening not in dict:

        if ":" in opening:
            opening = row[0].split(":")[0]
            if opening in dict:
                dict[row[0]] = "This is a sideline for " + opening
                sidelines +=1
            else:
                dict[opening] = "-"
        elif len(opening.split(" ")) > 2:
            opening = opening.split(" ")[0] + " " + opening.split(" ")[1]
            if opening in dict:
                dict[row[0]] = "This is a sideline for " + opening
                sidelines +=1
            else:
                dict[opening] = "-"
        else:
            dict[opening] = "-"


print("The system has information about " + str(len(dict)) + "Openings")
print("There are " + str(sidelines) + " sidelines")
print("Looking in wikipedia for a total of " + str((len(dict)-sidelines)) + "main lines")

for key in dict:

    if dict[key] == "-":
        
        try:
            time.sleep(0.1)
            search_query = key
            page = wikipedia.page(search_query)
            categories = page.categories

            if "Chess openings" in categories:
               summ = page.summary
               dict[key] = summ
            else:
                dict[key] = "Undefined Description"
            
        except PageError:
            solvePageError(key)
        except DisambiguationError as error:
            dict[key] = "Undefined Description"
            print("Disambiguation Error for " + key + "Opening ")        
        except wikipedia.HTTPTimeoutError:
            dict[key] = "Undefined Description"
            print("Wikipedia timout Error")
            time.sleep(1) 
        except:
            dict[key] = "Undefined Description"
            print("Unknown Error for " + key + "Opening ")  


for key in dict:
    
    if "This is a sideline for" in dict[key]:
        cur.execute("update openings set op_description=?,is_mainline=0 where op_name = ?", (dict[key], key))
    else:
        cur.execute("update openings set op_description=?,is_mainline=1 where op_name = ?", (dict[key], key))

con.commit()
con.close()

