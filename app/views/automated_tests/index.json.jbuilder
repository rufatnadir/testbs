json.array!(@automated_tests) do |automated_test|
  json.extract! automated_test, :id, :testid, :int, :name, :description, :lastrundate, :datetime, :pass, :lastruntext
  json.url automated_test_url(automated_test, format: :json)
end
