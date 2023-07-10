class AddColumnsToDoctor < ActiveRecord::Migration[7.0]
  def change
    add_column :doctors, :city, :string
    add_column :doctors, :availability, :boolean
  end
end
