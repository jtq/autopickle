# autopickle #


Parser and UI for non-technical users to easily generate Gherkin acceptance tests based on your existing Gherkin commands

## Installation ##

1. Check out the repo.
2. Copy `local-config.rb.example` to `local-config.rb`
3. Edit `local-config.rb` and set the **GHERKIN_ROOT_DIR** constant to your cucumber tests' `features` folder

## Running ##

### From the command-line ###

`ruby autopickle.rb "<search term>"` will return a list of all Gherkin commands that match the provided search term.

You can also specify a second parameter to control output:

| Parameter | Result        |
| --------- | ------------- |
| --raw     | Raw list of commands (with backreference variable-names helpfully interpolated) |
| --help    | Like `--raw`, but including examples of usage for any commands containing embedded variables/backreferences, drawn from your existing .feature files |
| --json    | JSON output of each command, including the original pattern, the interpolated command-name, embedded params, etc|

### From a web interface ###

`ruby autopickle-gui.rb` will run a simple Sinatra app through Ruby's WEBrick web-server, accessible via [http://localhost:4567](http://localhost:4567).

Type whatever search terms you like into the autocomplete box, click the ones you want and construct scenarios for cutting-and-pasting into your .feature files (complete with reordering/deletion and scenario code/name editing).
