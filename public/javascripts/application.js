// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

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

  do_onResize();
  $(window).resize(do_onResize);
});


