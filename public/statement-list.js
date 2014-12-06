var statement_list = {
  statements: [],

  add: function(command_str) {
    this.statements.push(command_str);
    this.render();
  },

  remove: function(index) {
    this.statements.splice(index, 1);
    this.render();
  },

  render: function() {
  	var self = this;
  	var container = $('#statement-list').first().sortable('destroy');
  	container.empty();
  	if(this.statements.length) {
  	  container.show();
  	  for(var i=0; i<this.statements.length; i++) {
  	    container.append(this.render_statement(this.statements[i], i));
  	  }
  	  container.sortable({
        handle: '.handle'
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
  	label.innerText = prefix + " " + statement;
  	el.appendChild(label);

  	var handle = document.createElement("span");
  	handle.className = "handle";
  	handle.innerHTML = "&#11021;";
	el.appendChild(handle);

  	var del = document.createElement("span");
  	del.className = "del";
  	del.innerText = "X";
  	del.addEventListener('click', function(e) {
      self.remove(index);
  	});
  	el.appendChild(del);

  	return el;
  }
};