class InvoicesController < ApplicationController
  def new
    @user = current_user
    @invoice = Invoice.new
    authorize @invoice
  end

  def create
    @invoice = Invoice.new
    @invoice.sender = company.find(params[:sender_id])
    # @invoice.recipient = company.find(params[:recipient_id])

    if @invoice.save!
      redirect_to_invoice_path(@invoice)
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
    # @invoices = policy_scope(Invoice)
    @invoices = Invoice.all
  end

  def received
    @user = current_user
    #@invoices = policy_scope(Invoice)
    current_company = @user.company
    @received_invoices = Invoice.where( recipient: current_company)
    @invoices = @received_invoices
    authorize @invoices
    render :index
  end

  def sent
    @user = current_user
    # @invoices = policy_scope(Invoice)
    current_company = @user.company
    @sent_invoices = Invoice.where( sender: current_company)
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
    params.require(:invoice).permit(:sender_id, :recipient_id, :invoice_files)
  end

  def set_invoice
    @invoice = Invoice.find(params[:id])
  end

end
