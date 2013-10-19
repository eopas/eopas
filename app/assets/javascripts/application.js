// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery-migrate-min
//= require jquery_ujs
//= require jquery.nginxUploadProgress
//= require jquery.scrollTo
//= require jquery.validate
//= require_tree .

// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

function setup_div_toggle() {
  $('.collapse_icon').mouseover(function() {
    this.src = '/minimize_black.png';
  });
  $('.collapse_icon').mouseout(function() {
    this.src = '/minimize_grey.png';
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

  var start = parseFloat(times[0]);
  var end = parseFloat(times[1]);

  var m;
  if ($('video').length) {
    m = $('video').first();
  }
  else if ($('audio').length) {
    m = $('audio').first();
  }
  m.attr('data-start', start);
  m.attr('data-pause', end);
  m.attr('currentTime', start);
  m.trigger('play');
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

// set url in current url box
function set_url(fragment) {
  var baseurl = window.location.protocol+"//"+window.location.host+window.location.pathname;
  var url = baseurl + fragment;
  $('span#cur_url').html("<a href='"+url+"'>"+url+"</a>");
}

// changing URL hash on window
function do_fragment_change() {
  var fragment = window.location.hash;
  set_url(fragment);

  if (fragment.match(/^#t=/)) {
    do_time_change(fragment);
  }
  else if (fragment.match(/^#!/)) {
    do_transcript_change(fragment);
  }
}

function setup_playback(media) {
  // on timeupdate check if we are still playing and adjust the highlighted region
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

          // change hash on URL in cur_url textarea
          set_url("#t="+$(this).attr('data-start')+","+$(this).attr('data-end'));
        }
      }
      else {
        $(this).closest('.line').find('.tracks').removeClass('hilight');
      }
    });

    // pause the video if we played past the last segment
    if (cur_time > (parseFloat($('.play_button').last().attr('data-end')))) {
      media.trigger('pause');
      media.attr('data-pause', '');
    }

    // Pause the video if we played a segment and it's finished
    var pause_time = parseFloat(media.attr('data-pause'))+0.1;
    if (pause_time) {
      // we've just gone past the end of the segment, trigger a pause
      if (Math.abs(cur_time - pause_time) < 0.1 && Math.abs(cur_time - pause_time) > 0.0) {
        media.trigger('pause');
        media.attr('data-pause', '');
      }
      // Something weird happend and we missed the pause
      // maybe user skipped ahead; so just reset the data-pause attribute
      if (media.attr('currentTime') > pause_time) {
        media.attr('data-pause', '');
      }
    }
  });

  $('a.play_button').click(function() {
    // need to reset it first in case we have moved past the phrase so it actually does something
    window.location.hash = "";
    window.location.hash = "t="+ $(this).attr('href').replace(/.*#t=(.*)/, "$1");
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
  } 
  else if ($.browser.opera) {
    // Opera is special: it doesn't like changing width
    elem.height(window.innerHeight - 140);
  } 
  else {
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
  if ($('form.validate').length) {
    $('form.validate').validate();
  }
}

function setup_concordance() {
  $('.concordance').click(function() {
      var type = $(this).attr('data-type');
      var search = $(this).attr('data-search');
      var language_code = $(this).attr('data-language-code');

      var fragment = '!'+$(this).attr('data-addr');
      window.location.hash = "";
      window.location.hash = fragment;

      var url = '/transcript_phrases?search=' + encodeURIComponent(search) + '&type=' + type + '&language_code=' + language_code;

      $.get(url,
        function(data) {
          $('#concordance .collapse_content').html(data);
          $('#concordance').show();
        }
      );
  });

  $('.concordance_phrase').live('click', function() {
      var id = $(this).attr('data-id');
      var transcript_id = $(this).attr('data-transcript-id');
      var phrase_num = $(this).attr('data-phrase-num');
      var word_num = $(this).attr('data-word-num');
      var morpheme_num = $(this).attr('data-morpheme-num');

      var url = '/transcripts/' + transcript_id + '#!/p' + phrase_num;
      if (word_num) {
        url += '/w' + word_num;

        if (morpheme_num) {
          url += '/m' + morpheme_num;
        }
      }

      location.href = url;
  });

}


$(document).ready(function() {

  // Get media element
  var media;
  if ($('video').length) {
    media = $('video').first();
  }
  else if ($('audio').length) {
    media = $('audio').first();
  }
  set_url("");

  // also act on hash change of page
  $(window).bind('hashchange', function() {
    do_fragment_change();
  });

  // Collapsing elements
  setup_div_toggle();
  setup_hider();
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

  // if the page is loaded with a different hash, execute that
  if (media) {
    setup_playback(media);
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


