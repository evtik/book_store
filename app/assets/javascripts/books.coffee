# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
  trunkParams =
    lines: 6
    tooltip: false
    fill: '&hellip; <a class="in-gold-500" id="read-more" href="#">Read more</a>'

  $('#book-description').trunk8 trunkParams

  $(document).arrive '#book-description', -> $(@).trunk8 trunkParams

  $(document).on 'click', '#read-more', ->
    $(@).parent().trunk8('revert').append ' <a class="in-gold-500" id="read-less" href="#">Read less</a>'
    false

  $(document).on 'click', '#read-less', ->
    $(@).parent().trunk8()
    false
