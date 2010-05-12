module Decider
  class Committee
    attr_reader :name, :quorums
    
    def initialize(name)
      @name = name
      @quorums = []
    end
    
    def report(characteristics, considerations)
      quorums.detect do |quorum|
        next unless quorum.satisfied_by? characteristics
        if conclusion = quorum.acknowledge(characteristics, considerations)
          break conclusion
        end
      end
    end
    
    include ::Blockenspiel::DSL
    def quorum(name, options = {}, &blk)
      @quorums << ::Decider::Quorum.new(name, options, blk)
    end
    
    def default(&blk)
      quorum 'default', {}, &blk
    end
  end
end
