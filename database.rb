require 'SQLite3'

def database()
	SQLite3::Database.new('twelve.database')
end

def random_tapes(n)
	database.execute("select name from tape order by random() limit #{n};").collect { |row| row[0] }
end

def create_new_tape(name, description, song_codes)
	db = database
	db.execute("insert into tape (name, description) values ('#{name}', '#{description}');")
	tape_id = db.execute("select id from tape where name = '#{name}';")[0][0]
	puts song_codes
	song_codes.each_index do |n|
		db.execute("insert into song (yt_code) values ('#{song_codes[n]}');")
		song_id = db.execute("select id from song where yt_code = '#{song_codes[n]}';")[0][0]
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