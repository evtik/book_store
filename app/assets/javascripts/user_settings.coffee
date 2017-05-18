$ ->
  $('.country-select').change ->
    target = @getAttribute 'data-target'
    targetInput = $("##{target}")[0]
    type = target.split('-')[0]
    countryCode = $("option.#{type}")[@selectedIndex - 1]
                    .getAttribute 'data-country-code'
    targetInput.value = '+' + countryCode
