$ ->
  $('.quantity-decrement').click (e) ->
    e.preventDefault()
    $(".#{@getAttribute 'data-target'}").each ->
      targetInput = $ @
      quantity = parseInt targetInput.val()
      targetInput.val(quantity - 1) if quantity > 1

  $('.quantity-increment').click (e) ->
    e.preventDefault()
    $(".#{@getAttribute 'data-target'}").each ->
      targetInput = $ @
      quantity = parseInt targetInput.val()
      targetInput.val(quantity + 1)

  $('.quantity-input').change ->
    $("##{@getAttribute 'data-bound-input'}").val($(@).val())
