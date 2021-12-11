docker exec chess bin/solr create_core -c chess_system
./add_schema.sh
docker exec chess bin/post -c chess_system "players.json"
docker exec chess bin/post -c chess_system "games.json"
docker exec chess bin/post -c chess_system "openings.json"