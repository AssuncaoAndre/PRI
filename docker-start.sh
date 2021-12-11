docker build . -t chess_solr
docker run --name chess -p 8983:8983 chess_solr