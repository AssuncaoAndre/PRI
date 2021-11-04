install:
	sudo apt install npm
	

recreational:
	curl -L -o games.bz2 https://database.lichess.org/standard/lichess_db_standard_rated_2014-01.pgn.bz2
	bzip2 -d games.bz2
	
	

masters:
	curl -L -o masters1.zip https://database.nikonoel.fr/lichess_elite_2020-10.zip
	curl -L -o masters2.zip https://database.nikonoel.fr/lichess_elite_2020-09.zip
	curl -L -o masters3.zip https://database.nikonoel.fr/lichess_elite_2020-08.zip
	unzip masters1
	unzip masters2
	unzip masters3
	grep -E '\[LichessURL "(.*?)"]|\[White "(.*?)"\]|\[Black "(.*?)"]|\[Result "(.*?)"\]|\[WhiteElo "(.*?)"\]|\[BlackElo "(.*?)"\]|\[ECO "(.*?)"\]|\[Opening "(.*?)"\]' lichess_elite_2020-08.pgn > masters.txt
	grep -E '\[LichessURL "(.*?)"]|\[White "(.*?)"\]|\[Black "(.*?)"]|\[Result "(.*?)"\]|\[WhiteElo "(.*?)"\]|\[BlackElo "(.*?)"\]|\[ECO "(.*?)"\]|\[Opening "(.*?)"\]' lichess_elite_2020-09.pgn >> masters.txt
	grep -E '\[LichessURL "(.*?)"]|\[White "(.*?)"\]|\[Black "(.*?)"]|\[Result "(.*?)"\]|\[WhiteElo "(.*?)"\]|\[BlackElo "(.*?)"\]|\[ECO "(.*?)"\]|\[Opening "(.*?)"\]' lichess_elite_2020-10.pgn >> masters.txt
	echo "gameID, White, Black, Result, WhiteElo, BlackElo, ECO, Opening" > masters.csv
	
	sed -r -e 's/\[LichessURL (.*?)\]/\1;/g' -e 's/\[White (.*?)\]/\1;/g' -e 's/\[Black (.*?)\]/\1;/g' -e 's/\[Result (.*?)\]/\1;/g'  -e 's/\[WhiteElo (.*?)\]/\1;/g'  -e 's/\[BlackElo (.*?)\]/\1;/g'  -e 's/\[ECO (.*?)\]/\1;/g' -e 's/\[Opening (.*?)\]/\1~\n/g' masters.txt > masters1.txt
	tr "\n" " " < masters1.txt >>  masters2.txt
	sed -e 's/;/,/g' -e 's/~/\n/g' masters2.txt >> masters.csv 
	
		



clean:
	rm -f *.zip
	rm -f *.pgn
	rm -f *.bz2
	rm -f *.txt