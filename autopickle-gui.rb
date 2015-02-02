root_dir = File.dirname(__FILE__);

require File.join(root_dir, 'autopickle')
require 'sinatra'

set :bind, '0.0.0.0'

get '/' do
  File.read(File.join(root_dir, 'public', 'index.html'))
end

get '/all', :provides => "text/plain" do
  $dictionary.to_s
end

get '/autocomplete', :provides => :json do
  $dictionary.find_terms(params[:query] || "").to_json
end

get '/assets/:file' do |file|
  send_file File.join(root_dir, 'public', file)
end
