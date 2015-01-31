#!/usr/bin/ruby

root_dir = File.dirname(__FILE__);

require 'json'
require File.join(root_dir, 'include', 'config')
require File.join(root_dir, 'include', 'gherkin')
require File.join(root_dir, 'local-config')

$dictionary = GherkinDictionary.new(GHERKIN_ROOT_DIR)

if(ARGV[0])
	results = $dictionary.find_terms(ARGV[0])
	if results.length == 0
		puts " -- No results found -- "
	elsif !ARGV[1].nil?
		if ARGV[1] == '--json'
			puts results.to_json
		elsif ARGV[1] == '--raw'
			puts results.to_s
		elsif ARGV[1] == '--help'
			puts results.help
		end
	else
		puts results.to_s
	end
end
