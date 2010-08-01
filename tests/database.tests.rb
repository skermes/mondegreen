require '../database'
require 'test/unit'

class TestDatabase < Test::Unit::TestCase
    def setup()
        @database = Mondegreen::Database.new 'mondegreen.tests.database'
    end
    
    def teardown()
        # This lets us insert whatever we like
        # into the database during a test
        # and it'll clean itself up after.
        # Note that it won't protect against 
        # deleting things.
    
        db = @database.database
        tables = db.execute('select [table] from whitelist;').flatten.uniq
        tables.each do |table|
            # Sorry, hack because I didn't give colors an id column
            # and I'm too lazy to fix it now.
            if table == 'colors'
                column = 'name'
            else
                column = 'id'
            end
            db.execute("delete from #{table} 
                        where #{column} not in (select id 
                                                from whitelist 
                                                where [table] = '#{table}');")
        end
    end
    
    def test_random_tapes()
        tapes = @database.random_tapes 2
        assert_equal(tapes.length, 2)
        
        reference = { 'emilyhaines' => '#00FF00',
                      'bluescholars' => '#FF0000' }        
        tapes.each do |tape|
            assert_equal(reference[tape[0]], tape[1])
        end
    end
    
    def test_songs_by_tape()
        songs = @database.songs_by_tape 'emilyhaines'
        assert_equal(['12345678901', 'Metric - Help Im Alive', '123'], songs[0])
        assert_equal(['abcdefghijk', 'Metric - Gold, Guns, Girls', '321'], songs[1])
        assert_equal(['jackdawslov', 'Metric - Succexxy', '213'], songs[2])
    end
    
    def test_tape_info()
        info = @database.tape_info 'bluescholars'
        assert_equal('bluescholars', info[0])
        assert_equal('imma leave how i came screaming covered in blood', info[1])
        assert_equal('#FF0000', info[2])
    end
    
    def test_random_color()
        color = @database.random_color
        reference = { 'red' => '#FF0000',
                      'green' => '#00FF00',
                      'blue' => '#0000FF' }
        assert_equal(reference[color[1]], color[0])
    end
end