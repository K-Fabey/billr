class InvoicesController < ApplicationController
  before_action :set_invoice, only: [:show, :validate, :decline_reason, :pay, :mark_as_paid, :follow_up, :send_to_partner]
  def new
    @invoice = Invoice.new
    @type = params[:type]
    authorize @invoice

    if @type == "received"
      @invoice.recipient = current_user.company
      @companies = current_user.company.suppliers.order(:name)
    else
      @invoice.sender = current_user.company
      @companies = current_user.company.clients.order(:name)
    end
  end

  def create
    @invoice = Invoice.new(invoice_params)
    @type = params[:type]

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
    authorize @invoice
  end

  def index
    @user = current_user
    @invoices = Invoice.all
  end

  def received
    @type = "received"
    @user = current_user
    current_company = current_user.company
    @received_invoices = current_company.received_invoices
    @invoices = @received_invoices
    @status = params[:status]
    if params[:status].present?
      @invoices = @invoices.where(status: params[:status])
    end
    if params[:query_status].present?
      @invoices = Invoices.where(status: params[:query_status])
    end

    # raise
    authorize @invoices
    render :index
  end

  def sent
    @type = "sent"
    @user = current_user
    current_company = current_user.company
    @sent_invoices = current_company.sent_invoices
    @companies = current_company.partners
    @invoices = @sent_invoices
    @status = params[:status]
    if params[:status].present?
      @invoices = @invoices.where(status: params[:status])
    end
    if params[:query_client].present? || params[:query_status].present? || params[:query_date].present?
      @invoices = Invoice.where(status: params[:query_status], date: params[:query_date] )
      # @invoices = Invoice.where(company.name: params[:query_client], status: params[:query_status], date: params[:query_date] )
    end
    authorize @invoices
    render :index
  end

  def validate
    @invoice.update(status: 'validated')
    authorize @invoice
    redirect_to invoice_path(@invoice)
    flash[:notice] = "Facture validée !"
  end

  def decline_reason
    @invoice.update(invoice_params)
    @invoice.update(status: 'declined')
    authorize @invoice
    redirect_to invoice_path(@invoice)
    flash[:notice] = "Facture rejetée : #{@invoice.decline_reason}"
  end

  def pay
    @invoice.update(status: 'payment in process')
    authorize @invoice
    redirect_to invoice_path(@invoice)
    flash[:notice] = "Facture mise en paiement !"
  end

  def mark_as_paid
    @invoice.update(status: 'paid')
    authorize @invoice
    redirect_to invoice_path(@invoice)
    flash[:notice] = "Facture payée !"
  end

  def send_to_partner
    @invoice.update(status: 'sent')
    authorize @invoice
    redirect_to invoice_path(@invoice)
    flash[:notice] = "Facture envoyée !"
  end

  def follow_up
    @invoice.update(status: 'follow_uped')
    authorize @invoice
    redirect_to invoice_path(@invoice)
    flash[:notice] = "Facture relancée !"
  end

  private

  def invoice_params
    params.require(:invoice).permit(:sender_id, :recipient_id, :invoice_file, :decline_reason)
  end

  def set_invoice
    @invoice = Invoice.find(params[:id])
  end
end
