class Adddefaulttoboolean < ActiveRecord::Migration[6.1]
  def change
    change_column_default(:invoices, :archived, from: nil, to: false)
  end
end
