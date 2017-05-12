$ ->
  $('.quantity-decrement').click (e) ->
    e.preventDefault()
    targetInput = $ "##{@getAttribute 'data-target'}"
    quantity = parseInt targetInput.val()
    targetInput.val(quantity - 1) if quantity > 1

  $('.quantity-increment').click (e) ->
    e.preventDefault()
    targetInput = $ "##{@getAttribute 'data-target'}"
    quantity = parseInt targetInput.val()
    targetInput.val(quantity + 1)

  $('#book-description').trunk8
    lines: 6
    tooltip: false
    fill: '&hellip; <a class="in-gold-500" id="read-more" href="#">Read more</a>'

  $(document).on 'click', '#read-more', ->
    $(@).parent().trunk8('revert').append ' <a class="in-gold-500" id="read-less" href="#">Read less</a>'
    false

  $(document).on 'click', '#read-less', ->
    $(@).parent().trunk8()
    false

