# Makefile

# Run ''make'' to execute pipeline
# Run ''make install'' to install necessary packages
# Run ''make clean'' to delete data files

path := data1


games := masters.csv recreational.csv

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


all: $(games)
	

	recreational.csv: recreational.txt
	echo "gameID, White, Black, Result, WhiteElo, BlackElo, ECO, Opening" > $(path)/recreational.csv
	sed -r -e 's/\[Site (.*?)\]/\1;/g' -e 's/\[White (.*?)\]/\1;/g' -e 's/\[Black (.*?)\]/\1;/g' -e 's/\[Result (.*?)\]/\1;/g'  -e 's/\[WhiteElo (.*?)\]/\1;/g'  -e 's/\[BlackElo (.*?)\]/\1;/g'  -e 's/\[ECO (.*?)\]/\1;/g' -e 's/\[Opening (.*?)\]/\1~\n/g' $(path)/recreational.txt > $(path)/recreational1.txt
	tr "\n" " " < $(path)/recreational1.txt >>  $(path)/recreational2.txt
	sed -e 's/;/,/g' -e 's/~/\n/g' -e 's/Refused/Declined/g' -e 's/1-0/0/g' -e 's/0-1/2/g' -e 's/1\/2-1\/2/1/g' $(path)/recreational2.txt >> $(path)/recreational.csv	

recreational.txt: recreationalFetch
	grep -E '\[Site "(.*?)"]|\[White "(.*?)"\]|\[Black "(.*?)"]|\[Result "(.*?)"\]|\[WhiteElo "(.*?)"\]|\[BlackElo "(.*?)"\]|\[ECO "(.*?)"\]|\[Opening "(.*?)"\]' $(path)/games > $(path)/recreational.txt

recreationalFetch: games.bz2
	bzip2 -d $(path)/games.bz2
	
games.bz2: $(path)
	curl -L -o $(path)/games.bz2 $(recreational_URL)

masters: masters.csv
	
masters.csv: masters.txt
	echo "gameID, White, Black, Result, WhiteElo, BlackElo, ECO, Opening" > $(path)/masters.csv
	sed -r -e 's/\[LichessURL (.*?)\]/\1;/g' -e 's/\[White (.*?)\]/\1;/g' -e 's/\[Black (.*?)\]/\1;/g' -e 's/\[Result (.*?)\]/\1;/g'  -e 's/\[WhiteElo (.*?)\]/\1;/g'  -e 's/\[BlackElo (.*?)\]/\1;/g'  -e 's/\[ECO (.*?)\]/\1;/g' -e 's/\[Opening (.*?)\]/\1~\n/g' $(path)/masters.txt > $(path)/masters1.txt
	tr "\n" " " < $(path)/masters1.txt >>  $(path)/masters2.txt
	sed -e 's/;/,/g' -e 's/~/\n/g' -e 's/Refused/Declined/g' -e 's/1-0/0/g' -e 's/0-1/2/g' -e 's/1\/2-1\/2/1/g' $(path)/masters2.txt >> $(path)/masters.csv	


masters.txt: mastersFetch
	grep -E '\[LichessURL "(.*?)"]|\[White "(.*?)"\]|\[Black "(.*?)"]|\[Result "(.*?)"\]|\[WhiteElo "(.*?)"\]|\[BlackElo "(.*?)"\]|\[ECO "(.*?)"\]|\[Opening "(.*?)"\]' $(path)/$(masters1_PGN) > $(path)/masters.txt
	grep -E '\[LichessURL "(.*?)"]|\[White "(.*?)"\]|\[Black "(.*?)"]|\[Result "(.*?)"\]|\[WhiteElo "(.*?)"\]|\[BlackElo "(.*?)"\]|\[ECO "(.*?)"\]|\[Opening "(.*?)"\]' $(path)/$(masters2_PGN) >> $(path)/masters.txt
	grep -E '\[LichessURL "(.*?)"]|\[White "(.*?)"\]|\[Black "(.*?)"]|\[Result "(.*?)"\]|\[WhiteElo "(.*?)"\]|\[BlackElo "(.*?)"\]|\[ECO "(.*?)"\]|\[Opening "(.*?)"\]' $(path)/$(masters3_PGN) >> $(path)/masters.txt

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
	rm -f ./$(path)/*.zip
	rm -f ./$(path)/*.pgn
	rm -f ./$(path)/*.bz2
	rm -f ./$(path)/*.txt
	rm -f ./$(path)/games

# EOF