$ ->
  bsReviewsModule = do ->
    init: ->
      $('.review-star').hover ->
        for i in [1..5]
          $("#star-#{i}").addClass 'rate-empty'
        index = starIndex @
        for i in [1..index]
          $("#star-#{i}").removeClass 'rate-empty'
      , ->
        for i in [1..5]
          starElement = $("#star-#{i}")
          if starElement.hasClass 'star-checked'
            starElement.removeClass 'rate-empty'
          else
            starElement.addClass 'rate-empty'

      $('.review-star').click ->
        index = starIndex @
        for i in [1..index]
          $("#star-#{i}").addClass 'star-checked'
        if index < 5
          for i in [(index + 1)..5]
            $("#star-#{i}").removeClass('star-checked').addClass('rate-empty')
        $('#review_score').val index

      starIndex = (element) -> parseInt element.id.split('-')[1]

  bsReviewsModule.init()

