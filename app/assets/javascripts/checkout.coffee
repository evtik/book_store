$ ->
  $('#order_use_billing').change ->
    if @checked
      $('.shipping-hideable').addClass 'hidden'
    else
      $('.shipping-hideable').removeClass 'hidden'

  $('.country-select').change ->
    target = @getAttribute 'data-target'
    targetInput = $("##{target}")[0]
    type = target.split('-')[0]
    countryCode = $("option.#{type}")[@selectedIndex - 1]
                    .getAttribute 'data-country-code'
    targetInput.value = '+' + countryCode

  setShipmentRadio = ->
    $("input:radio").each ->
      if @checked
        isXSRadio = @id.includes 'xs-', 0
        if $(document).width() < 768
          $("#xs-shipment-#{@id.split('-')[1]}")[0].checked = true unless isXSRadio
        else
          $("#shipment-#{@id.split('-')[2]}")[0].checked = true if isXSRadio
        false

  $(window).resize ->
    setShipmentRadio()

  $("input:radio").change ->
    shipmentPrice = parseFloat @getAttribute 'data-price'
    $('#shipment-label').text(I18n.l('currency', shipmentPrice))
    totalEl = $('#order-total-label')[0]
    subTotal = parseFloat totalEl.getAttribute 'data-subtotal'
    $(totalEl).text(I18n.l('currency', subTotal + shipmentPrice))
    $('#shipment_price').val shipmentPrice
    $('#shipment_days_min').val @getAttribute 'data-days-min'
    $('#shipment_days_max').val @getAttribute 'data-days-max'
    $('#shipment_method').val @getAttribute 'data-method'

  $('[data-toggle="tooltip"]').tooltip()

  setShipmentRadio()

