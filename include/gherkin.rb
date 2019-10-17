class GherkinFunction

	attr_accessor :pattern, :function, :params, :examples

	def initialize(pattern, params)
		if params.nil?
			params = ""
		end
		params.strip!	# Get rid of any leading/trailing whitespace that's hard to exclude using config regexps
		backref_pattern = /(?<!\\)(\([^?][^)]*[^\\]\))/
		@pattern = pattern
		names = params.is_a?(Array) ? params : params.split($lang.param_delimiter_pattern)
		backrefs = pattern.scan(backref_pattern).to_a.flatten
		if(backrefs.length > names.length)
			names.concat(Array.new(backrefs.length-names.length, '?'))
		end
		@params = backrefs.zip(names)
		@function = unescape_regex_special_chars(@pattern.gsub(/^\^|\$$/, '').gsub("%", "%%").gsub(backref_pattern, "%s") % names.map{|n| '{'+n+'}' })
		@examples = []
	end

	def matches(str)
		return str.match(@pattern)
	end

	def matches_function(str)
		return @function.downcase.include? str.downcase
	end

	def unescape_regex_special_chars(str)
		map = Hash.new { |hash,key| key } # simple trick to return key if there is no value in hash
		map['t'] = "\t"
		map['n'] = "\n"
		map['r'] = "\r"
		map['f'] = "\f"
		map['v'] = "\v"

		return str.gsub(/\\(.)/){ map[$1] }
	end

	def to_s
		return @function
	end

	def to_json
		return "{
  \"pattern\":#{JSON.generate(@pattern, quirks_mode: true)},
  \"function\":#{JSON.generate(@function, quirks_mode: true)},
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
		@functions = {}
		if path_or_array.is_a?(Array)
			@terms = path_or_array	# Construct new dictionary from an existing array of terms
		elsif path_or_array.is_a?(String) && Dir.exists?(path_or_array)
			init_from_path(path_or_array)	# else populate by parsing a directory full of step_definition and feature files 
			load_examples_from_path(path_or_array)
			dedupe_examples
		end
	end

	def init_from_path(path)
		files = Dir[path+$lang.step_fileglob]

		files.each { |file| load_steps_from_file(file) }		# Scan each file for step definitions
	end

	def load_steps_from_file(file)
		file_content = File.read(file)

		# Detect all named functions defined in source code (used for guessing at param list for step-definitions that use a function reference rather than inline definition)
		# This obviously may experience namespace collisions if multiple functions with the same name are defined in the codebase, but this is likely the best we can reasonably
		# do with simple pattern-matching, without trying to statically analyse the code to follow module-import/export chains
		if $lang.function_pattern
			file_content.scan($lang.function_pattern) do |function_name, function_params|
				if function_name
					@functions[function_name] = function_params
				end
			end
		end

		# Now scan for step-definitions, and extract the gherkin command, params, etc
		file_content.scan($lang.step_pattern) do |command, function_name, params|
			if $lang.escape_char
				command.gsub!("#{$lang.escape_char}#{$lang.escape_char}", $lang.escape_char)
			end

			# If we have a named function but no params, check whether it's a reference to a function defined elsewhere, and if it looks like
			# it might be, use the param list from the previously-discovered definition.
			if function_name && params.nil? && @functions[function_name]
				params = @functions[function_name]
			end

			@terms.push(GherkinFunction.new(command, params)) 
		end
	end

	def load_examples_from_path(path)
		example_files = Dir[path+$lang.feature_fileglob]
		example_files.each { |file|
			load_examples_from_file(file)
		}
	end

	def load_examples_from_file(file)
		File.open(file).each do |line|
			begin
				if matches = line.match(/^\s*(?:given|when|then|and|but)\s*(.*)/i)
					set_example(matches[1])
				end
			rescue ArgumentError
				# Likely caused by a charset/encoding problem.  Skip the example for now, but come back to this later and try to recover gracefully from it.
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
		return @terms.map { |term| term.to_s }.join("\n")
	end

	def to_json
		return '[' + @terms.map { |term| term.to_json }.join(",\n") + ']'
	end

	def help
		return @terms.map { |term| term.help }.join("\n")
	end
end
