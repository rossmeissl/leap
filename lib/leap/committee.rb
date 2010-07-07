module Leap
  class Committee
    attr_reader :name, :quorums
    
    def initialize(name)
      @name = name
      @quorums = []
    end
    
    def report(characteristics, considerations)
      quorums.grab do |quorum|
        next unless quorum.satisfied_by? characteristics
        if conclusion = quorum.acknowledge(characteristics.slice(*quorum.characteristics), considerations.dup)
          ::Leap::Report.new self, quorum => conclusion
        end
      end
    end
    
    include ::Blockenspiel::DSL
    def quorum(name, options = {}, &blk)
      @quorums << ::Leap::Quorum.new(name, options, blk)
    end
    
    def default(&blk)
      quorum 'default', {}, &blk
    end
  end
end
