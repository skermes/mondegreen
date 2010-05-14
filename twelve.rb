require 'rubygems'
require 'sinatra'
require 'haml'
require 'net/http'

require 'database'
require 'youtube'

$yt_url_regex = /(http:\/\/)?(www\.)?youtube\.com\/watch\?v=(.{11})/

def render_master(head, body)
	@head = head
	@body = body
	haml :master
end

get '/' do
	@tapes = random_tapes 100 
	render_master :splash_head, :splash_body
end

get '/create' do	
	@color = "hsl(#{rand 360}, 80%, 80%)"
	render_master :create_head, :create_body
end

post '/create' do
	name = params[:name].delete " \t\r\n"
	songs = (1..12).collect do |n|
		params["song_#{n}"] =~ $yt_url_regex
		code = $3
		info = get_song_info(code)
		[code, info[:title], info[:duration]]
	end
	create_new_tape(name, params[:description], params[:color], songs)
	
	redirect "/#{name}", 303 # http://www.gittr.com/index.php/archive/details-of-sinatras-redirect-helper/
end

get '/random' do
	name = random_tapes(1)[0][0];
	redirect "/#{name}", 303
end

get '/:name' do
	@songs = songs_by_tape(params[:name])
	@info = tape_info(params[:name])
	render_master :tape_head, :tape_body
end
