module Leap
  # Encapsulates a set of strategies to determine a potentially non-obvious attribute of a Leap subject.
  class Decision
    # The goal of the decision, as defined by the first parameter of <tt>Leap::Subject#decide</tt>.
    attr_reader :goal
    
    # The method name used to retrieve a curated hash of the subject instance's attributes for use during deliberation. Initially defined by the <tt>:with</tt> option on <tt>Leap::Subject#decide</tt>. 
    attr_reader :signature_method
    
    # Returns the array of committees defined within the decision block.
    attr_reader :committees
    
    # Creates a <tt>Leap::Decision</tt> object with a given goal.
    #
    # Generally you won't initialize a <tt>Leap::Decision</tt> directly; <tt>Leap::Subject#decide</tt> does it for you.
    #
    # @param [Symbol] goal The ultimate goal of the decision--what are we trying to decide about the subject?
    # @param [Hash] options
    # @option [optional, Symbol] with The name of an instance method on the subject that will, when called, provide a Hash of curated attributes about itself. <a href="http://github.com/brighterplanet/charisma">Charisma</a> is great for this. If this option is not provided, Leap will use a low-budget alternative (see <tt>Leap::ImplicitAttributes</tt>)
    def initialize(goal, options)
      @goal = goal
      @signature_method = options[:with] || :_leap_implicit_attributes
      @committees = []
    end
    
    # Answers whether or not the decision has a "master committee"--a committee with the same name as the decision's goal.
    def mastered?
      !!committees.find { |committee| committee.name == goal }
    end
    
    # Make the decision.
    #
    # General you won't call this directly, but rather use the dynamically-created method with this decision's goal as its name on the subject instance.
    # @see Leap::GoalMethodsDocumentation
    def make(characteristics, options, *considerations)
      Leap.log.decision "Leaping to conclusion", goal
      Leap.log.decision "Initial characteristics: #{characteristics.inspect}", goal
      committees.reject { |c| characteristics.keys.include? c.name }.reverse.inject(Deliberation.new(characteristics)) do |deliberation, committee|
        Leap.instrument.committee committee.name do
          if report = committee.report(deliberation.characteristics, considerations, options)
            Leap.log.committee "Success", committee.name
            deliberation.reports.unshift report
            deliberation.characteristics[committee.name] = report.conclusion
          end
          Leap.log.decision "Updated characteristics: #{deliberation.characteristics.inspect}", goal
        end
        deliberation
      end
    end
    
    # Define a committee within the decision.
    #
    # Used within a <tt>Leap::Subject#decide</tt> block to define a new committee. See <tt>Leap::Committee</tt> for details.
    # @param [Symbol] name The name of the attribute that the committee will return.
    # @param [Hash, optional] options Any options you wish the committee to remember (for third-party use).
    def committee(name, options = {}, &blk)
      committee = ::Leap::Committee.new(name, options)
      @committees << committee
      committee.instance_eval(&blk)
    end
  end
end
