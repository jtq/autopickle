var statement_list = {
  statements: [],
  container: null,

  init: function() {
    container = $('#statement-list').first();
    var self = this;
    container.bind('sortupdate', function() {
        self.update_statements_list_from_dom();
        self.render();
      });
    var title = container.find(".list-title")[0];

    if(!title) {
      var scenario_title = 'Scenario: <span class="var" data-varname="scenario_code">CODE001</span> - <span class="var" data-varname="scenario_description">Scenario description</span>';
      var title_element = $('<li class="list-title" draggable="false">'+scenario_title+'</li>')[0];

      container.append(title_element);

      this.attach_event_handlers(title_element);
    }
  },

  new: function() {
  	var new_command = prompt("Create a new command for use in this test", "Please type your new command here");
  	if(new_command) {
      this.add(new_command+"*");
    }
  },

  add: function(command) {
  	if(typeof command === 'string') {
  	  command = {
  	    function: command
  	  };
  	}

  	if(command.function) {
  	  var vars = command.function.match(/\{[^\}]+\}/g);
  	  command.values = {};
  	  for(var i=0; vars && i<vars.length; i++) {
        var varname = vars[i].slice(1, -1);
  	  	command.values[varname] = this.get_variable_value(command, varname, "");
  	  }
  	}

  	this.statements.push(command);
    this.render();
  },

  remove: function(index) {
    this.statements.splice(index, 1);
    this.render();
  },

  update_statements_list_from_dom: function() {
    this.statements = [];
    var self = this;
    container.find('.statement').each(function() {
      self.statements.push(this.statement);
    });
  },

  render: function() {
  	var self = this;

  	container.find(".statement").remove();
  	if(this.statements.length) {
  	  $('.show-if-statements').show();
  	  for(var i=0; i<this.statements.length; i++) {
  	    container.append(this.render_statement(this.statements[i], i));
  	  }
  	  container.sortable({
        handle: '.handle',
        items: ':not(.list-title)'
      });
  	}
  	else {
  		$('.show-if-statements').hide();
  	}
  },

  render_statement: function(statement, index) {
  	var self = this;

  	var el = document.createElement('li');
  	el.statement = statement;
  	el.className = "statement";

  	var label = document.createElement("span");
  	label.className = "label";
  	var prefix = "And";
  	if(index === 0) {
  		prefix = "Given";
  	}
  	else if(index === this.statements.length-1) {
  		prefix = "Then";
  	}
  	this.interpolate(label, statement);
    label.innerHTML = "&nbsp;&nbsp;" + prefix + " " + label.innerHTML;
  	el.appendChild(label);

  	var handle = document.createElement("img");
  	handle.className = "handle";
  	handle.src = "/assets/elevator.svg";
    el.appendChild(handle);

  	var del = document.createElement("img");
  	del.className = "del";
  	del.src = "/assets/delete.svg";
  	del.addEventListener('click', function(e) {
      self.remove(index);
  	});
  	el.appendChild(del);

    this.attach_event_handlers(el);

  	return el;
  },

  get_variable_value: function(command, varname, default_value) {
    var example = (command.examples && command.examples.length) ? "\r\nExample: "+command.examples[0] : "";
    var input = prompt("Command: "+command.function+example+"\r\nPlease enter a value for variable "+varname, default_value)
    return input == null ? default_value : input;
  },

  modify_variable_value: function(el) {
    var $el = $(el);
    var item = $el.closest("li")[0];
    var new_value = null;
    if(item.statement) {
      var varname = $el.data("varname");
      new_value = this.get_variable_value(item.statement, varname, el.innerText);
      item.statement.values[varname] = new_value || item.statement.values[varname];
    }
    else {
      new_value = prompt("New Value", el.innerText);
    }
    el.innerText = new_value;

    this.render();
  },

  attach_event_handlers: function(el) {
    var list_item = el ? $(el) : $('#statement-list li');
    var self = this;
    var click_handler = function(e) {
      self.modify_variable_value(this);
    };
    list_item.find(".var").off('click', click_handler);
    list_item.find(".var").on('click', click_handler);
  },

  interpolate: function(label, statement) {
    var raw = statement.function;
    label.innerText = raw;
  	for(var key in statement.values) {
      label.innerText = label.innerText.replace('{'+key+'}', '{'+key+':'+statement.values[key]+'}');
  	}
    label.innerHTML = label.innerText.replace(/\{([^\:]+)\:([^}]+)\}/g, '<span class="var" data-varname="$1">$2</span>');
  }
};


