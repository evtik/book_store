# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
  $(document).arrive '.quantity-decrement', ->
    $(@).click (e) ->
      e.preventDefault()
      targetInput = $ "##{@getAttribute 'data-target'}"
      quantity = parseInt targetInput.val()
      targetInput.val(quantity - 1)

  $(document).arrive '.quantity-increment', ->
    $(@).click (e) ->
      e.preventDefault()
      targetInput = $ "##{@getAttribute 'data-target'}"
      quantity = parseInt targetInput.val()
      targetInput.val(quantity + 1)
