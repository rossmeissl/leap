require 'helper'

class TestLeap < Test::Unit::TestCase
  context "A generic person" do
    setup do
      @person = Person.new
    end
    
    should 'still have a lucky number' do
      assert_equal 0, @person.lucky_number
    end
  end
  
  context "An aged person" do
    setup do
      @person = Person.new :age => 5
    end
    
    should 'indeed have a lucky number' do
      assert_equal 36, @person.lucky_number
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
end
