require 'rubygems'
require 'bundler/setup'

if Bundler.definition.specs['debugger'].first
  require 'debugger'
elsif Bundler.definition.specs['ruby-debug'].first
  require 'ruby-debug'
end

require 'minitest/unit'
require 'minitest/autorun'
require 'minitest/reporters'
MiniTest::Unit.runner = MiniTest::SuiteRunner.new
MiniTest::Unit.runner.reporters << MiniTest::Reporters::SpecReporter.new

require 'charisma'

require 'leap'

class Person
  attr_reader :name
  attr_reader :age
  attr_reader :date_of_birth
  attr_reader :magic_integer
  
  def initialize(options = {})
    @name = options[:name].upcase if options[:name] && options[:name].is_a?(String)
    @age = options[:age].round if options[:age] && options[:age].is_a?(Numeric) && options[:age].round > 0
    @date_of_birth = options[:date_of_birth] if options[:date_of_birth] && options[:date_of_birth].is_a?(Date)
    @magic_integer = options[:magic_integer] if options[:magic_integer] && options[:magic_integer].is_a?(Integer)
  end
  
  include Charisma
  
  characterize do
    has :name
    has :age
    has :date_of_birth
    has :magic_integer
  end
  
  include Leap
  decide :lucky_number, :with => :characteristics do
    committee :lucky_number do
      quorum 'super magic method', :needs => [:magic_integer, :magic_float] do |characteristics|
        characteristics[:magic_integer] + characteristics[:magic_float].ceil
      end
      
      quorum 'normal magic method', :needs => :magic_integer, :complies => :ipa do |characteristics|
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

      default :complies => :ipa do
        0
      end
    end
    
    committee :magic_float do
      quorum 'ancient recipe', :needs => :name, :complies => :zeus do |characteristics|
        ('A'..'Z').to_a.index(characteristics[:name].chars.to_a.first).to_f / ('A'..'Z').to_a.index(characteristics[:name].chars.to_a.last).to_f 
      end
    end
    
    committee :litmus do
      quorum 'litmus', :appreciates => :dummy, :complies => :ipa do |characteristics|
        characteristics
      end
    end
  end
end

class Place
  attr_reader :name
  attr_reader :seasonality
  
  def initialize(options = {})
    @name = options[:name] if options[:name]
    @seasonality = options[:seasonality] if options[:seasonality]
  end
  
  include Leap
  decide :weather do
    committee :weather do
      quorum 'from seasonality', :needs => :seasonality do |characteristics, season|
        characteristics[:seasonality][season]
      end
      quorum 'default' do
        :decent
      end
    end
  end
end

class Thing
  include Leap
  decide :anything do
    committee(:anything) {}
  end
end

class Seamus
  include Leap
  decide :can_i_commit_to_that_date do
    committee :can_i_commit_to_that_date do
      quorum 'my first instinct', :complies => :bent do |characteristics|
        :maybe
      end
    end
  end
end

class Idea < Struct.new(:gotchas, :caveats)
  def to_hash() Hash[members.map(&:to_sym).zip(values)].reject {|_,v| v.nil?} end
  
  include Leap
  decide :value, :with => :to_hash do
    committee :cost do
      quorum 'based on estimate of hangups', :needs => :hangups, :complies => :common_sense do |characteristics|
        characteristics[:hangups]
      end
    end
    committee :benefit do
      quorum 'based on caveats', :needs => :caveats, :complies => :wisdom do |characteristics|
        10 - characteristics[:caveats]
      end
    end
    committee :caveats do
      quorum('default') {1}
    end
    committee :hangups do
      quorum 'based on estimate of gotchas', :needs => :gotchas, :complies => :common_sense do |characteristics|
        characteristics[:gotchas]
      end
      quorum('default') {0}
    end
  end
end
