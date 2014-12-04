require 'sinatra'
require './autopickle'

gherkin_root_dir = "/scratch/WS/jason/radio-site/cucumberTest/watir/features"
dic = GherkinDictionary.new(gherkin_root_dir)

get '/' do
  File.read(File.join('public', 'index.html'))
end

get '/all', :provides => "text/plain" do
  dic.to_s
end

get '/autocomplete', :provides => :json do
  dic.find_terms(params[:query] || "").to_json
end

get '/assets/:file' do |file|
  send_file File.join('public', file)
end
