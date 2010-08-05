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
      @person.lucky_number
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
      @person.lucky_number # make the decision
      assert_equal({ :magic_integer => 6, :lucky_number => 36, :age => 5, :litmus => {}}, @person.deliberations[:lucky_number].characteristics)
      assert_equal 'ninja style', @person.deliberations[:lucky_number].reports.find{ |r| r.committee.name == :magic_integer }.quorum.name
    end
    
    should 'but only as long as it had actually been determined' do
      assert_nil @person.deliberations
    end
    
    should 'only give quorums what they ask for' do
      @person.lucky_number # make the decision
      assert_equal({}, @person.deliberations[:lucky_number].reports.find{ |r| r.committee.name == :litmus }.conclusion)
    end
    
    should 'not receive an International Psychics Association-compliant lucky number unless he asks for it' do
      @person.lucky_number
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
  
  context "An impossible decision" do
    setup do
      @thing = Thing.new
    end
    
    should 'be impossible to make' do
      assert_raise ::Leap::NoSolutionError do
        @thing.anything
      end
    end
  end
end
