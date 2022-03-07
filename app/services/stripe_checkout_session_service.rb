class StripeCheckoutSessionService
  def call(event)
    invoice = Invoice.find_by(checkout_session_id: event.data.object.id)
    invoice.update!(status: 'paid')
  end
end
