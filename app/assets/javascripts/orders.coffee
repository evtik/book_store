$ ->
  bsOrdersModule = do ->
    init: ->
      $('.order-row').click ->
        window.location = $(@).data 'link'

  bsOrdersModule.init()

