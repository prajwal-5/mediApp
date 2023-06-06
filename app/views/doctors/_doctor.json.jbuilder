json.extract! doctor, :id, :name, :address, :image_url, :created_at, :updated_at
json.url doctor_url(doctor, format: :json)
