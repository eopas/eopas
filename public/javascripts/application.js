// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

function setup_div_toggle() {
  $('.collapse_icon').mouseover(function() {
    this.src = '/images/minimize_black.png';
  });
  $('.collapse_icon').mouseout(function() {
    this.src = '/images/minimize_grey.png';
  });
  $('.collapse_icon').click(function() {
    $(this).parent().next().slideToggle();
  });
}

// resizing the transcript_display div with the remaining screen-size
function do_onResize() {
  elem = $('#transcript_display');
  if (!elem) return;
  if ($.browser.msie) {
    //y = document.body.clientHeight - 95;
    x = $('body').offsetWidth - 380;
    elem.width(x);
    //elem.style.height = '700px';
  } else if ($.browser.opera) {
    // Opera is special: it doesn't like changing width
    elem.height(window.innerHeight - 110);
  } else {
    elem.width(window.innerWidth - 395);
    elem.height(window.innerHeight - 110);
  }
}

function setup_country_code() {

  $('.country-select').change( function() {

      var parent = $(this);
      var child_id = parent.attr('data-select-child');
      var child = $('#' + child_id);


      var selected_code = child.attr('data-option-selected');
      var country_code = parent.attr('value');

      child.empty();

      if (! selected_code) {
        child.append("<option selected='selected'> -- Select -- </option>");
      }

      sorted_keys = new Array();
      for (code in country_languages[country_code]) {
        sorted_keys.push(code);
      }
      sorted_keys.sort(function(a,b) {
        return country_languages[country_code][a] > country_languages[country_code][b];
      });

      for (i in sorted_keys) {
        code = sorted_keys[i];

        selected = '';
        if (code == selected_code) {
          selected = ' selected=selected';
        }
        child.append('<option value="' + code+ '"' + selected +'>' + country_languages[country_code][code] + ' (' +  code + ')' + '</option>');
      }
  }).change();

}

$(document).ready(function() {

  // Collapsing dovs
  setup_div_toggle();

  // Country Code Selector
  setup_country_code();

  // Transcript box 
  do_onResize();
  $(window).resize(do_onResize);

});


