json.array!(@kids) do |kid|
  json.extract! kid, :id, :first_name, :last_name, :dob, :user_id
  json.url kid_url(kid, format: :json)
end
