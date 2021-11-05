Create Table original_to_wiki (
original_name text UNIQUE,
wiki_name text
);

Create Table wiki_to_summ (
wiki_name text UNIQUE,
summ text
);