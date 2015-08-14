require_relative '../../../test_automation/app/models/workspace_analyzer'

#session_id = ARGV[0]
#analyzer = Analyzer.new(session_id, environment)

analyzer = Analyzer.new('bVqGsQtzNKkaGPdw-E-S', 'staging')
analyzer = Analyzer.new('5pf3V3EggTyGWuTYRzKT', 'production')
analyzer.analyze

#assert_item = CreateItem.new
#assert_item.item_type = 'note'
#assert_item.description = 'Lunch today will be Thai'
#assert_item.description = 'this is card that does not exist'

assert_item = TsxAppEventItem.new
assert_item.item_type = 'tsxappevent'
assert_item.tsx_app_id = 'webbrowser'
assert_item.url = 'http://www.google.com'
#move_array = [315.0, 23]



#if analyzer.find_item('webbrowser', 'http://www.google.com')
#  puts 'found the assert item'
#else
#  puts 'did not find the assert item'
#end

puts analyzer.report(:all)

=begin
 if analyzer.analyze(assert_item)
   puts 'found the assert item'
 else
   puts 'did not find the assert item'
 end
=end

=begin
  if analyzer.find_moved_item('tsxappevent', 'http://www.techcrunch.com', 0, 0, 72.0, -246)
    puts 'found the assert item'
  else
    puts 'did not find the assert item'
  end
end

analyzer.report(:all)

=begin
if analyzer.find_item_in_workspace('note', 'Lunch today will be Thai')
  puts 'found the assert item'
else
  puts 'did not find the assert item'
end

if analyzer.find_item_in_workspace('note', 'non-existent card')
  puts 'found the assert item'
else
  puts 'did not find the assert item'
end
=end

