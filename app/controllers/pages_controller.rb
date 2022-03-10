class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :home ]

  def home
  end

  def dashboard
    @user = current_user

    data1 = current_user.company.received_invoices.group(:status).sum(:total_w_tax).transform_values{ |value| value.fdiv(1000).round(1)}
     @pie_data1 =  {
        "En attente" => data1["received"],
        "Validées" => data1["validated"],
        "Refusées" => data1["declined"],
        "En attente de paiement" => data1["payment in process"],
        "Payées" => data1["paid"]
      }
      data2 = current_user.company.sent_invoices.group(:status).sum(:total_w_tax).transform_values{ |value| value.fdiv(1000).round(1)}
      @pie_data2 =  {
        "Créées" => data2["created"],
        "Envoyées" => data2["sent"],
        "Payées" => data2["paid"],
        "En retard de paiement" => data2["follow_uped"]
      }
  end
end
