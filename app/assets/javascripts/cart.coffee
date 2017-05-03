# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
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
