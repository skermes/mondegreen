require 'rexml/document'
require 'net/http'

module MondeYoutube
    def get_song_info(id)
    	data = Net::HTTP.get URI.parse("http://gdata.youtube.com/feeds/api/videos/#{id}")
    	doc = REXML::Document.new data
    	{ :title => doc.root.elements['//title'].text, :duration => doc.root.elements['//media:content/@duration'].value.to_i }
    end
end