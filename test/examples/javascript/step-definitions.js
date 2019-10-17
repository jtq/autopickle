
// Aliases
defineStep(/defineStep command/i, () => {});
Given(/Given command/i, () => {});
Then(/Then command/i, () => {});
When(/When command/i, () => {});

// Types of command definition
defineStep(/RegExp pattern/i, () => {});
defineStep('Single quotes', () => {});
defineStep("Double quotes", () => {});

// Types of function definition
defineStep(/ES5 anonymous function/i, function() {});
defineStep(/ES5 named function/i, function definedStep() {});
defineStep(/ES6 anonymous function/i, () => {});
defineStep(/Function reference/i, es5NamedFunction);
defineStep(/Function reference with embedded (\d+) (\d+) params/i, es5NamedFunction);

// Embedded parameters
defineStep(/No embedded params/i, () => {});
defineStep(/(\d+) embedded param/i, es5AnonymousFunctionExpression);
defineStep(/ES5 anonymous (\d+) embedded param/i, function(the) {});
defineStep(/(\d+) ([a-z]+) params/i, (count, type) => {});

function es5NamedFunction(param1, param2) {}
var es5AnonymousFunctionExpression = function(count) {};
var es6FatArrowFunctionExpression = () => {};