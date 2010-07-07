module Leap
  class Quorum
    attr_reader :name, :requirements, :supplements, :process
    def initialize(name, options, blk)
      @name = name
      @requirements = Array.wrap options[:needs]
      @supplements = Array.wrap options[:appreciates]
      @process = blk
    end
    
    def satisfied_by?(characteristics)
      (requirements - characteristics.keys).empty?
    end
    
    def acknowledge(characteristics, considerations)
      considerations.unshift characteristics
      process.call(*considerations[0...process.arity])
    end
    
    def characteristics
      requirements + supplements
    end
  end
end
