$ ->
  $('.tablinks').on 'click', ->
    tab = $(this).data('tab')
    $('.tablinks').removeClass('active')
    $(this).addClass('active')
    $('.tabcontent').css('display', 'none')
    $('#' + tab).css('display', 'block')
