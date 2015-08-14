json.array!(@workspace_analyzers) do |workspace_analyzer|
  json.extract! workspace_analyzer, :workspace_id, :environment, :results
  json.url workspace_analyzer_url(workspace_analyzer, format: :json)
end
