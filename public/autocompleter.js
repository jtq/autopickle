var autocompleter = {
  look_up: function(value) {
    if(value == "") {
      this.clear_popup();
    }
    else {
      var self = this;
      $.ajax("/autocomplete", {
        data: { "query":value }
      }).done(function(data) {
        if(data.length > 0) {
          var container = $("#autocomplete").empty();
          var $input = $('#input');
          for(var i=0; i<data.length; i++) {
            container.append(self.format_autocomplete_entry(data[i]));
          };
          var new_cmd_el = document.createElement("li");
          new_cmd_el.className = "item new"
          new_cmd_el.addEventListener('click', function(e) {
            statement_list.new();
          });
          new_cmd_el.title="Create a new command and add it to this test";
          new_cmd_el.innerText = "[Add new command]";
          container.append(new_cmd_el);
          container.attr('top', $input.attr('bottom')).show();
        }
        else {
          self.clear_popup();
        }
      }).fail(function() {
        console.log("AJAX fail:", arguments);
      });
    }
  },

  clear_popup: function() {
    $("#autocomplete").hide();
  },

  format_autocomplete_entry: function(entry) {
    var el = document.createElement("li");
    el.dictionaryEntry = entry;
    el.className = "item";
    el.addEventListener('click', function(e) {
      statement_list.add(this.dictionaryEntry);
    });
    el.title = entry.examples.slice(0,3).join("&#13;");
    el.innerText = entry.function;
    el.innerHTML = el.innerHTML.replace(/\{([^}]+)\}/g, '<span class="var">$1</span>');

    return el;
  }

};
