GHERKIN_ROOT_DIR = "/path/to/your/cucumber/tests/directory"

# Ruby
CONFIG = LangConfig.new(/^\s*(given|when|then|and|but)\s*\(\s*\/(\^?[^$]*\$?)\/\s*\)\s*(?:(?:do|{)\s*\|?([^|]*)\|?)/i, /\s*,\s*/, "/**/*.rb", "/**/*.feature")

# Scala
CONFIG = LangConfig.new(/^\s*(given|when|then|and|but)\s*\(\s*"""(\^?[^$]*\$?)"""\s*\)\s*(?:{\s*\(?\s*([^=]*)\s*\)?\s*=>)/i, /\s*\:\s*String\s*,?\s*/, "/**/*.scala", "/**/*.feature")
