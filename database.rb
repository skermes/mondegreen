require 'SQLite3'

def database()
	SQLite3::Database.new('twelve.database')
end

def random_tapes(n)
	database.execute("select name from tape order by random() limit #{n}").collect { |row| row[0] }
end