module Leap
  class Deliberation
    attr_accessor :characteristics
    attr_accessor :reports
    
    def initialize(characteristics)
      self.characteristics = characteristics
      self.reports = {}
    end
    
    def [](characteristic)
      characteristics[characteristic]
    end
  end
end
