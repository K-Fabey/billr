class InvoicesController < ApplicationController
  include CloudinaryHelper
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

    authorize @invoice
    if current_user.company_id == @invoice.recipient_id
      @invoice.status = "received"
      @type = "received"
    else
      @invoice.status = "created"
      @type = "sent"
    end

    # Changer les valeurs ci-dessous pour les faire correspondre à la facture de la démo

    @invoice.issue_date = "2022-03-05"
    @invoice.payment_deadline = "2022-03-18"
    @invoice.po_number = "INV0048666"
    @invoice.vat_rate = 20
    @invoice.total_wo_tax = 20000
    @invoice.payment_method = "Virement"
    @invoice.tax_amount = 4000
    @invoice.total_w_tax = 24000

    if @invoice.save
      flash[:notice] = "Facture créée"
      if @type == "received"
        redirect_to received_invoices_path
      else
        redirect_to sent_invoices_path
      end
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
    @type = params[:type]

    @user = current_user
    @current_company = current_user.company

    @invoices = policy_scope(Invoice).order(created_at: :desc)

    if @type == "received"
      @invoices = @current_company.received_invoices
    else
      @invoices = @current_company.sent_invoices
    end

    if params[:company].present?
      @invoices = @invoices.search_by_company_client_and_date(params[:company])
    end

    if params[:status].present?
      @invoices = @invoices.where(status: params[:status])
    end

    if params[:date].present?
      if params[:date].include?("to")
        start_date = params[:date].split(" to ").first.to_date
        end_date   = params[:date].split(" to ").second.to_date

        # start_date, end_date = params[:date].split(" to ")

        @invoices = @invoices.where("issue_date >= ? AND issue_date <= ?", start_date, end_date)
      else
        @invoices = @invoices.where(issue_date: params[:date])
      end
    end

    @total_amount = 0
    @invoices.each do |i|
      @total_amount = @total_amount + i.total_w_tax
    end
    # raise
  end

  def received
    @type = "received"
    @user = current_user
    @current_company = current_user.company
    @received_invoices = @current_company.received_invoices
    @partners = @current_company.partners
    @status = Invoice::RECEIVED_STATUSES
    # raise
    @invoices = @received_invoices.order(created_at: :desc)
    authorize @invoices
    @status = params[:status]

    # Setting the list to display by default (no search)
    if params[:status].present?
      @invoices = @invoices.where(status: params[:status])
    end

    @total_amount = 0
    @invoices.each do |i|
      @total_amount = @total_amount + i.total_w_tax
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
    @status = Invoice::SENT_STATUSES
    @invoices = @sent_invoices.order(created_at: :desc)
    authorize @invoices
    @status = params[:status]

    if params[:status].present?
      @invoices = @invoices.where(status: params[:status])
    end

    # if params[:query_company].present? || params[:query_status].present? || params[:query_date].present?
    #   search_query = params[:query_company] + " " + params[:query_status]
    #   # @received_invoices = @current_company.received_invoices
    #   # @invoices = (@received_invoices + @sent_invoices).search_by_company_client_and_date(search_query)
    #   start_date = params["query_date"].split(" to ").first.to_date
    #   end_date = params["query_date"].split(" to ").second.to_date
    #   @invoices = Invoice.search_by_company_client_and_date(search_query) # TODO : fixme
    #   @invoices = @invoices.where("issue_date >= ? AND issue_date <= ?", start_date, end_date)
    # end

    @total_amount = 0
    @invoices.each do |i|
      @total_amount = @total_amount + i.total_w_tax
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
    # images = []
    # if @invoice.invoice_file.attached?
    #   images << cl_image_path(@invoice.invoice_file.key, format: :png, width:'600px')
    # end
    authorize @invoice
  #   session = Stripe::Checkout::Session.create(
  #   payment_method_types: ['card'],
  #   line_items: [{
  #     description: "OFFICE DEPOT",
  #     images: images,
  #     name: @invoice.po_number,
  #     amount: 66000,
  #     # amount: (@invoice.total_w_tax*100).to_i,
  #     currency: 'eur',
  #     quantity: 1
  #   }],
  #   success_url: invoice_url(@invoice),
  #   cancel_url: invoice_url(@invoice)
  # )
  #  @invoice.update(checkout_session_id: session.id, status: 'payment in process')
  #  redirect_to session[:url]
  #  @invoice.update(invoice_params)
    @invoice.update(status: 'paid')
    redirect_to received_invoices_path
    flash[:notice] = "Un virement de #{@invoice.total_w_tax.round(2)} € transmis à votre banque sera exécuté sous 3 jours."
  end

  def mark_as_paid
    @invoice.update(status: 'paid')
    authorize @invoice
    redirect_to received_invoices_path
    flash[:notice] = "Un virement de #{@invoice.total_w_tax.round(2)} € transmis à votre banque sera exécuté sous 3 jours."
  end

  def send_to_partner
    @invoice.update(status: 'sent')
    authorize @invoice
    CompanyMailer.send_invoice(@invoice, current_user).deliver_now
    redirect_to sent_invoices_path
    flash[:notice] = "La facture a été envoyée à l’entreprise #{@invoice.recipient.name}"
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
