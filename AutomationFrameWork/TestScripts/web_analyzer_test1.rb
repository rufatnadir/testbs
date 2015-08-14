require_relative '../../../test_automation/app/models/workspace_analyzer'

#analyzer = WorkspaceAnalyzer.new('dwGqjhXc8pJ2ccrxutrf','acceptance',:debug)

#analyzer = WorkspaceAnalyzer.new('9cECnSuhJyDrMySNsZk9','staging',:debug)

#analyzer = WorkspaceAnalyzer.new('P-u4M_9Y2wAjq_vUv9DX','production',:debug)

analyzer = WorkspaceAnalyzer.new('X4p2XszxgsK4tgqKXJEs','production', :summaryonly)

puts analyzer.results