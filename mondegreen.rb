require 'rubygems'
require 'sinatra'
require 'haml'
require 'net/http'

require 'database'
require 'youtube'

def render_master(head, body)
	@head = head
	@body = body
	@maincolor = MondeBase.random_color
	@maincolor[1] = @maincolor[1].upcase
	
	imgs = Dir.new('public/img').entries
	imgs = imgs[2..imgs.length]
	@backgroundimg = imgs[rand(imgs.length)]
	haml :master
end

get '/' do
	@tapes = MondeBase.random_tapes 100 
	render_master :splash_head, :splash_body
end

get '/create' do	
	@color = MondeBase.random_color[0]
	render_master :create_head, :create_body
end

post '/create' do
	name = params[:name].delete " \t\r\n"
	songs = (1..12).collect do |n|
		info = MondeYoutube.get_song_info params["song_#{n}"]
		[info[:id], info[:title], info[:duration]]
	end
	MondeBase.create_new_tape(name, params[:description], params[:color], songs)
	
	redirect "/#{name}", 303 # http://www.gittr.com/index.php/archive/details-of-sinatras-redirect-helper/
end

get '/random' do
	name = MondeBase.random_tapes(1)[0][0];
	redirect "/#{name}", 303
end

get '/:name' do
	@songs = MondeBase.songs_by_tape(params[:name])
	@info = MondeBase.tape_info(params[:name])
	render_master :tape_head, :tape_body
end
