require 'helper'

describe Leap do
  describe "A generic person" do
    before do
      @person = Person.new
    end
    
    it 'still has a lucky number' do
      assert_equal 0, @person.lucky_number
    end
    
    it 'naturally receives an International Psychics Association-compliant lucky number' do
      assert_equal [:ipa], @person.deliberations[:lucky_number].compliance
    end
  end
  
  describe "An aged person" do
    before do
      @person = Person.new :age => 5
    end
    
    it 'indeed has a lucky number' do
      assert_equal 36, @person.lucky_number
    end
    
    it 'nevertheless remembers how his lucky number was determined' do
      assert_equal({:magic_integer => 6, :lucky_number => 36, :age => 5, :litmus => {}}, @person.deliberations[:lucky_number].characteristics)
      assert_equal 'ninja style', @person.deliberations[:lucky_number].reports.find{ |r| r.committee.name == :magic_integer }.quorum.name
    end
    
    it 'only gives quorums what they ask for' do
      assert_equal({}, @person.deliberations[:lucky_number].reports.find{ |r| r.committee.name == :litmus }.conclusion)
    end
    
    it "doesn't receive an International Psychics Association-compliant lucky number unless he asks for it" do
      assert_equal [], @person.deliberations[:lucky_number].compliance
    end
  end
  
  describe "A clever aged person" do
    before do
      @person = Person.new :magic_integer => 42, :age => 5
    end
    
    it 'can use his own magic integer in determining his lucky number' do
      assert_equal 1764, @person.lucky_number
    end
  end
  
  describe "A named person" do
    before do
      @person = Person.new :name => 'Matz'
    end
    
    it 'has access to the super magic method' do
      assert_equal 1, @person.lucky_number
    end
    
    it 'can stay in compliance with International Psychics Association guidelines' do
      assert_equal 0, @person.lucky_number(:comply => :ipa)
    end
  end
  
  describe "A generic place" do
    before do
      @place = Place.new
    end
    
    it 'has decent weather' do
      assert_equal :decent, @place.weather
    end
  end
  
  describe "Vermont" do
    before do
      @place = Place.new :name => 'Vermont', :seasonality => { :summer => :warm, :winter => :cold }
    end
    
    it 'is warm in the summer' do
      assert_equal :warm, @place.weather(:summer)
    end
  end
  
  describe "A lazy subject" do
    before do
      @thing = Thing.new
      @thing.anything rescue nil
    end
    
    it 'has proper implicit characteristics' do
      assert_equal Hash.new, @thing.deliberations[:anything].characteristics
    end
  end
  
  describe "An impossible decision" do
    before do
      @thing = Thing.new
    end
    
    it 'is impossible to make' do
      assert_raises(::Leap::NoSolutionError, /No solution was found for "anything"/) do
        @thing.anything
      end
    end
  end
  
  describe "A difficult decision" do
    before do
      @person = Person.new :name => 'Bozo'
    end
    
    it 'provides details about its apparent impossibility' do
      assert_raises(::Leap::NoSolutionError, /No solution was found for "lucky_number".*magic_float: ancient recipe, name: provided as input/) do
        @person.lucky_number :comply => :zeus
      end
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
      Leap.send :remove_class_variable, :@@logger
      Leap.send :remove_class_variable, :@@whip
    end
    it "doesn't interfere with computation" do
      @person = Person.new :age => 5
      assert_equal 36, @person.lucky_number.to_i
    end
  end
  
  describe 'Seamus deciding about whether he can commit to a date' do
    before do
      @seamus = Seamus.new
    end
    
    it 'works for most people' do
      assert_equal :maybe, @seamus.can_i_commit_to_that_date
    end
    
    it 'works for BenT, who is easygoing' do
      assert_equal :maybe, @seamus.can_i_commit_to_that_date(:comply => :bent)
    end
    
    it 'never works for andy' do
      assert_raises ::Leap::NoSolutionError do
        @seamus.can_i_commit_to_that_date(:comply => :andy)
      end
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
    
    it 'remembers options that it was given when it was created' do
      assert_equal :length, Owl.decisions[:eye_size].committees.first.options[:measures]
    end
  end
  
  describe 'A decision without a master committee' do
    before do
      @idea = Idea.new
      @bad_idea = Idea.new(100, 10) # gotchas, caveats
    end
    
    it 'still computes' do
      @idea.value
      assert_equal({:cost => 0, :benefit => 9, :caveats => 1, :hangups => 0}, @idea.deliberations[:value].characteristics)
    end
    
    it 'provides easy access to committee reports' do
      assert_equal 0, @idea.value[:cost]
    end
    
    it 'provides compliance specific to a certain conclusion' do
      # If hangups does not comply with common sense, neither should cost
      assert_equal [], @idea.deliberations[:value].compliance(:hangups)
      assert_equal [], @idea.deliberations[:value].compliance(:benefit)
      assert_equal [], @idea.deliberations[:value].compliance(:cost)
      
      # If hangups complies with common sense, cost should also
      assert_equal [:common_sense], @bad_idea.deliberations[:value].compliance(:hangups)
      assert_equal [:common_sense], @bad_idea.deliberations[:value].compliance(:cost)
      
      # User input complies with all standards
      assert_equal [:wisdom], @bad_idea.deliberations[:value].compliance(:benefit)
    end
    
    it 'only returns compliant values when compliance is requested and endpoint is unknown' do
      # Nothing complies
      assert_equal({}, @idea.value(:comply => :common_sense).characteristics)
      
      # Everything but benefit complies
      assert_equal({:gotchas => 100, :caveats => 10, :hangups => 100, :cost => 100}, @bad_idea.value(:comply => :common_sense).characteristics)
    end
    
    it 'returns an error message when known endpoint cannot be achieved' do
      assert_raises(::Leap::NoSolutionError, /No solution was found for "benefit"/) do
        @idea.value(:comply => { :common_sense => :benefit })
      end
      
      assert_raises(::Leap::NoSolutionError, /No solution was found for "benefit"/) do
        @bad_idea.value(:comply => { :common_sense => :benefit })
      end
    end

    it 'returns compliant values when compliance is requested for specific committees' do
      assert_equal 100, @bad_idea.value(:comply => { :common_sense => :cost })[:cost]
    end
  end
end
