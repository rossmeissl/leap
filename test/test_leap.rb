require 'helper'

describe Leap do
  describe "A generic person" do
    before do
      @person = Person.new
    end
    
    it 'still have a lucky number' do
      @person.lucky_number.must_equal 0
    end
    
    it 'naturally receive an International Psychics Association-compliant lucky number' do
      @person.deliberations[:lucky_number].compliance.must_equal [:ipa]
    end
  end
  
  describe "An aged person" do
    before do
      @person = Person.new :age => 5
    end
    
    it 'indeed have a lucky number' do
      @person.lucky_number.must_equal 36
    end
    
    it 'nevertheless remember how his lucky number was determined' do
      @person.deliberations[:lucky_number].characteristics.must_equal(:magic_integer => 6, :lucky_number => 36, :age => 5, :litmus => {})
      @person.deliberations[:lucky_number].reports.find{ |r| r.committee.name == :magic_integer }.quorum.name.must_equal 'ninja style'
    end
    
    it 'only give quorums what they ask for' do
      @person.deliberations[:lucky_number].reports.find{ |r| r.committee.name == :litmus }.conclusion.must_equal({})
    end
    
    it 'not receive an International Psychics Association-compliant lucky number unless he asks for it' do
      @person.deliberations[:lucky_number].compliance.must_equal []
    end
  end
  
  describe "A clever aged person" do
    before do
      @person = Person.new :magic_integer => 42, :age => 5
    end
    
    it 'be able to use his own magic integer in determining his lucky number' do
      @person.lucky_number.must_equal 1764
    end
  end
  
  describe "A named person" do
    before do
      @person = Person.new :name => 'Matz'
    end
    
    it 'have access to the super magic method' do
      @person.lucky_number.must_equal 1
    end
    
    it 'be able to stay in compliance with International Psychics Association guidelines' do
      @person.lucky_number(:comply => :ipa).must_equal 0
    end
  end
  
  describe "A generic place" do
    before do
      @place = Place.new
    end
    
    it 'have decent weather' do
      @place.weather.must_equal :decent
    end
  end
  
  describe "Vermont" do
    before do
      @place = Place.new :name => 'Vermont', :seasonality => { :summer => :warm, :winter => :cold }
    end
    
    it 'be warm in the summer' do
      @place.weather(:summer).must_equal :warm
    end
  end
  
  describe "A lazy subject" do
    before do
      @thing = Thing.new
      @thing.anything rescue nil
    end
    
    it 'have proper implicit characteristics' do
      @thing.deliberations[:anything].characteristics.must_equal Hash.new
    end
  end
  
  describe "An impossible decision" do
    before do
      @thing = Thing.new
    end
    
    it 'be impossible to make' do
      lambda do
        @thing.anything
      end.must_raise(::Leap::NoSolutionError, /No solution was found for "anything"/)
    end
  end
  
  describe "A difficult decision" do
    before do
      @person = Person.new :name => 'Bozo'
    end
    
    it 'provide details about its apparent impossibility' do
      lambda do
        @person.lucky_number :comply => :zeus
      end.must_raise(::Leap::NoSolutionError, /No solution was found for "lucky_number".*magic_float: ancient recipe, name: provided as input/)
    end
  end

  describe "Instrumentation" do
    before do
      @old_stdout = $stdout
      $stdout = StringIO.new
      Leap.instrument!
    end
    after do
      $stdout = @old_stdout
      Leap.remove_class_variable :@@logger
      Leap.remove_class_variable :@@whip
    end
    it 'not interfere with computation' do
      @person = Person.new :age => 5
      @person.lucky_number.to_i.must_equal 36
    end
  end
  
  describe 'Seamus deciding about whether he can commit to a date' do
    before do
      @seamus = Seamus.new
    end
    
    it 'work for most people' do
      @seamus.can_i_commit_to_that_date.must_equal :maybe
    end
    
    it 'work for BenT, who is easygoing' do
      @seamus.can_i_commit_to_that_date(:comply => :bent).must_equal :maybe
    end
    
    it 'never work for andy' do
      lambda do
        @seamus.can_i_commit_to_that_date(:comply => :andy)
      end.must_raise(::Leap::NoSolutionError)
    end
  end
  
  describe 'A committee' do
    before do
      class Owl
        include Leap
        decide :eye_size do
          committee :eye_size, :measures => :length do
          end
        end
      end
    end
    
    it 'remember options that it was given when it was created' do
      Owl.decisions[:eye_size].committees.first.options[:measures].must_equal :length
    end
  end
  
  describe 'A decision without a master committee' do
    before do
      @idea = Idea.new
      @bad_idea = Idea.new(100, 10) # gotchas, caveats
    end
    
    it 'still compute' do
      @idea.value
      @idea.deliberations[:value].characteristics.must_equal(:cost => 0, :benefit => 9, :caveats => 1, :hangups => 0)
    end
    
    it 'provide easy access to committee reports' do
      @idea.value[:cost].must_equal 0
    end
    
    it 'provide compliance specific to a certain conclusion' do
      # If hangups does not comply with common sense, neither should cost
      @idea.deliberations[:value].compliance(:hangups).must_equal []
      @idea.deliberations[:value].compliance(:benefit).must_equal []
      @idea.deliberations[:value].compliance(:cost).must_equal []
      
      # If hangups complies with common sense, cost should also
      @bad_idea.deliberations[:value].compliance(:hangups).must_equal [:common_sense]
      @bad_idea.deliberations[:value].compliance(:cost).must_equal [:common_sense]
      
      # User input complies with all standards
      @bad_idea.deliberations[:value].compliance(:benefit).must_equal [:wisdom]
    end
    
    it 'only return compliant values when compliance is requested and endpoint is unknown' do
      # Nothing complies
      @idea.value(:comply => :common_sense).characteristics.must_equal({})
      
      # Everything but benefit complies
      @bad_idea.value(:comply => :common_sense).characteristics.must_equal(:gotchas => 100, :caveats => 10, :hangups => 100, :cost => 100)
    end
    
    it 'return an error message when known endpoint cannot be achieved' do
      lambda do
        @idea.value(:comply => { :common_sense => :benefit })
      end.must_raise(::Leap::NoSolutionError, /No solution was found for "benefit"/)
      
      lambda do
        @bad_idea.value(:comply => { :common_sense => :benefit })
      end.must_raise(::Leap::NoSolutionError, /No solution was found for "benefit"/)
    end

    should 'return compliant values when compliance is requested for specific committees' do
      assert_equal 100, @bad_idea.value(:comply => { :common_sense => :cost })[:cost]
    end
  end
end
