
require_relative '../../../AutomationFrameWork/PageObject/Login_Page'
require_relative '../../../AutomationFrameWork/PageObject/Dashboard_Page'
require_relative '../../../AutomationFrameWork/PageObject/WorkspacesList_Page'
require_relative '../../../AutomationFrameWork/PageObject/Canvas_Page'
require_relative '../../../AutomationFrameWork/PageObject/UserSettings_Page'
require_relative '../../../AutomationFrameWork/UtilityClasses/BeforeAndAfter'
require_relative '../../../AutomationFrameWork/UtilityClasses/Driver'
require_relative '../../../AutomationFrameWork/PageObject/Browser'
require_relative '../../../AutomationFrameWork/UtilityClasses/LogsManagement'
require 'headless'
require 'simplecov'
require 'logger'




Before do |scenario|
  LogsManagement.RemoveLogFilesInDaysOlderThan(10)
  #chosing and creating the log file to use. the first run condition insure that we dont recreate log every time we run it.
  #we only run this part of code once at the begining of each feature.
  if $temp_feature_name != scenario.feature.name
    puts 'new feature'
    $log = Logger.new(File.new(SeleniumController.GetProjectDirectory + 'test_automation/Test/Logs/LogReport_' + scenario.feature.name + '.log', 'w'))
    #DEBUG < INFO < WARN < ERROR < FATAL < UNKNOWN
    $log.level = Logger::DEBUG
    $log.info 'Starting the feature ' + scenario.feature.name
    # $stdout = File.open 'LogReport_' + scenario.feature.name + '.log', 'a'
  end
  $temp_feature_name = scenario.feature.name
   $log.info 'Executing @scenario: ' + scenario.name + Time.now.strftime(":%d/%m/%Y at %H:%M:%S")
  #this will place puts statments inside the log file instead of projecting them on screen in real time

end


After do |scenario|
  # Do something after each @scenario.
  # The +@scenario+ argument is optional, but
  # if you use it, you can inspect status with
  # the #failed?, #passed? and #exception methods.

  if scenario.failed?
    scenario_title = scenario.name
    pic_name = scenario_title.delete(' ')
    time_and_date = Time.now.strftime("%d_%m_%Y_%H_%M")
    #Uncomment if you would like screenshots on fail.
    Browser.CaptureScreen(SeleniumController.GetProjectDirectory + 'test_automation/Test/CapturedImages/failedScenario' + pic_name +'_' + time_and_date + '.png')
    $log.error "The test @scenario has failed. #{scenario_title}"
    $log.error scenario.to_s
    $log.info 'If enabled, screenshot info at: failedScenario' + pic_name + '_' + time_and_date + '.png'
    #kill the browsHi er for that particular test
    Browser.Stop

    #enable if you would like to stop the whole test run in case of any fails
    #Cucumber.wants_to_quit = true if @scenario.failed?
  else #scenario.passed? #Bug cucumber https://github.com/cucumber/cucumber/issues/724
    $log.info 'Scenario passed'
  end


end


#you can run any specific conditions based on the tags attached for that @scenario, this is an example.

Before('@sal') do
 # puts 'running Sal tests'
#  puts $test_env
 # $test_env = 'Testing Environment is: ' +  page_url
 #Browser.WriteToTheLogFileInfo(test_env)
end

#AfterScenario('@sal') do |@scenario|
 # if @scenario.success?
 #     puts 'Sal @scenario finished'
  #end
#end
at_exit do
  puts 'Finishing tests'
  #In case we are running the test on linux, we are assumed to be running the test headlessly
  # and therefor, we need to close the headless display
  $log.info 'End of Test'
  case RbConfig::CONFIG['host_os']
    when /linux/
      puts 'closing headless display'
      @headless.destroy
  end
end