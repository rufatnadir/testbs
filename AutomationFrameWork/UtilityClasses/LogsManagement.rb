require_relative  '../UtilityClasses/Driver'
require 'logger'

class LogsManagement


  #This method remove the log files which are created sometime before
  # the max age identified in the parameter, so if max age 14, any log
  # file older than 14 days will be removed.

  def self.RemoveLogFilesInDaysOlderThan(max_age)
    directory = SeleniumController.GetProjectDirectory + 'test_automation/Test/Logs'
    file_pattern = '*.log'
    #max_age = 14
    unless File.exists?(directory)
      puts "Bad directory #{directory}!"
      exit 2
    end

    unless max_age > 0
      puts "Max age must be greater than zero! I don't want to remove ALL your files!"
      exit 3
    end

    Dir.chdir(directory)
    Dir.glob(file_pattern).each { |filename|

      current_time = Time.now
      file_creation_time = File.ctime(filename)
      file_age = (current_time - file_creation_time)/(24*3600)
      if (file_age > max_age)
        File.delete(filename)
      end
    }
    #puts "Checked and removed any log files older than #{max_age} days"
  end




end
