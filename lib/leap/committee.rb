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
        quorum.acknowledge characteristics, considerations
      end
    end
    
    include Blockenspiel::DSL
    def quorum(name, options = {}, &blk)
      @quorums << Quorum.new(name, options, blk)
    end
    
    def default(&blk)
      quorum 'default', {}, &blk
    end
  end
end
