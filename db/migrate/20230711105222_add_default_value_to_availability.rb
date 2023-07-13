class AddDefaultValueToAvailability < ActiveRecord::Migration[7.0]
  def change
    change_column_default :doctors, :availability, default: true
  end
end
