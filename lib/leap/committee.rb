module Leap
  class Committee
    attr_reader :name, :quorums, :expectation
    
    def initialize(name)
      case name
      when Hash
        @name, @expectation = *name.first
      else
        @name = name
      end
      @quorums = []
    end
    
    def report(characteristics, considerations, options = {})
      quorums.grab do |quorum|
        next unless quorum.satisfied_by? characteristics and quorum.complies_with? Array.wrap(options[:comply])
        if conclusion = quorum.acknowledge(characteristics.slice(*quorum.characteristics), considerations.dup)
          raise ::Leap::UnexpectedConclusionError unless expects? conclusion
          ::Leap::Report.new self, quorum => conclusion
        end
      end
    end
    
    include ::Blockenspiel::DSL
    def quorum(name, options = {}, &blk)
      @quorums << ::Leap::Quorum.new(name, options, blk)
    end
    
    def default(options = {}, &blk)
      quorum 'default', options, &blk
    end
    
    private
    def expects?(conclusion)
      return true unless @expectation
      case expectation
      when Symbol
        conclusion.respond_to?(expectation) && conclusion.send(expectation)
      else
        expectation === conclusion
      end
    end
  end
end
