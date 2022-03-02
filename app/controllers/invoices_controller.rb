class InvoicesController < ApplicationController

  def show
    @invoice = Invoice.find(params[:id])
  end

  def new
    @invoice = Invoice.new()
  end

  def create
    @invoice = Invoice.new()
    @invoice.sender = company.find(params[:sender_id])
    # @invoice.recipient = company.find(params[:recipient_id])


    if @invoice.save!
      redirect_to_invoice_path(@invoice)
    else
      render :new
    end
  end

  def received
    # raise
    current_company = current_user.company
    @received_invoices = Invoice.where( recipient: current_company)
    @invoices = @received_invoices
    @company_status = "Fournisseur"

    render :index
  end

  def sent
    current_company = current_user.company
    @sent_invoices = Invoice.where( sender: current_company)
    @invoices = @sent_invoices
    @company_status = "Client"

    # raise
    render :index
  end

  def validate

  end

  def decline

  end

  def pay

  end

  def mark_as_pay

  end

  def send_to_partner

  end

  def follow_up

  end

  def mark_as_paid

  end

  private

  # def invoice_params
  #   params.require(:invoice).permit(:sender_id, :invoice_files)
  # end

end
