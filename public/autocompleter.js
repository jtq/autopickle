var autocompleter = {

  init: function() {
    $("#input").on("keyup", function(event) {
      autocompleter.look_up(this.value);
    }).on("keydown", function(event) {
      console.log(event);
      if(event.keyCode === 13) {
        event.preventDefault();
        event.stopPropagation();
      }
    });
  },

  look_up: function(value) {
    if(value == "") {
      this.clear_popup();
    }
    else {
      var self = this;
      $.ajax("/autocomplete", {
        data: { "query":value }
      }).done(function(data) {
        var container = $("#autocomplete").empty();
        var $input = $('#input');

        if(data.length > 0) {
          for(var i=0; i<data.length; i++) {
            container.append(self.format_autocomplete_entry(data[i]));
          };
        }

        var new_cmd_el = document.createElement("li");
        new_cmd_el.className = "item new"
        new_cmd_el.addEventListener('click', function(e) {
          statement_list.new(value);
          self.reset();
        });
        new_cmd_el.title="Create a new command and add it to this test";
        new_cmd_el.innerText = "[Add new command]";
        container.append(new_cmd_el);
        container.attr('top', $input.attr('bottom')).show();

      }).fail(function() {
        console.log("AJAX fail:", arguments);
      });
    }
  },

  clear_popup: function() {
    $("#autocomplete").hide();
  },

  reset: function() {
    $('#input').val("");
    this.clear_popup();
    $('#input').focus();
  },

  format_autocomplete_entry: function(entry) {
    var self = this;
    var el = document.createElement("li");
    el.dictionaryEntry = entry;
    el.className = "item";
    el.addEventListener('click', function(e) {
      statement_list.add($.extend(true, {}, this.dictionaryEntry)); // Deep-copy autocomplete entry so multiple instances of the same commadn don't accidentally share state
      self.reset();
    });
    el.title = entry.examples.slice(0,3).join("\n");
    el.innerText = entry.function;
    el.innerHTML = el.innerHTML.replace(/\{([^}]+)\}/g, '<span class="var">$1</span>');

    return el;
  }

};
