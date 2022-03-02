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
    render :index
  end

  def sent
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
