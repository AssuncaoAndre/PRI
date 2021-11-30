import sqlite3

connection = sqlite3.connect("database.db")
cursor = connection.cursor()
sql_file = open("database_script.sql")
sql_as_string = sql_file.read()
cursor.executescript(sql_as_string)

print("Imported sql base script")