from os import execlp
import wikipedia
import json
import csv
import time
from wikipedia.exceptions import DisambiguationError, PageError, WikipediaException

import sqlite3

con = sqlite3.connect('database.db')
cur = con.cursor()

dict={}

dict_wikipedia={}
for row in cur.execute('SELECT * from original_to_wiki'):
    print(row)
    dict[row[0]]=row[1]

for row in cur.execute('SELECT * from wiki_to_summ'):
    print(row)
    dict_wikipedia[row[0]]='yes'

# opening the CSV file
with open('data/organized/lichess_data_organized_medium.csv', "r")as file:
   
  # reading the CSV file
  reader=csv.DictReader(file)
 
  # displaying the contents of the CSV file
  for row in reader:
        
        flag = 0
        original_name=row['Opening']
        if original_name in dict:
                continue
        if(row['Opening'].find(':')!=-1):
                row['Opening']=row['Opening'][:row['Opening'].find(':')]
        if(row['Opening'] in dict):
                continue

        print (row['Opening'])
        row['Opening']=row['Opening'].replace(';','')
        row['Opening']=row['Opening'].replace('-',' ')
        print("----------"+original_name+"----------")
        exceptions=0
        defense=0
        while 1:
                time.sleep(1.5)
                found=2
                try:          
                        summ=wikipedia.summary(row['Opening'])
                        words=row['Opening'].split()
                        print(words)
                        print(summ)
                        print("\n")
                        for word in words:
                                res=summ.find(word)
                                if(res==-1):
                                        found=found-1
                                        print("couldnt find "+word)
                        if(found>=1):
                                exceptions=0
                                break
                        if(defense==0 and summ.find("defence")==-1 and summ.find("Defence")==-1):
                                row['Opening']=row['Opening'].replace("Defence","Defense")
                                defense=1
                        else:
                                row['Opening']=row['Opening'].replace("Defense","Defence")
                                row['Opening']=row['Opening'][:row['Opening'].rfind(" ")]
                                defense=0
                                
                        
                           
                except PageError:
                        
                        
                        if(defense==0 and summ.find("defence")==-1 and summ.find("Defence")==-1):
                                row['Opening']=row['Opening'].replace("Defence","Defense")
                                defense=1
                        else:
                                row['Opening']=row['Opening'].replace("Defense","Defence")
                                row['Opening']=row['Opening'][:row['Opening'].rfind(" ")]
                                defense=0
                except DisambiguationError as error:
                      

                        print(error.options)
                        row['Opening']=error.options[0]+" "+error.options[0]
                        
                        

                except wikipedia.HTTPTimeoutError:
                        
                        time.sleep(1) 
                except:
                        print("")

                        
        title=wikipedia.page(row['Opening']).title
        print(title)
        print("\n") 

        if original_name not in dict:
                dict[original_name] = title
                cur.execute("insert into original_to_wiki values (?, ?)", (original_name, title)) 
        
        if title not in dict_wikipedia:
                dict_wikipedia[title]='yes'
                cur.execute("insert into wiki_to_summ values (?, ?)", (title, summ))

con.commit()
con.close()
        





