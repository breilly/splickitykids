json.array!(@activities) do |activity|
  json.extract! activity, :id, :name, :description, :price
  json.url activity_url(activity, format: :json)
end
