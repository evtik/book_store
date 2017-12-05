$ ->
  bsCartsModule = do ->
    init: ->
      $('.quantity-decrement').click (e) ->
        e.preventDefault()
        $(".#{@getAttribute 'data-target'}").each ->
          quantity = parseInt @value
          @value = quantity - 1 if quantity > 1

      $('.quantity-increment').click (e) ->
        e.preventDefault()
        $(".#{@getAttribute 'data-target'}").each ->
          @value = parseInt(@value) + 1

      $('.quantity-input').change ->
        $("##{@getAttribute 'data-bound-input'}").val @value

  bsCartsModule.init()

