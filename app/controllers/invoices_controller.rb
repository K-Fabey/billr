class InvoicesController < ApplicationController

  def show
    @invoice = Invoice.find(params[:id])
  end

  def new
    @invoice = Invoice.new

    if params[:type] == "received"
      @invoice.recipient = current_user.company
      @companies = current_user.company.suppliers.order(:name)
    else
      @invoice.sender = current_user.company
      @companies = current_user.company.clients.order(:name)
    end
  end

  def create
    @invoice = Invoice.new(invoice_params)

    if current_user.company_id == @invoice.recipient_id
      @invoice.status = "received"
    else
      @invoice.status = "created"
    end

    # Changer les valeurs ci-dessous pour les faire correspondre à la facture de la démo

    @invoice.issue_date = "2022-03-02"
    @invoice.payment_deadline = "2022.04.01"
    @invoice.po_number = "13266"
    @invoice.vat_rate = 20
    @invoice.total_wo_tax = 100
    @invoice.payment_method = "Virement"
    @invoice.tax_amount = 20
    @invoice.total_w_tax = 120

    if @invoice.save
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

    render :index
  end

  def sent
    current_company = current_user.company
    @sent_invoices = Invoice.where( sender: current_company)
    @invoices = @sent_invoices

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

  def invoice_params
    params.require(:invoice).permit(:sender_id, :recipient_id, :invoice_file)
  end

end
