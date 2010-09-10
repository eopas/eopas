// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

$(document).ready(function() {

  $('.collapse_icon').mouseover(function() {
    this.src = '/images/minimize_black.png';
  });
  $('.collapse_icon').mouseout(function() {
    this.src = '/images/minimize_grey.png';
  });
  $('.collapse_icon').click(function() {
    $(this).parent().next().slideToggle();
  });

});

$(window).load(function() {
  do_onResize();
    $(window).resize(do_onResize);
});

function do_onResize() {
  if ($.browser.msie) {
    //y = document.body.clientHeight - 95;
    x = document.body.offsetWidth - 380;
    if (document.getElementById('transcripts_display')) {
    document.getElementById('transcripts_display').style.width = x;
    //document.getElementById('transcripts_display').style.height = '700px';
    }
  } else if ($.browser.opera) {
    // Opera is special: it doesn't like calculating with variables on the width and height
    // and it controls the width by itself just fine
    if (document.getElementById('transcripts_display')) {
      document.getElementById('transcripts_display').style.height = window.innerHeight - 110 + 'px';
      document.getElementById('transcripts_display').style.overflow = 'scroll';
    }
  } else {
    screenY = window.innerHeight - 110;
    screenX = window.innerWidth - 395;
    if (document.getElementById('transcripts_display')) {
      document.getElementById('transcripts_display').style.width = screenX + 'px';
      document.getElementById('transcripts_display').style.height = screenY + 'px';
    }
  }
}

