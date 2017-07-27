$ ->
  $('.order-row').click ->
    window.location = $(@).data 'link'
