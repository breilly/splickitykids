jQuery ->
  Stripe.setPublishableKey($('meta[name="stripe-key"]').attr('content'))
  activity.setupForm()

activity =
  setupForm: ->
    $('#new_activity').submit ->
    if $('input').length > 17
        $('input[type=submit]').attr('disabled', true)
        Stripe.bankAccount.createToken($('#new_activity'), activity.handleStripeResponse)
        false

  handleStripeResponse: (status, response) ->
    if status == 200
      $('#new_activity').append($('<input type="hidden" name="stripeToken" />').val(response.id))
      $('#new_activity')[0].submit()
    else
      $('#stripe_error').text(response.error.message).show()
      $('input[type=submit]').attr('disabled', false)