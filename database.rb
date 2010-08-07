require 'SQLite3'

module Mondegreen
	class Database		
		def initialize(dbname='mondegreen.database')
			@dbname = dbname
		end
		
		def to_s()
			"Mondegreen database interface around instance: #{@dbname}"
		end
		
		def database()
			SQLite3::Database.new(@dbname)
		end
		
		def random_tapes(n)
			database.execute(SELECT_RANDOM_TAPE, { :n => n })
		end
		
		def create_new_tape(name, description, color, songs)
			db = database
			db.execute(INSERT_TAPE, { :name => name, :description => description, :color => color })
			tape_id = db.get_first_value(SELECT_TAPE_ID, { :tape => name });
			songs.each_with_index do |song, n|
				db.execute(INSERT_SONG, { :code => song[0], :name => song[1].delete('\''), :duration => song[2] })
				song_id = db.get_first_value(SELECT_SONG_ID, { :code => song[0] })
				db.execute(INSERT_PLAY, { :tapeid => tape_id, :songid => song_id, :order => n })
			end
		end
		
		def songs_by_tape(tape)
			database.execute(SELECT_SONGS_BY_TAPE, { :tape => tape })
		end
		
		def tape_info(tape)
			database.get_first_row(SELECT_TAPE_INFO, { :name => tape })
		end
		
		def random_color()
			database.get_first_row(SELECT_RANDOM_COLOR)
		end
		
		private			
			SELECT_RANDOM_TAPE = "select name, color
								  from tape
								  order by random()
								  limit :n;"
			SELECT_TAPE_INFO = "select name, description, color
								from tape where tape.name = :name;"
			SELECT_RANDOM_COLOR = "select value, name
								   from colors
								   order by random()
								   limit 1;"
			SELECT_SONGS_BY_TAPE = "select song.yt_code, song.name, song.duration
									from song
									join play
									on song.id = play.songid
									join tape
									on tape.id = play.tapeid
									where tape.name = :tape
									order by play.[order];"
			INSERT_TAPE = "insert into tape
						   (name, description, color)
						   values
						   (:name, :description, :color);"
			SELECT_TAPE_ID = "select id
							  from tape
							  where name = :tape;"
			INSERT_SONG = "insert into song
						   (yt_code, name, duration)
						   values
						   (:code, :name, :duration);"
			SELECT_SONG_ID = "select id
							  from song
							  where yt_code = :code;"
			INSERT_PLAY = "insert into play
						   (tapeid, songid, [order])
						   values
						   (:tapeid, :songid, :order);"
	end
end