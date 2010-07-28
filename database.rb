require 'SQLite3'

def database()
	SQLite3::Database.new('mondegreen.database')
end

def random_tapes(n)
	database.execute("select name, color from tape order by random() limit #{n};")
end

def create_new_tape(name, description, color, songs)
	db = database
	db.execute("insert into tape (name, description, color) values ('#{name}', '#{description}', '#{color}');")
	tape_id = db.execute("select id from tape where name = '#{name}';")[0][0]	
	songs.each_index do |n|
		db.execute("insert into song (yt_code, name, duration) values ('#{songs[n][0]}', '#{songs[n][1].delete '\''}', #{songs[n][2]});")
		song_id = db.execute("select id from song where yt_code = '#{songs[n][0]}';")[0][0]
		db.execute("insert into play (tapeid, songid, [order]) values (#{tape_id}, #{song_id}, #{n});")
	end
end

def songs_by_tape(tape)
	database.execute("select song.yt_code, song.name, song.duration
					  from song
					  join play
					  on song.id = play.songid
					  join tape
					  on tape.id = play.tapeid
					  where tape.name = '#{tape}'
					  order by play.[order]")
end

def tape_info(tape)
	database.execute("select tape.name, tape.description, tape.color from tape where tape.name = '#{tape}';").flatten
end

def db_random_color()
	database.execute('select value, name from colors order by random() limit 1;')[0]
end