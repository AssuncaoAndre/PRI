 
FROM solr:8.10

COPY players.json players.json

COPY openings.json openings.json

COPY games.json games.json

COPY schema.json schema.json

#ENTRYPOINT ["/scripts/startup.sh"]
