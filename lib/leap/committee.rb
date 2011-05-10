module Leap
  # One of the basic building blocks of a Leap decision.
  #
  # Committees represent computable attributes of a subject instance and facilitate multiple means of computing these attributes. In some cases, you will
  # define committees that match the names of attributes that can be explicitly set on a subject; in this case, the committees are only useful when
  # a particular instance does not have this attribute set. In other cases, committees are part of internal logic within the Leap decision, providing
  # intermediate results in pursuit of the decision's ultimate goal.
  #
  # As a Leap decision is made, it approaches each committee in turn, providing it with its current knowledge of the subject. The committee accepts this information, determines an appropriate methodology, and returns additional information about the subject. This newly-augmented knowledge about the subject is then passed to the next committee for further augmentation, and so forth. 
  #
  # Committees are composed of one or more quorums (<tt>Leap::Quorum</tt> objects) that encapsulate specific methodologies for drawing the committee's conclusion. This composition is defined within the <tt>Leap::Decision#committee</tt> block using the <tt>Leap::Committee#quorum</tt> DSL.
  # @see Leap::Quorum
  class Committee

    # The name of the committee, traditionally formulated to represent a computable attribute of the subject.
    attr_reader :name
    
    # The array of quorums defined within the committee.
    attr_reader :quorums
    
    # Creates a new <tt>Leap::Committee</tt> with the given name.
    #
    # Generally you don't create these objects directly; <tt>Leap::Decision#committee</tt> does that for you.
    #
    # @see Leap::Decision#committee
    # @param [Symbol] name The name of the committee, traditionally formulated to represent a computable attribute of the subject.
    def initialize(name)
      @name = name
      @quorums = []
    end
    
    # Instructs the committee to draw its conclusion.
    #
    # Steps through each quorum defined within the committee in search of one that can be called with the provided characteristics and is compliant with the requested protocols. Upon finding such a quorum, it is called. If a conclusion is returned, it becomes the committee's conclusion; if not, the quorum-seeking process continues.
    #
    # Generally you will not call this method directly; <tt>Leap::Decision#make</tt> requests reports at the appropriate time.
    # @param [Leap::Subject] subject The Leap subject about which we're computing this attribute.
    # @param [Hash] characteristics What we know so far about the subject.
    # @param [Array] considerations Auxiliary contextual details about the decision (see <tt>Leap::GoalMethodsDocumentation</tt>)
    # @param [optional, Hash] options
    # @option comply Compliance constraint. See <tt>Leap::GoalMethodsDocumentation</tt>.
    # @see Leap::GoalMethodsDocumentation
    # @return Leap::Report
    def report(subject, characteristics, considerations, options = {})
      quorums.grab do |quorum|
        next unless quorum.satisfied_by? characteristics and quorum.complies_with? Array.wrap(options[:comply])
        if conclusion = quorum.acknowledge(characteristics.slice(*quorum.characteristics), considerations.dup)
          ::Leap::Report.new subject, self, quorum => conclusion
        end
      end
    end
    
    include ::Blockenspiel::DSL
    
    # Defines a quorum within this committee.
    #
    # A quorum encapsulate a specific methodology for drawing the committe's conclusion.
    # @param [String] name A descriptive name for this methodology.
    # @param [optional, Hash] options
    # @yield The quorum's methodology, as a Ruby closure. You may define your block with any number of block vars. If zero, the methodology requires no outside information (useful for "default" quorums). If one, Leap will provide the characteristics hash, accumulated over the course of the deliberation, that represents its total knowledge of the subject at the time. (Note that Leap will actually provide only a subset of the characteristics hash--namely, only attributes that are specifically requested by the <tt>:needs</tt> and <tt>:wants</tt> options below.) If more than one, additional block vars will be filled with as many considerations (given during <tt>Leap::Decision#make</tt>) as is necessary.
    # @option [Symbol, Array] needs An attribute (or array of attributes) which must be known at the time of the committee's assembly for the quorum to be acknowledged.
    # @option [Symbol, Array] wants An attribute (or array of attributes) which are useful to the methodology, but not required.
    # @option complies A protocol (or array of protocols) with which this particular quorum complies. See <tt>Leap::GoalMethodsDocumentation</tt>.
    def quorum(name, options = {}, &blk)
      @quorums << ::Leap::Quorum.new(name, options, blk)
    end
    
    # Convenience method for defining a quorum named "default" with no needs, wants, or compliances.
    def default(options = {}, &blk)
      quorum 'default', options, &blk
    end
  end
end
