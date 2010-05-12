require 'rubygems'
require 'test/unit'
require 'shoulda'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'leap'

class Test::Unit::TestCase
end

class Person
  attr_reader :name
  attr_reader :age
  attr_reader :date_of_birth
  
  def initialize(options = {})
    @name = options[:name].upcase if options[:name] && options[:name].is_a?(String)
    @age = options[:age].round if options[:age] && options[:age].is_a?(Numeric) && options[:age].round > 0
    @date_of_birth = options[:date_of_birth] if options[:date_of_birth] && options[:date_of_birth].is_a?(Date)
  end
  
  def attributes
    { :name => name, :age => age, :date_of_birth => date_of_birth}.delete_if { |key, val| val.nil? }
  end
  
  include Leap
  decide :lucky_number, :with => :attributes do
    committee :lucky_number do
      quorum 'super magic method', :needs => [:magic_integer, :magic_float] do |characteristics|
        characteristics[:magic_integer] + characteristics[:magic_float]
      end
      
      quorum 'normal magic method', :needs => :magic_integer do |characteristics|
        characteristics[:magic_integer] ** 2
      end
    end
    
    committee :magic_integer do
      quorum 'top-secret technique', :needs => [:magic_float, :age] do |characteristics|
        characteristics[:magic_float].round + characteristics[:age]
      end
      
      quorum 'ninja style', :needs => :age do |characteristics|
        characteristics[:age] + 1
      end

      default do
        0
      end
    end
    
    committee :magic_float do
      quorum 'ancient recipe', :needs => :name do |characteristics|
        ('A'..'Z').to_a.index(characteristics[:name].chars.to_a.first) / ('A'..'Z').to_a.index(characteristics[:name].chars.to_a.last) 
      end
    end
  end
end
