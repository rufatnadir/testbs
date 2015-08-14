require 'selenium-webdriver'
require 'rspec'


require_relative  'Driver'
#Tis will run before each tests
# before(:each) do
#this will run before all the tests only one time.
class Utility
#you can also use :each


  def self.InitializeTest
    before(:all) do
     # @browser = Selenium::WebDriver.for :chrome
      puts 'hey I am initializing before all'
      before(:all) do
      end
    end
  end

  def self.EndTest
    #after(:each) do
    #you can also use :each
    after(:all) do
    end
  end


end

