# Makefile

# Run ''make'' to execute pipeline
# Run ''make install'' to install necessary packages
# Run ''make clean'' to delete data files

path := data

#URLs to get data from

BASE_URL := "https://database.nikonoel.fr/lichess_elite_2020"

masters1_URL := $(BASE_URL)-08.zip
masters2_URL := $(BASE_URL)-09.zip
masters3_URL := $(BASE_URL)-10.zip

BASE_PGN := "lichess_elite_2020"

masters1_PGN := $(BASE_PGN)-08.pgn
masters2_PGN := $(BASE_PGN)-09.pgn
masters3_PGN := $(BASE_PGN)-10.pgn

recreational_URL := "https://database.lichess.org/standard/lichess_db_standard_rated_2014-01.pgn.bz2"


all: 
	python3 build_db.py #Script that creates the relational schema in the database
	make games
	make openings
	make players

games: recreational.csv masters.csv
	python3 game_to_database.py $(path)/recreational.csv #load recreational games to the database
	python3 game_to_database.py $(path)/masters.csv #load master games to the database

openings:
	python3 openings_to_database.py ./$(path)/openings/a.tsv
	python3 openings_to_database.py ./$(path)/openings/b.tsv
	python3 openings_to_database.py ./$(path)/openings/c.tsv
	python3 openings_to_database.py ./$(path)/openings/d.tsv
	python3 openings_to_database.py ./$(path)/openings/e.tsv
	python3 opening_descriptions.py

players:
	python3 processGMs.py ./data/titles.txt
	python3 getGM_wiki.py


recreational.csv: recreational.txt
	
	#create csv file and add its headers
	echo "gameID,White,Black,Result,WhiteElo,BlackElo,ECO,Opening" > $(path)/recreational.csv
	
	#data processing - this is used to capture from the text files the exact information needed. Also separate each column with ; and each row with ~
	sed -r -e 's/\[Site (.*?)\]/\1;/g' -e 's/\[White (.*?)\]/\1;/g' -e 's/\[Black (.*?)\]/\1;/g' -e 's/\[Result (.*?)\]/\1;/g'  -e 's/\[WhiteElo (.*?)\]/\1;/g'  -e 's/\[BlackElo (.*?)\]/\1;/g'  -e 's/\[ECO (.*?)\]/\1;/g' -e 's/\[Opening (.*?)\]/\1~\n/g' $(path)/recreational.txt > $(path)/recreational1.txt
	
	#remove all newlines from the file
	tr "\n" " " < $(path)/recreational1.txt >>  $(path)/recreational2.txt
	
	#convert information to comma separated values - execute some data processing -
	# substitute Refused with Declined - replace 1-0 for 0, replace 0-1 with 2 and 1/2-1/2 with 1 (WhiteWin-0, BlackWin-2,Draw-1)
	sed -e 's/;/,/g' -e 's/~/\n/g' -e 's/Refused/Declined/g' -e 's/1-0/0/g' -e 's/0-1/2/g' -e 's/1\/2-1\/2/1/g' $(path)/recreational2.txt >> $(path)/recreational.csv
	

recreational.txt: recreationalFetch
	#regular expression to filter relevant information from the PGN (portable game notation) file
	grep -E '\[Site "(.*?)"]|\[White "(.*?)"\]|\[Black "(.*?)"]|\[Result "(.*?)"\]|\[WhiteElo "(.*?)"\]|\[BlackElo "(.*?)"\]|\[ECO "(.*?)"\]|\[Opening "(.*?)"\]' $(path)/games > $(path)/recreational.txt

recreationalFetch: games.bz2
	#extract the downloaded file
	bzip2 -d $(path)/games.bz2
	
games.bz2: $(path)
	#download the file from the web
	curl -L -o $(path)/games.bz2 $(recreational_URL)

masters: masters.csv
	
masters.csv: masters.txt
	#the same as recreational.csv
	
	echo "gameID,White,Black,Result,WhiteElo,BlackElo,ECO,Opening" > $(path)/masters.csv
	sed -r -e 's/\[LichessURL (.*?)\]/\1;/g' -e 's/\[White (.*?)\]/\1;/g' -e 's/\[Black (.*?)\]/\1;/g' -e 's/\[Result (.*?)\]/\1;/g' -e 's/\[WhiteElo (.*?)\]/\1;/g'  -e 's/\[BlackElo (.*?)\]/\1;/g'  -e 's/\[ECO (.*?)\]/\1;/g' -e 's/\[Opening (.*?)\]/\1~\n/g' $(path)/masters.txt > $(path)/masters1.txt
	tr "\n" " " < $(path)/masters1.txt >>  $(path)/masters2.txt
	sed -e 's/;/,/g' -e 's/~/\n/g' -e 's/Refused/Declined/g' -e 's/1-0/0/g' -e 's/0-1/2/g' -e 's/1\/2-1\/2/1/g' $(path)/masters2.txt >> $(path)/masters.csv	


masters.txt: mastersFetch
	
	grep -E '\[LichessURL "(.*?)"]|\[White "(.*?)"\]|\[Black "(.*?)"\]|\[Result "(.*?)"\]|\[WhiteElo "(.*?)"\]|\[BlackElo "(.*?)"\]|\[ECO "(.*?)"\]|\[Opening "(.*?)"\]' $(path)/$(masters1_PGN) > $(path)/masters.txt
	grep -E '\[LichessURL "(.*?)"]|\[White "(.*?)"\]|\[Black "(.*?)"\]|\[Result "(.*?)"\]|\[WhiteElo "(.*?)"\]|\[BlackElo "(.*?)"\]|\[ECO "(.*?)"\]|\[Opening "(.*?)"\]' $(path)/$(masters2_PGN) >> $(path)/masters.txt
	grep -E '\[LichessURL "(.*?)"]|\[White "(.*?)"\]|\[Black "(.*?)"\]|\[Result "(.*?)"\]|\[WhiteElo "(.*?)"\]|\[BlackElo "(.*?)"\]|\[ECO "(.*?)"\]|\[Opening "(.*?)"\]' $(path)/$(masters3_PGN) >> $(path)/masters.txt

	grep -E '\[LichessURL "(.*?)"]|\[White "(.*?)"\]|\[Black "(.*?)"\]|\[WhiteTitle "(.*?)"\]|\[BlackTitle "(.*?)"\]' $(path)/$(masters1_PGN) > $(path)/titles.txt
	grep -E '\[LichessURL "(.*?)"]|\[White "(.*?)"\]|\[Black "(.*?)"\]|\[WhiteTitle "(.*?)"\]|\[BlackTitle "(.*?)"\]' $(path)/$(masters2_PGN) >> $(path)/titles.txt
	grep -E '\[LichessURL "(.*?)"]|\[White "(.*?)"\]|\[Black "(.*?)"\]|\[WhiteTitle "(.*?)"\]|\[BlackTitle "(.*?)"\]' $(path)/$(masters3_PGN) >> $(path)/titles.txt


mastersFetch: masters1.zip masters2.zip masters3.zip
	unzip $(path)/masters1 -d $(path)
	unzip $(path)/masters2 -d $(path)
	unzip $(path)/masters3 -d $(path)

masters1.zip: $(path)
	curl -L -o $(path)/masters1.zip $(masters1_URL)

masters2.zip: $(path)
	curl -L -o $(path)/masters2.zip $(masters2_URL)

masters3.zip: $(path)
	curl -L -o $(path)/masters3.zip $(masters3_URL)
	
	
$(path):
	mkdir $(path)
	


clean:
	#remove unnecessary data
	rm -f ./$(path)/*.zip
	rm -f ./$(path)/*.pgn
	rm -f ./$(path)/*.bz2
	rm -f ./$(path)/*.txt
	rm -f ./$(path)/*.csv
	rm -f ./$(path)/games

# EOF
