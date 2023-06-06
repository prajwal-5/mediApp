class CreateAppointments < ActiveRecord::Migration[7.0]
  def change
    create_table :appointments do |t|
      t.belongs_to :doctor, null: false, foreign_key: true
      t.belongs_to :user, null:false, foreign_key: true
      t.datetime :start_time
      t.datetime :end_time
      t.decimal :cost

      t.timestamps
    end
  end
end
