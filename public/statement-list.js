var statement_list = {
  statements: [],

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

  	this.statements.push(command);
    this.render();
  },

  remove: function(index) {
    this.statements.splice(index, 1);
    this.render();
  },

  render: function() {
  	var self = this;
  	var container = $('#statement-list').first().sortable('destroy');
  	container.find(".statement").remove();
  	if(this.statements.length) {
  	  container.show();
  	  for(var i=0; i<this.statements.length; i++) {
  	    container.append(this.render_statement(this.statements[i], i));
  	  }
  	  container.sortable({
        handle: '.handle',
        items: ':not(.list-title)'
      }).bind('sortupdate', function() {
  	  	self.statements = [];
        container.find('.statement').each(function() {
          self.statements.push(this.statement);
        });
        self.render();
      });
  	}
  	else {
  		container.hide();
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
  		prefix = "When";
  	}
  	else if(index === this.statements.length-1) {
  		prefix = "Then";
  	}
  	label.innerText = prefix + " " + statement.function;
  	label.innerHTML = label.innerText.replace(/\{([^}]+)\}/g, '<span class="var">$1</span>');
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

  	return el;
  }
};