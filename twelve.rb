require 'rubygems'
require 'sinatra'
require 'haml'

require 'database'

def render_master(head, body)
	@head = head
	@body = body
	haml :master
end

get '/' do
	@tapes = random_tapes 100 
	render_master('', :splash_body)
end