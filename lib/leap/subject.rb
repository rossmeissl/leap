module Leap
  # In Leap lingo, Subject refers to the host class, instances of which we're trying to arrive at conclusions about.
  # 
  # It is within Subjects that we establish decision-making strategies using <tt>#decide</tt>
  # @see #decide
  module Subject
    # Establishes the <tt>@decisions</tt> class instance variable for accumulating Leap decisions, along with an accessor for their deliberations.
    # Also injects <tt>Leap::ImplicitAttributes</tt>, which provides a low-budget attribute curation method.
    # @see Leap::Decision
    # @see Leap::Deliberation
    # @see Leap::DeliberationsAccessor
    # @see Leap::ImplicitAttributes
    def self.extended(base)
      base.instance_variable_set :@decisions, {}
      base.send :include, ::Leap::ImplicitAttributes
      base.send :include, ::Leap::DeliberationsAccessor
      base.send :include, ::Leap::GoalMethodsDocumentation
    end
    
    # Accumulates <tt>Leap::Decision</tt> objects, having been defined with <tt>#decide</tt>.
    # @see #decide
    attr_reader :decisions
    
    # Defines a new <tt>Leap::Decision</tt> on the subject, using a DSL within its block.
    #
    # The DSL within the block is primarily composed of <tt>Leap::Decision#committee</tt>.
    # Using <tt>#decide</tt> will define a new method on instances of the subject class, named after the decision's <tt>goal</tt>,
    # that <i>computes</i> the decision through a process called deliberation (see <tt>Leap::GoalMethodsDocumentation</tt>).
    #
    # @example Defining a Leap decision
    #   class Person
    #     include Leap
    #     decide :lucky_number do
    #       # Decision definition elided (see Leap::Decision#committee)
    #     end
    #   end
    #
    #   Person.new.lucky_number # => 42
    #
    # @param [Symbol] goal The goal of the decision--what is it that we're trying to decide about the subject?
    # @param [optional, Hash] options
    # @option [optional, Symbol] with The name of an instance method on the subject that will, when called, provide a Hash of curated attributes about itself. <a href="http://github.com/brighterplanet/charisma">Charisma</a> is great for this. If this option is not provided, Leap will use a low-budget alternative (see <tt>Leap::ImplicitAttributes</tt>) 
    #
    # @see Leap::Decision
    # @see Leap::Decision#committee
    # @see Leap::Deliberation
    # @see Leap::GoalMethodsDocumentation
    # @see Leap::ImplicitAttributes
    def decide(goal, options = {}, &blk)
      decisions[goal] = ::Leap::Decision.new goal, options
      Blockenspiel.invoke(blk, decisions[goal])
      define_method goal do |*considerations|
        @deliberations ||= {}
        decision = self.class.decisions[goal]
        characteristics = send(self.class.decisions[goal].signature_method)
        @deliberations[goal] = decision.make(characteristics, *considerations)
        if @deliberations[goal][goal].nil? 
          raise ::Leap::NoSolutionError, :goal => goal,
            :deliberation => @deliberations[goal]
        end
        @deliberations[goal][goal]
      end
    end
  end
end
