class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :home ]

  def home
  end

  def dashboard
    @user = current_user

    data1 = current_user.company.received_invoices.group(:status).sum(:total_w_tax).transform_values{ |value| value.fdiv(1000).round(1)}
     @pie_data1 =  {
        "Paiement en cours" => data1["payment in process"],
        "Payées" => data1["paid"],
        "Reçues" => data1["received"],
        "Refusées" => data1["declined"],
        "Validées" => data1["validated"]
      }
      data2 = current_user.company.sent_invoices.group(:status).sum(:total_w_tax).transform_values{ |value| value.fdiv(1000).round(1)}
      @pie_data2 =  {
        "Payées" => data2["paid"],
        "Créées" => data2["created"],
        "Envoyées" => data2["sent"],
        "Relancées" => data2["follow_uped"]
      }
  end
end
