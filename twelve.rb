require 'rubygems'
require 'sinatra'
require 'haml'
require 'net/http'

require 'database'

$yt_url_regex = /(http:\/\/)?(www\.)?youtube\.com\/watch\?v=(.{11})/
$yt_title_regex = /<meta name="title" content="([^>]*)">/

def render_master(head, body)
	@head = head
	@body = body
	haml :master
end

get '/' do
	@tapes = random_tapes 100 
	render_master '', :splash_body
end

get '/create' do
	render_master '', :create_body
end

post '/create' do
	name = params[:name].delete " \t\r\n"
	songs = (1..12).collect do |n|
		params["song_#{n}"] =~ $yt_url_regex
		code = $3
		watch_page = Net::HTTP.get URI.parse("http://www.youtube.com/watch?v=#{code}")
		watch_page =~ $yt_title_regex
		[code, $1]
	end
	create_new_tape(name, params[:description], songs)
	
	redirect "/#{name}", 303 # http://www.gittr.com/index.php/archive/details-of-sinatras-redirect-helper/
end

get '/:name' do
	@songs = songs_by_tape(params[:name])
	render_master :tape_head, :tape_body
end