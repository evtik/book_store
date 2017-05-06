# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
  $('#order_use_billing_address').change ->
    if @checked
      $('.shipping-hideable').addClass 'hidden'
    else
      $('.shipping-hideable').removeClass 'hidden'

  $('[data-toggle="tooltip"]').tooltip()

  setShipmentRadio = ->
    $("input:radio").each ->
      if $(@)[0].checked
        isXSRadio = @id.includes 'xs-', 0
        if $(document).width() < 768
          $("#xs-shipment-#{@id.split('-')[1]}")[0].checked = true unless isXSRadio
        else
          $("#shipment-#{@id.split('-')[2]}")[0].checked = true if isXSRadio
        false

  $(window).resize ->
    setShipmentRadio()

  setShipmentRadio()

  $("input:radio").change ->
    # don't forget i18n currency sign!
    $('#shipment-label').text(I18n.l('currency', @getAttribute 'data-price'))
