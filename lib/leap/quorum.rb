module Leap
  class Quorum
    attr_reader :name, :requirements, :supplements, :process, :compliance
    def initialize(name, options, blk)
      @name = name
      @requirements = Array.wrap options[:needs]
      @supplements = Array.wrap options[:appreciates]
      @compliance = Array.wrap options[:complies]
      @process = blk
    end
    
    def satisfied_by?(characteristics)
      (requirements - characteristics.keys).empty?
    end
    
    def complies_with?(guidelines)
      (guidelines - compliance).empty?
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
