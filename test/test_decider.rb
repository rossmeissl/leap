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
end
