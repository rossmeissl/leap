require 'helper'

class TestLeap < Test::Unit::TestCase
  context "A generic person" do
    setup do
      @person = Person.new
    end
    
    should 'still have a lucky number' do
      assert_equal 0, @person.lucky_number
    end
    
    should 'naturally receive an International Psychics Association-compliant lucky number' do
      assert_equal [:ipa], @person.deliberations[:lucky_number].compliance
    end
  end
  
  context "An aged person" do
    setup do
      @person = Person.new :age => 5
    end
    
    should 'indeed have a lucky number' do
      assert_equal 36, @person.lucky_number
    end
    
    should 'nevertheless remember how his lucky number was determined' do
      assert_equal(@person.deliberations[:lucky_number].characteristics, { :magic_integer => 6, :lucky_number => 36, :age => 5, :litmus => {}})
      assert_equal 'ninja style', @person.deliberations[:lucky_number].reports.find{ |r| r.committee.name == :magic_integer }.quorum.name
    end
    
    should 'only give quorums what they ask for' do
      assert_equal({}, @person.deliberations[:lucky_number].reports.find{ |r| r.committee.name == :litmus }.conclusion)
    end
    
    should 'not receive an International Psychics Association-compliant lucky number unless he asks for it' do
      assert_equal [], @person.deliberations[:lucky_number].compliance
    end
  end
  
  context "A clever aged person" do
    setup do
      @person = Person.new :magic_integer => 42, :age => 5
    end
    
    should 'be able to use his own magic integer in determining his lucky number' do
      assert_equal 1764, @person.lucky_number
    end
  end
  
  context "A named person" do
    setup do
      @person = Person.new :name => 'Matz'
    end
    
    should 'have access to the super magic method' do
      assert_equal 1, @person.lucky_number
    end
    
    should 'be able to stay in compliance with International Psychics Association guidelines' do
      assert_equal 0, @person.lucky_number(:comply => :ipa)
    end
  end
  
  context "A generic place" do
    setup do
      @place = Place.new
    end
    
    should 'have decent weather' do
      assert_equal :decent, @place.weather
    end
  end
  
  context "Vermont" do
    setup do
      @place = Place.new :name => 'Vermont', :seasonality => { :summer => :warm, :winter => :cold }
    end
    
    should 'be warm in the summer' do
      assert_equal :warm, @place.weather(:summer)
    end
  end
  
  context "A lazy subject" do
    setup do
      @thing = Thing.new
      @thing.anything rescue nil
    end
    
    should 'have proper implicit characteristics' do
      assert_equal Hash.new, @thing.deliberations[:anything].characteristics
    end
  end
  
  context "An impossible decision" do
    setup do
      @thing = Thing.new
    end
    
    should 'be impossible to make' do
      exception = assert_raise ::Leap::NoSolutionError do
        @thing.anything
      end
      
      assert_match(/No solution was found for "anything"/, exception.message)
    end
  end
  
  context "A difficult decision" do
    setup do
      @person = Person.new :name => 'Bozo'
    end
    
    should 'provide details about its apparent impossibility' do
      exception = assert_raise ::Leap::NoSolutionError do
        @person.lucky_number :comply => :zeus
      end
      
      assert_match(/No solution was found for "lucky_number"/, exception.message)
      assert_match(/magic_float: ancient recipe, name: provided as input/, exception.message)
    end
  end
  
  context 'Seamus deciding about whether he can commit to a date' do
    setup do
      @seamus = Seamus.new
    end
    
    should 'work for most people' do
      assert_equal :maybe, @seamus.can_i_commit_to_that_date
    end
    
    should 'work for BenT, who is easygoing' do
      assert_equal :maybe, @seamus.can_i_commit_to_that_date(:comply => :bent)
    end
    
    should 'never work for andy' do
      assert_raise ::Leap::NoSolutionError do
        @seamus.can_i_commit_to_that_date(:comply => :andy)
      end
    end
  end
  
  context 'A committee' do
    setup do
      class Owl
        include Leap
        decide :eye_size do
          committee :eye_size, :measures => :length do
          end
        end
      end
    end
    
    should 'remember options that it was given when it was created' do
      assert_equal :length, Owl.decisions[:eye_size].committees.first.options[:measures]
    end
  end
  
  context 'A decision without a master committee' do
    setup do
      @idea = Idea.new
      @bad_idea = Idea.new 100 # gotchas
    end
    
    should 'still compute' do
      @idea.value
      assert_equal({:cost => 0, :benefit => 1, :hangups => 0, :gotchas => nil}, @idea.deliberations[:value].characteristics)
    end
    
    should 'provide easy access to committee reports' do
      assert_equal 0, @idea.value[:cost]
    end
    
    should 'provide compliance specific to a certain conclusion' do
      # If hangups does not comply with common sense, neither should cost
      assert_equal [], @idea.deliberations[:value].compliance(:hangups)
      assert_equal [], @idea.deliberations[:value].compliance(:cost)
      
      # If hangups complies with common sense, cost should also
      assert_equal [:common_sense], @bad_idea.deliberations[:value].compliance(:hangups)
      assert_equal [:common_sense], @bad_idea.deliberations[:value].compliance(:cost)
    end
    
    should 'provide details about the impossibility of a difficult decision' do
      exception = assert_raise ::Leap::NoSolutionError do
        @idea.value :comply => :common_sense
      end
      assert_match(/No solution was found for "cost"/, exception.message)
      assert_match(/benefit: 1, hangups: 0/, exception.message)
    end
  end
end
