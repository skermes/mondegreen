require 'rubygems'
require 'sinatra'
require 'haml'

require 'database'

$yt_url_regex = /(http:\/\/)?(www\.)?youtube\.com\/watch\?v=(.{11})/

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
	song_codes = (1..12).collect do |n|
		params["song_#{n}"] =~ $yt_url_regex
		$3
	end
	create_new_tape(name, params[:description], song_codes)
	
	redirect "/#{name}", 303 # http://www.gittr.com/index.php/archive/details-of-sinatras-redirect-helper/
end

get '/:name' do
	songs_by_tape(params[:name])
end