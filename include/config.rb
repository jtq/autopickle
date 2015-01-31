
class LangConfig
	attr_accessor :step_pattern, :escape_char, :param_delimiter_pattern, :step_fileglob, :feature_fileglob

	def initialize(step_pattern, escape_char, param_delimiter_pattern, step_fileglob, feature_fileglob)
		@step_pattern = step_pattern
		@escape_char = escape_char
		@param_delimiter_pattern = param_delimiter_pattern
		@step_fileglob = step_fileglob
		@feature_fileglob = feature_fileglob
	end

end

