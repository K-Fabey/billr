class InvoicesController < ApplicationController

  def show

  end

  def new

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

  private

  # def invoice_params
  #   params.require(:invoice).permit(:sender_id, :invoice_files)
  # end

end
