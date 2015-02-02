#!/usr/bin/ruby

root_dir = File.dirname(__FILE__)

require 'json'
require 'optparse'
require File.join(root_dir, 'include', 'lang-config')
require File.join(root_dir, 'include', 'gherkin')

# Declare defaults, so they can be overridden in local-config file if desired 
$gherkin_root_dir = nil
$step_definition_lang = nil
$cli_output_format = "raw"

# Load local-config file if it exists
config_file = File.join(root_dir, 'local-config.rb')
if File.exists? config_file
	require config_file
end

# Parse CLI params (any collisions override values defined in local-config file)
OptionParser.new do |opts|
  opts.on('-d', '--directory [GHERKIN_PATH]', "Path to the directory containing your cucumber step definitions and feature files") do |val|
    $gherkin_root_dir = val
    if !Dir.exists? $gherkin_root_dir
    	puts "Error: Cucumber tests directory '#{$gherkin_root_dir}' does not exist"
    	exit 1
    end
  end
  opts.on('-l', '--language [LANG]', "Language your cucumber step-definitions are written in") do |val|
    $step_definition_lang = val
    if $lang_config[$step_definition_lang].nil?
    	puts "Error: Invalid language '#{$step_definition_lang}' - valid values are #{$lang_config.keys}"
    	exit 1
    end
  end
  opts.on('-j', '--json', "Output command-line results in json format") do |val|
    $cli_output_format = "json"
  end
  opts.on('-r', '--raw', "Output command-line results in raw format") do |val|
    $cli_output_format = "raw"
  end
  opts.on('-e', '--examples', "Output command-line results in raw format, but with examples of usage") do |val|
    $cli_output_format = "examples"
  end

end.parse!

if $gherkin_root_dir.nil?
	puts "Error: $gherkin_root_dir not set - either provide a --directory parameter or set a default value in local-config.rb"
end

if $step_definition_lang.nil?
	puts "Error: $step_definition_lang not set - either provide a --language parameter or set a default value in local-config.rb"
end

if $gherkin_root_dir.nil? || $step_definition_lang.nil?
	exit 1
end

$lang = $lang_config[$step_definition_lang]

$dictionary = GherkinDictionary.new($gherkin_root_dir)

if(ARGV[0])
	results = $dictionary.find_terms(ARGV[0])
	if results.length == 0
		puts " -- No results found -- "
	else
		if $cli_output_format == 'json'
			puts results.to_json
		elsif $cli_output_format == 'raw'
			puts results.to_s
		elsif $cli_output_format == 'examples'
			puts results.help
		end
	end
end
