import wikipedia

import csv
 
# opening the CSV file
with open('data/lichess_data_organized_small.csv', )as file:
   
  # reading the CSV file
  reader=csv.DictReader(file)
 
  # displaying the contents of the CSV file
  for row in reader:
        print("----------"+row['Opening']+"----------")
        print(wikipedia.summary(row['Opening'])+" chess")
        print("\n")
       
