#!/usr/bin/ruby

require 'json'

class GherkinFunction

	attr_accessor :pattern, :function, :params, :examples

	def initialize(pattern, params)
		backref_pattern = /(?<!\\)(\([^?][^)]+[^\\]\))/
		@pattern = pattern
		names = params.is_a?(Array) ? params : params.split(/\s*,\s*/)
		backrefs = pattern.scan(backref_pattern).to_a.flatten
		@params = Hash[backrefs.zip(names)]
		@function = @pattern.gsub(/^\^|\$$/, '').downcase.gsub(backref_pattern, Hash[@params.map{|k,v| [k,'{'+v+'}'] } ])
		@examples = []
	end

	def matches(str)
		return str.match(@pattern)
	end

	def matches_function(str)
		return function.include? str.downcase
	end

	def to_s
		return @function
	end

	def to_json
		return "{
  \"pattern\":\"#{@pattern.gsub(/\\([^\\])/, '\\\\\\\\\1').gsub('"', '\\"')}\",
  \"function\":\"#{@function.gsub(/\\([^\\])/, '\1').gsub('"', '\\"')}\",
  \"params\":#{JSON.dump(@params)},
  \"examples\":#{@examples}
}"
	end

	def help
		help = self.to_s
		if @params.length > 0
			help += "\n" + examples.map { |example| "\tExample: "+example }.join("\n")
		end
		return help
	end
end

class GherkinDictionary

	attr_accessor :terms

	def initialize(path_or_array)
		@terms = []
		@files = []
		@example_files = []
		if path_or_array.is_a?(Array)
			@terms = path_or_array	# Construct new dictionary from an existing array of terms
		elsif path_or_array.is_a?(String) && Dir.exists?(path_or_array)
			init_from_path(path_or_array)	# else populate by parsing a directory full of step_definition and feature files 
			load_examples_from_path(path_or_array)
			dedupe_examples
		end
	end

	def init_from_path(path)
		#files = Dir[path+"/**/errCode.rb"]
		files = Dir[path+"/**/*.rb"]
		files.each { |file| load_from_file(file) }
	end

	def load_from_file(file)
		File.open(file).each do |line|
			# When(/^I type link in "(.*?)"$/) do |arg1|
			if matches = line.match(/^(given|when|then|and|but)\s*\(\s*\/(\^?[^$]*\$?)\/\s*\)\s*(?:(?:do|{)\s*\|?([^|]*)\|?)/i)
				@terms.push(GherkinFunction.new(matches[2], matches[3])) 
			end
		end
	end

	def load_examples_from_path(path)
		#example_files = Dir[path+"/**/errCode.feature"]
		example_files = Dir[path+"/**/*.feature"]
		example_files.each { |file|
			load_examples_from_file(file)
		}
	end

	def load_examples_from_file(file)
		File.open(file).each do |line|
			if matches = line.match(/^\s*(?:given|when|then|and|but)\s*(.*)/i)
				set_example(matches[1])
			end
		end
	end

	def add(new_term)
		@terms.push(new_term)
	end

	def set_example(example)
		@terms.each do |entry|
			if example.match(entry.pattern) && example.downcase != entry.function
				entry.examples.push(example)
			end
		end
	end

	def dedupe_examples
		@terms.each { |entry| entry.examples = entry.examples.uniq }
	end

	def find_terms(str)
		return self.class.new(@terms.select { |term| term.matches_function(str) })
	end

	def [](index)
		return @terms[index]
	end

	def length
		return @terms.length
	end

	def to_s
		return @terms.map { |term| term.to_s }.join(",\n")
	end

	def to_json
		return '[' + @terms.map { |term| term.to_json }.join(",\n") + ']'
	end
end


if(ARGV[0])
	gherkin_root_dir = "/home/jamesp/source/radio-site/cucumberTest/watir/features"
	dictionary = GherkinDictionary.new(gherkin_root_dir)
	results = dictionary.find_terms(ARGV[0])
	if results.length == 0
		puts " -- No results found -- "
	elsif results.length == 1
		puts results[0].help
	else
		puts ARGV[1] == '--json' ? results.to_json : results.to_s
	end
end
