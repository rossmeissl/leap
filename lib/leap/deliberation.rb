module Leap
  # Encapsulates a single computation of a Leap subject's decision, as performed on an instance of that subject class.
  class Deliberation
    # Accumulates knowledge about the Leap subject instance, beginning with the instance's explicit attributes, and later augmented by committee proceedings.
    attr_accessor :characteristics
    
    # Accumulates proceedings of the deliberation, including conclusions and methodology.
    attr_accessor :reports
    
    # Create a new deliberation, to be made in light of the provided characteristics of the Leap subject instance.
    # @param [Hash] characteristics The initial set of characteristics made available to committees during deliberation. 
    def initialize(characteristics)
      self.characteristics = characteristics
      self.reports = []
    end
    
    # Convenience method to access values within the deliberation's characteristics hash.
    # @param [Symbol] characteristic
    def [](characteristic)
      characteristics[characteristic]
    end
    
    # Report which named protocols the deliberation incidentally complied with.
    # @return [Array]
    def compliance
      reports.map(&:quorum).map(&:compliance).inject do |memo, c|
        next c unless memo
        memo & c
      end
    end
  end
end
