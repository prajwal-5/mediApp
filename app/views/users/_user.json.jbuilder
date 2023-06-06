json.extract! user, :id, :name, :email, :currency, :created_at, :updated_at
json.url user_url(user, format: :json)
