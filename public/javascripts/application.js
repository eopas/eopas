/*global country_languages */

"use strict";

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

function setup_hider() {
  $('.hider').click(function() {
    var hide_id = $(this).attr('data-hide-selector');
    if (hide_id) {
      $(hide_id).slideToggle();
    }
  });
}

function setup_embedding() {
  $('#embed_code').click(function() {
    $(this).focus();
    $(this).select();
  });
}

function do_time_change(fragment) {
  fragment = fragment.replace(/#t=(.*)/, "$1");
  if (!fragment) {
    return;
  }

  var times = fragment.split(',');
  if (times.length != 2) {
    return;
  }

  var start = (1.0*times[0]).toFixed(2);
  var end = times[1];
  var m;
  if ($('video')) {
    m = $('video').first();
  } else if ($('audio')) {
    m = $('audio').first();
  }
  m.attr('currentTime', start);
  m.trigger('play');
  m.attr('data-pause', end);
}

function do_transcript_change(fragment) {
  var matches = fragment.match(/^#!\/p([^\/]*)(?:\/w([^\/]*))?(?:\/m([^\/]*))?/);
  var phrase_num = matches[1];
  var word_num = matches[2];
  var morpheme_num = matches[3];

  var phrase = '.phrase:eq(' + (phrase_num - 1) + ')';
  $('#transcript_display').scrollTo(phrase);

  var elem;
  if (word_num) {
    elem = phrase + ' .word:eq(' + (word_num - 1) + ')';

    if (morpheme_num) {
      elem = elem + ' .morpheme:eq(' + (morpheme_num - 1) + ')';
    }
  }

  jQuery('.impress').removeClass('impress');
  $(elem).addClass('impress');
}

// changing URL hash on window
function do_fragment_change() {
  var fragment = window.location.hash;

  if (fragment.match(/^#t=/)) {
    do_time_change(fragment);
  }
  else if (fragment.match(/^#!/)) {
    do_transcript_change(fragment);
  }
}

function setup_playback(media) {
  media.bind('timeupdate', function() {
    var cur_time = parseFloat(media.attr('currentTime'));
    if (media.attr('paused') || media.attr('ended')) {
      return;
    }

    // highlight and scroll to currently playing time offset
    $('.play_button').each(function(index) {
      if (cur_time >= (parseFloat($(this).attr('data-start'))) &&
          cur_time < parseFloat($(this).attr('data-end'))) {
        var line = $(this).closest('.line');
        if (!line.find('.tracks').hasClass('highlight')) {
          // check if we have to scroll
          var scroller = $('#transcript_display');
          var bottom_s = scroller.offset().top+scroller.height();
          var bottom_l = line.offset().top+line.height();
          if ((bottom_l > (bottom_s-20)) ||
              (line.offset().top < scroller.offset().top)) {
            scroller.scrollTo(line, 500, {offset: -20, easing: 'linear'});
          }
          // highlight currently playing track
          line.find('.tracks').addClass('hilight');
          // change hash on URL
          window.location.hash="t="+$(this).attr('data-start')+","+$(this).attr('data-end');
        }
      } else {
        $(this).closest('.line').find('.tracks').removeClass('hilight');
      }
    });

    // Pause the video if we played a segment and it's finished
    var pause_time = parseFloat(media.attr('data-pause'))+0.1;
    if (pause_time) {
      if (Math.abs(pause_time - cur_time) < 0.1) {
        media.trigger('pause');
        media.attr('data-pause', '');
      }
      // Something weird happend and we missed the pause
      // maybe user skipped ahead
      if (media.attr('currentTime') > pause_time) {
        media.attr('data-pause', '');
      }
    }
  });

  $('a.play_button').click(function() {
    window.location.hash = "t="+ $(this).attr('href').replace(/.*#t=(.*)/, "$1");
    do_fragment_change();
  });
}


// resizing the transcript_display div with the remaining screen-size
function do_onResize() {
  var elem = $('#transcript_display');
  if (!elem) {
    return;
  }
  if ($.browser.msie) {
    //y = document.body.clientHeight - 95;
    var x = $('body').offsetWidth - 380;
    elem.width(x);
    //elem.style.height = '700px';
  } else if ($.browser.opera) {
    // Opera is special: it doesn't like changing width
    elem.height(window.innerHeight - 140);
  } else {
    elem.width(window.innerWidth - 395);
    elem.height(window.innerHeight - 140);
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

      var sorted_keys = [];
      for (var code in country_languages[country_code]) {
        if (country_languages[country_code].hasOwnProperty(code)) {
          sorted_keys.push(code);
        }
      }
      sorted_keys.sort(function(a,b) {
        return country_languages[country_code][a] > country_languages[country_code][b];
      });

      for (var i = 0; i < sorted_keys.length; i++) {
        code = sorted_keys[i];

        var selected = '';
        if (code == selected_code) {
          selected = ' selected=selected';
        }
        child.append('<option value="' + code+ '"' + selected +'>' + country_languages[country_code][code] + ' (' +  code + ')' + '</option>');
      }
  }).change();

}

function setup_transcript_media_item() {

  // bind "click" event for links with title="submit" 
  $("a[data-add-media-item]").click( function() {
    var form = $(this).parents("form");
    var media_item_id = $(this).attr('data-media-item-id');
    var media_item = form.find('input[name=media_item_id]');
    media_item.val(media_item_id);
    form.submit();
  });

}

function setup_validations() {
  $('form.validate').validate();
}

function setup_concordance() {
  $('.concordance').click(function() {
      var type = $(this).attr('data-type');
      var search = $(this).attr('data-search');
      var language_code = $(this).attr('data-language-code');

      var url = '/transcript_phrases?search=' + search + '&type=' + type + '&language_code=' + language_code;

      $.get(url,
        function(data) {
          $('#concordance .collapse_content').html(data);
          $('#concordance').show();
        }
      );
  });

  $('.concordance_phrase').live('click', function() {
      var id = $(this).attr('data-id');
      var phrase_num = $(this).attr('data-phrase-num');
      var word_num = $(this).attr('data-word-num');
      var morpheme_num = $(this).attr('data-morpheme-num');

      var url = location.href.replace(/#.*/, '') + '#!/p' + phrase_num;
      if (word_num) {
        url += '/w' + word_num;

        if (morpheme_num) {
          url += '/m' + morpheme_num;
        }
      }

      location.href = url;
      do_fragment_change();
  });

}


$(document).ready(function() {

  // Get media element
  var media;
  if ($('video')) {
    media = $('video').first();
  } else if ($('audio')) {
    media = $('audio').first();
  }

  // Collapsing elements
  setup_div_toggle();
  setup_hider();
  setup_playback(media);
  setup_embedding();

  // Country Code Selector
  setup_country_code();

  // Transcript box 
  do_onResize();
  $(window).resize(do_onResize);

  // Form bits
  setup_transcript_media_item();

  // Search
  setup_concordance();
  setup_validations();

  // on URL hashchange of page
  if (media.size() > 0) {
    media.bind('loadedmetadata', do_fragment_change);
  }
  else {
    do_fragment_change();
  }

  // Edit form extra fields
  $('a[data-clone-fields]').click(function() {
    var num = $('.participant').length; // how many "duplicatable" input fields we currently have
    var newNum  = num + 1;    // the numeric ID of the new input field being added

    var newElem = $('.participant').last().clone();
    newElem.children().each(function() {
      var child = $(this);

      function attr_update(elem, attr_name) {
        var attr = elem.attr(attr_name);
        if (attr) {
          var index = attr.replace(/.*[_\[]([0-9]+)[_\]].*/, '$1');
          index = parseInt(index, 10) + 1;
          attr = attr.replace(/(.*[_\[])[0-9]+([_\]].*)/, '$1' + index + '$2');
          elem.attr(attr_name, attr);
        }
      }
      attr_update(child, 'for');
      attr_update(child, 'id');
      attr_update(child, 'name');
      child.attr('value', '');

    });

    $('.participant').last().next().after('</br>').after(newElem);
  });


});


