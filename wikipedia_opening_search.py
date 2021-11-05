import wikipedia
import json
import csv
import time
from wikipedia.exceptions import DisambiguationError, PageError, WikipediaException


openings_file=open('opening_name_to_wikipedia.txt', 'w')
openings_file.write("original_name, wikipedia_title\n")
opening_to_summary=open('opening_to_summary.txt', 'w')
dict={}

# opening the CSV file
with open('data/organized/lichess_data_organized_medium.csv', "r")as file:
   
  # reading the CSV file
  reader=csv.DictReader(file)
 
  # displaying the contents of the CSV file
  for row in reader:
        flag = 0
        original_name=row['Opening']
        if(row['Opening'].find(':')!=-1):
                row['Opening']=row['Opening'][:row['Opening'].find(':')]
        if(row['Opening'] in dict):
                continue
        """ row['Opening']=row['Opening'].replace(':','') """
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
                        print("fuck3")
                        
                        if(defense==0 and summ.find("defence")==-1 and summ.find("Defence")==-1):
                                row['Opening']=row['Opening'].replace("Defence","Defense")
                                defense=1
                        else:
                                row['Opening']=row['Opening'].replace("Defense","Defence")
                                row['Opening']=row['Opening'][:row['Opening'].rfind(" ")]
                                defense=0
                except DisambiguationError as error:
                        print("fuck2")

                        print(error.options)
                        row['Opening']=error.options[0]+" "+error.options[0]
                        
                        

                except wikipedia.HTTPTimeoutError:
                        print("fuck1")
                        time.sleep(1) 
                except:
                        print("fuck50")

                        
        title=wikipedia.page(row['Opening']).title
        print(title)
        print("\n") 
        openings_file=open('opening_name_to_wikipedia.txt', 'a')
        opening_to_summary=open('opening_to_summary.txt', 'a')
        dict[original_name] = title
        
        struct2={"wikipedia_title": title, "summary":summ}
        openings_file.write(original_name+", "+title+"\n")

        opening_to_summary.write(title+", "+summ+"\n")
        openings_file.close()
        opening_to_summary.close()
        





