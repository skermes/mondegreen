require 'SQLite3'

def database()
	SQLite3::Database.new('twelve.database')
end

def random_tapes(n)
	database.execute("select name from tape order by random() limit #{n};").collect { |row| row[0] }
end

def create_new_tape(name, description, songs)
	db = database
	db.execute("insert into tape (name, description) values ('#{name}', '#{description}');")
	tape_id = db.execute("select id from tape where name = '#{name}';")[0][0]	
	songs.each_index do |n|
		db.execute("insert into song (yt_code, name) values ('#{songs[n][0]}', '#{songs[n][1].delete '\''}');")
		song_id = db.execute("select id from song where yt_code = '#{songs[n][0]}';")[0][0]
		db.execute("insert into play (tapeid, songid, [order]) values (#{tape_id}, #{song_id}, #{n});")
	end
end

def songs_by_tape(tape)
	database.execute("select song.yt_code 
					  from song
					  join play
					  on song.id = play.songid
					  join tape
					  on tape.id = play.tapeid
					  order by play.[order]").flatten
end