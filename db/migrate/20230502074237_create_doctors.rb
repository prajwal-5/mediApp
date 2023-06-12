class CreateDoctors < ActiveRecord::Migration[7.0]
  def change
    create_table :doctors do |t|
      t.string :name
      t.text :address
      t.string :image_url
      t.datetime :clinic_start_time
      t.datetime :clinic_end_time
      t.datetime :lunch_start_time
      t.datetime :lunch_end_time

      t.timestamps
    end
  end
end
