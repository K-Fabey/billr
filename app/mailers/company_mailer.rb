require 'open-uri'

class CompanyMailer < ApplicationMailer
  include CloudinaryHelper

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.company_mailer.send_invoice.subject

  def hello
    mail(
      subject: 'Hello from Postmark',
      to: 'contact@billr.eu',
      from: 'contact@billr.eu',
      html_body: '<strong>Hello</strong> dear Postmark user.',
      track_opens: 'true',
      message_stream: 'outbound')
  end

  def send_invoice(invoice, user)
    # invoice is the invoice we want to send
    # user is the user who want to send the invoice (actually, it will be the current user)

    @invoice = invoice
    @company = @invoice.recipient
    @user = user

    if @invoice.invoice_file.attached?
      attachments['invoice.pdf'] = { mime_type: 'image/png', content: URI.open(cl_image_path(@invoice.invoice_file.key, format: :png, width:'600px')).read }
    else
      attachments['invoice.pdf'] = File.read('app/assets/images/INV-004863-Orange.pdf')
    end

    # mail to: @company.email, subject: "Nouvelle facture"
    mail(
      subject: "#{@user.company.name}- Nouvelle facture",
      to: @company.email,
      from: 'contact@billr.eu',
      html_body: '',
      track_opens: 'true',
      message_stream: 'outbound')
  end

  def send_followup(invoice, user)
    # invoice is the invoice we want to send
    # user is the user who want to send the invoice (actually, it will be the current user)

    @invoice = invoice
    @company = @invoice.recipient
    @user = user

    # attachments['invoice_test.pdf'] = File.read('app/assets/images/INV-004863-Orange.pdf')
    # mail to: @company.email, subject: "Nouvelle facture"
    # mail to: @company.email, subject: "#{@user.company.name} - Facture impayée"

    if @invoice.invoice_file.attached?
      attachments['invoice.pdf'] = { mime_type: 'image/png', content: URI.open(cl_image_path(@invoice.invoice_file.key, format: :png, width:'600px')).read }
    else
      attachments['invoice.pdf'] = File.read('app/assets/images/INV-004863-Orange.pdf')
    end


      mail(
    subject: " #{@user.company.name}- Facture impayée",
    to: @company.email,
    from: 'contact@billr.eu',
    html_body: '',
    track_opens: 'true',
    message_stream: 'outbound')
  end

end
