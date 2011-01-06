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

  $('.play_button').click(function() {
    var start = $(this).attr('data-start');
    var end   = $(this).attr('data-end');
    if (media) {
      media.attr('currentTime', start);
      media.attr('data-pause', end);
      media.trigger('play');
    }
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

      var sorted_keys = new Array();
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
});


