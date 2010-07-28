require 'rexml/document'
require 'net/http'

module MondeYoutube
    $yt_url_regex = /(http:\/\/)?(www\.)?youtube\.com\/watch\?v=(.{11})/

    def self.get_song_info(url)
        url =~ $yt_url_regex
        id = $3
    	data = Net::HTTP.get URI.parse("http://gdata.youtube.com/feeds/api/videos/#{id}")
    	doc = REXML::Document.new data
    	{ :title => doc.root.elements['//title'].text, 
          :duration => doc.root.elements['//media:content/@duration'].value.to_i,
          :id => id }
    end
end