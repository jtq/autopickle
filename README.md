# autopickle #

Parser and UI for non-technical users to easily generate Gherkin acceptance tests based on your existing Gherkin commands

## Quick start ##

1. Clone the repo
2. `ruby autopickle.rb --language <step_definition_language> --directory <cucumber_tests_dir> ""`

## Configuration ##

You must specify:

* The path to your cucumber tests directory (a parent directory of both your Gherkin step-definition files and the `.feature` files containing your actual Gherkin tests)
* The language your step-definition files are expressed in (ruby, java and scala are currently supported out of the box, but you should be able to configure autopickle to understand any language - see "Advanced configuration", below).

You can configure these settings using command-line parameters:

| Parameter   | Explanation |
| ----------- | ----------- |
| --directory | Path to the parent directory containing your Gherkin step-definitions and `.feature` files. Autopickle will recursively search for both step definitions and feature files within this directory. |
| --language  | Language your step-definitions are expressed in. |

Or by copying `local-config.rb.example` to `local-config.rb` and editing it to specify the default values you require (see `local-config.rb.example` for more details).

## Running ##

### From the command-line ###

`ruby [params] autopickle.rb "<search term>"` will return a list of all Gherkin commands that match the provided search term (`""` to return all commands).

You can also specify a second parameters on the command-line to control output:

| Parameter  | Result        |
| ---------- | ------------- |
| --raw      | Raw list of commands (with backreference variable-names helpfully interpolated) |
| --examples | Like `--raw`, but including examples of usage for any commands containing embedded variables/backreferences, drawn from your existing `.feature` files |
| --json     | JSON output of each command, including the original pattern, the interpolated command-name, embedded params, etc|

### From a web interface ###

`ruby [params] autopickle-gui.rb` will run a simple Sinatra app through Ruby's WEBrick web-server, accessible via [http://localhost:4567](http://localhost:4567).

Type whatever search terms you like into the autocomplete box, click the ones you want and construct scenarios for cutting-and-pasting into your .feature files (complete with reordering/deletion and scenario code/name editing).


## Advanced configuration ##

Out of the box autopickle supports step-definitions written in ruby, java and scala.  However, if your step-definitions are written in another language you can use the `local-config.rb` configuration file to configure autopickle support for new languages.

The provided `local-config.rb.example` file already contains a (commented-out) example definition for ruby, and all the existing language definitions are visible in `include/lang-config.rb`.

### Basic process ###

1. Autopickle uses the first parameter (regular expression) to extract the entire definition of each gherkin command in your source code (including any backreferences and their corresponding variables/function parameters as one long string)
2. Autopickle provides a second (string) parameter allowing you to specify the escaping character if regular expressions require additional escaping to be represented in your language (eg, Java, where all RegExps are represtened as strings, therefore requires all `\` characters to be escaped).  Leave it empty if your language represents regexps without escaping.
3. Autopickle then uses the third parameter (regular expression) to split the chunk of text containing the backreference variables' definitions to leave a simple list of variable names.  These are then interpolated (in order) back into the Gherkin command, replacing each saved backreference in the command with the corresponding variable name.
4. The final two parameters are file-specs (relative to `--directory`/`$gherkin_root_dir`) used to find step-definitions and feature files (respectively).
