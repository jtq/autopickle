root_dir = File.dirname(__FILE__);

require 'sinatra'
require File.join(root_dir, 'autopickle')


gherkin_root_dir = "/home/jamesp/source/radio-site/cucumberTest/watir/features"
dic = GherkinDictionary.new(gherkin_root_dir)

get '/' do
  File.read(File.join(root_dir, 'public', 'index.html'))
end

get '/all', :provides => "text/plain" do
  dic.to_s
end

get '/autocomplete', :provides => :json do
  dic.find_terms(params[:query] || "").to_json
end

get '/assets/:file' do |file|
  send_file File.join(root_dir, 'public', file)
end
