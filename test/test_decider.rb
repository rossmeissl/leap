require 'helper'

class TestDecider < Test::Unit::TestCase
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
end
