import wikipedia
import json
import csv
import time
from wikipedia.exceptions import PageError
from wikipedia.wikipedia import suggest

openings_file=open('openings.txt', 'w')

dict={}

# opening the CSV file
with open('data/organized/lichess_data_organized_medium.csv', "r")as file:
   
  # reading the CSV file
  reader=csv.DictReader(file)
 
  # displaying the contents of the CSV file
  for row in reader:
        flag = 0
        original_name=row['Opening']
        row['Opening']=row['Opening'].replace(':','')
        if(row['Opening'].find(";")!=-1):
                row['Opening']=row['Opening'][:row['Opening'].rfind(";")]
        print("----------"+row['Opening']+"----------")

        time.sleep(1)  
        while(1):
                try: 
                        suggestion=wikipedia.page(row['Opening']).title
                except PageError:
                                row['Opening']=row['Opening'][:row['Opening'].rfind(" ")]
                if(row['Opening'].find(suggestion[:4])!=-1):
                        break
        print(suggestion)
        print("\n") 
        summary=wikipedia.summary(suggestion)
        """ except PageError:
                        row['Opening']=row['Opening'][:row['Opening'].rfind(" ")]
         """
        

        print(summary)
        print("\n") 
        openings_file=open('openings.txt', 'a')
        struct={"original name": original_name, "wiki_name": suggestion}
        openings_file.write(json.dumps(struct))
        openings_file.close()





