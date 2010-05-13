require 'rubygems'
require 'sinatra'
require 'haml'

def render_master(head, body)
	@head = head
	@body = body
	haml :master
end

get '/' do
	@tapes = ['one', 'two']
	render_master('', :splash_body)
end