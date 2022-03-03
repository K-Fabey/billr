class InvoicesController < ApplicationController
  def new
    @invoice = Invoice.new
    authorize @invoice

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
    authorize @invoice
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
      redirect_to invoice_path(@invoice)
    else
      render :new
    end
  end

  def show
    set_invoice
    authorize @invoice
  end

  def index
    @user = current_user
    @invoices = Invoice.all
  end

  def received
    @user = current_user
    current_company = current_user.company
    @received_invoices = current_company.received_invoices
    @invoices = @received_invoices
    authorize @invoices
    render :index
  end

  def sent
    @user = current_user
    current_company = current_user.company
    @sent_invoices = current_company.sent_invoices
    @invoices = @sent_invoices
    authorize @invoices
    render :index
  end

  def validate
    render :show
  end

  def decline
    render :show
  end

  def pay
    render :show
  end

  def mark_as_pay
    render :show
  end

  def send_to_partner
    render :show
  end

  def follow_up
    render :show
  end

  def mark_as_paid
    render :show
  end

  private

  def invoice_params
    params.require(:invoice).permit(:sender_id, :recipient_id, :invoice_file)
  end

  def set_invoice
    @invoice = Invoice.find(params[:id])
  end
end
