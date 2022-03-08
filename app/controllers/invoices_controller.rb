class InvoicesController < ApplicationController
  include CloudinaryHelper
  before_action :set_invoice, only: [:show, :validate, :decline_reason, :pay, :mark_as_paid, :follow_up, :send_to_partner]

  RECEIVED_STATUSES = ["received", "payment in process", "validated", "declined", "paid"]
  SENT_STATUSES = ["created", "sent", "paid", "follow_uped"]

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

    @invoice.issue_date = "2022-03-01"
    @invoice.payment_deadline = "2022.03.16"
    @invoice.po_number = "106"
    @invoice.vat_rate = 20
    @invoice.total_wo_tax = 550.00
    @invoice.payment_method = "Virement"
    @invoice.tax_amount = 110.00
    @invoice.total_w_tax = 660.00

    if @invoice.save
      redirect_to invoice_path(@invoice)
    else
      if current_user.company_id == @invoice.recipient_id
        @invoice.recipient = current_user.company
        @companies = current_user.company.suppliers.order(:name)
      else
        @invoice.sender = current_user.company
        @companies = current_user.company.clients.order(:name)
      end
      render :new
    end
  end

  def show
    authorize @invoice
  end

  def index
    @user = current_user
    @invoices = policy_scope(Invoice)

    if params[:query_company].present? || params[:query_status].present? || params[:query_date].present?
      search_query = params[:query_company] + " " + params[:query_status] + " " + params[:query_date]
      # @received_invoices = @current_company.received_invoices
      # @invoices = (@received_invoices + @sent_invoices).search_by_company_client_and_date(search_query)
      @invoices = Invoice.search_by_company_client_and_date(search_query) # TODO : fixme
    end
  end

  def received
    @type = "received"
    @user = current_user
    @current_company = current_user.company
    @received_invoices = @current_company.received_invoices
    @partners = @current_company.partners
    @status = RECEIVED_STATUSES
    # raise
    @invoices = @received_invoices
    authorize @invoices
    @status = params[:status]

    # Setting the list to display by default (no search)
    if params[:status].present?
      @invoices = @invoices.where(status: params[:status])
    end

    # Setting the list to display when a search is done
    if params[:query_company].present? || params[:query_status].present? || params[:query_date].present?
      search_query = params[:query_company] + " " + params[:query_status] + " " + params[:query_date]

      @invoices = Invoice.search_by_company_client_and_date(search_query)

    end

    # raise
    render :index
  end

  def sent
    @type = "sent"
    @user = current_user
    @current_company = current_user.company
    @sent_invoices = @current_company.sent_invoices
    @partners = @current_company.partners
    @status = SENT_STATUSES
    @invoices = @sent_invoices
    authorize @invoices
    @status = params[:status]

    if params[:status].present?
      @invoices = @invoices.where(status: params[:status])
    end

    render :index
  end

  def validate
    @invoice.update(status: 'validated')
    authorize @invoice
    redirect_to received_invoices_path
    flash[:notice] = "Facture validée !"
  end

  def decline_reason
    @invoice.update(invoice_params)
    @invoice.update(status: 'declined')
    authorize @invoice
    redirect_to received_invoices_path
    flash[:notice] = "Facture rejetée : #{@invoice.decline_reason}"
  end

  def pay
    images = []
    if @invoice.invoice_file.attached?
      images << cl_image_path(@invoice.invoice_file.key, format: :png, width:'600px')
    end
    authorize @invoice
    session = Stripe::Checkout::Session.create(
    payment_method_types: ['card'],
    line_items: [{
      description: "OFFICE DEPOT",
      images: images,
      name: @invoice.po_number,
      amount: 66000,
      # amount: (@invoice.total_w_tax*100).to_i,
      currency: 'eur',
      quantity: 1
    }],
    success_url: invoice_url(@invoice),
    cancel_url: invoice_url(@invoice)
  )
    @invoice.update(checkout_session_id: session.id, status: 'payment in process')
    redirect_to session[:url]
    # redirect_to received_invoices_path
    # flash[:notice] = "Facture mise en paiement !"
  end

  def mark_as_paid
    @invoice.update(status: 'paid')
    authorize @invoice
    redirect_to received_invoices_path
    flash[:notice] = "Facture payée !"
  end

  def send_to_partner
    @invoice.update(status: 'sent')
    authorize @invoice
    CompanyMailer.send_invoice(@invoice, current_user).deliver_now
    redirect_to sent_invoices_path
    flash[:notice] = "Facture envoyée !"
  end

  def follow_up
    @invoice.update(status: 'follow_uped')
    authorize @invoice
    CompanyMailer.send_followup(@invoice, current_user).deliver_now
    redirect_to sent_invoices_path
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
