
class LangConfig
	attr_accessor :step_pattern, :function_pattern, :escape_char, :param_delimiter_pattern, :step_fileglob, :feature_fileglob

	def initialize(step_pattern, function_pattern, escape_char, param_delimiter_pattern, step_fileglob, feature_fileglob)
		@step_pattern = step_pattern
		@function_pattern = function_pattern
		@escape_char = escape_char
		@param_delimiter_pattern = param_delimiter_pattern
		@step_fileglob = step_fileglob
		@feature_fileglob = feature_fileglob
	end

end

$lang_config = {
	"ruby"       => LangConfig.new(/^\s*(?:given|when|then|and|but)\s*\(?\s*\/(\^?[^$\n]*\$?)\/\s*\)?\s*(?:(?:do|{)\s*\|?([^|\n]*)\|?)/i, nil, nil, /\s*,\s*/, "/**/*.rb", "/**/*.feature"),
	"scala"      => LangConfig.new(/^\s*(?:given|when|then|and|but)\s*\(\s*"""(\^?[^$\n]*\$?)"""\s*\)\s*(?:{\s*\(?\s*([^=\n]*)\s*\)?\s*=>)/i, nil, nil, /\s*\:\s*String\s*,?\s*/, "/**/*.scala", "/**/*.feature"),
	"java"       => LangConfig.new(/^\s*@(?:given|when|then|and|but)\s*\(\s*"(\^?[^\$\n]*\$?)"\s*\)\s*\r?\n(?:\s*@[^\r\n]+\r?\n)*[^\(]+\(\s*[^\s]+\s*([^\)]*)\)\s*{/i, nil, "\\", /\s*,\s*[^\s]+\s+/, "/**/*.java", "/**/*.feature"),
	"javascript" => LangConfig.new(/^\s*(?:definestep|given|when|then|and|but)\s*\(\s*[\/'"](\^?[^$\n]*\$?)[\/'"][a-z]*\s*,\s*(?:function\s+)?([a-z0-9_$]+\s*)?(?:\(\s*([^)]+)\s*\))?/i, /(?:function\s+)?([a-z0-9_$]+)\s*=?\s*(?:function\s*)?\(([^()]*)\)\s*=?>?\s*{/i, nil, /\s*,\s*/, "/**/*.js", "/**/*.feature")
}