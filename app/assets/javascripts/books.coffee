$ ->
  bsBooksModule = do ->
    init: ->
      $('.img-link').click (e) ->
        e.preventDefault()
        $('#main-image').attr 'src', @getAttribute 'data-image'

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
        fill: '&hellip; <a class="in-gold-500" id="read-more" ' +
              "href='#'>#{I18n.t('books.book_details.read_more')}</a>"

      $(document).on 'click', '#read-more', ->
        $(@).parent().trunk8('revert').append("<a class='in-gold-500' " +
          "id='read-less' href='#'>#{I18n.t('books.book_details.read_less')}</a>")
        false

      $(document).on 'click', '#read-less', ->
        $(@).parent().trunk8()
        false

  bsBooksModule.init()

