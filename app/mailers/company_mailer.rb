class CompanyMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.company_mailer.send_invoice.subject
  #
  def send_invoice(invoice, user)
    # invoice is the invoice we want to send
    # user is the user who want to send the invoice (actually, it will be the current user)

    @invoice = invoice
    @company = @invoice.recipient
    @user = user

    attachments['invoice_test.pdf'] = File.read('app/assets/images/INV-004863-Orange.pdf')
    # mail to: @company.email, subject: "Nouvelle facture"
    mail to: @company.email, subject: "#{@user.company.name} - Nouvelle facture"
  end

  def send_followup(invoice, user)
    # invoice is the invoice we want to send
    # user is the user who want to send the invoice (actually, it will be the current user)

    @invoice = invoice
    @company = @invoice.recipient
    @user = user

    # attachments['invoice_test.pdf'] = File.read('app/assets/images/INV-004863-Orange.pdf')
    # mail to: @company.email, subject: "Nouvelle facture"
    mail to: @company.email, subject: "#{@user.company.name} - Facture impayée"
  end

end
