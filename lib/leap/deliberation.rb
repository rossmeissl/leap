module Leap
  class Deliberation
    attr_accessor :characteristics
    attr_accessor :reports
    
    def initialize(characteristics)
      self.characteristics = characteristics
      self.reports = []
    end
    
    def [](characteristic)
      characteristics[characteristic]
    end
    
    def compliance
      reports.map(&:quorum).map(&:compliance).inject do |memo, c|
        next c unless memo
        memo & c
      end
    end
  end
end
