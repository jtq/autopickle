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
          var html = "", $input = $('#input');
          for(var i=0; i<data.length; i++) {
            html += self.format_autocomplete_entry(data[i]);
          };
          html += '<li class="item new" onclick="statement_list.new();" title="Create a new command and add it to this test">[Add new command]</li>'
          $("#autocomplete").html(html).attr('top', $input.attr('bottom')).show();
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
    return '<li class="item" onclick="statement_list.add(this.innerText);" title="'+entry.examples.slice(0,3).join("&#13;").replace(/"/g, '&quot;')+'">'+entry.function.replace(/\{([^}]+)\}/g, '<span class="var">$1</span>')+'</li>';
  }

};
