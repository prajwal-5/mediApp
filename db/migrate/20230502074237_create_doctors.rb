class CreateDoctors < ActiveRecord::Migration[7.0]
  def change
    create_table :doctors do |t|
      t.string :name
      t.text :address
      t.string :image_url
      t.datetime :clinic_start_time, default: DateTime.civil(2023, 5, 17, 12, 0, 0)
      t.datetime :clinic_end_time, default: DateTime.civil(2023, 5, 17, 16, 0, 0)
      t.datetime :lunch_start_time, default: DateTime.civil(2023, 5, 17, 13, 0, 0)
      t.datetime :lunch_end_time, default: DateTime.civil(2023, 5, 17, 14, 0, 0)

      t.timestamps
    end
  end
end
