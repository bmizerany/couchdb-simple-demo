require 'sinatra'
require 'couchrest'

def db
	url = ENV['COUCHDB_URL']
	@db ||= CouchRest.database!(url)
end

require File.dirname(__FILE__) + '/lib/access_log'
require File.dirname(__FILE__) + '/lib/counting'

before do
	AccessLog.create_from_request(request)
end

get '/' do
	"Hello, I've been seen #{AccessLog.count} times. <a href=\"/latest\">View Latest Hits</a>"
end

get '/env' do
	request.env.collect { |k, v| "#{k} = #{v.inspect}" }.join("<br />\n")
end

get '/latest' do
	@logs = AccessLog.all(:limit => 20)
	erb :latest
end
