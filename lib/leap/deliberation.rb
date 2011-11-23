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

    # Convenience method to access a certain committee's report within this deliberation.
    # @param [Symbol] committee
    def report(committee)
      reports.find { |r| r.committee.name == committee }
    end
    
    # Report which named protocols the deliberation incidentally complied with.
    # @param [Symbol, optional] committee If provided, Leap will compute this decision's compliance with respect only to this particular conclusion within it. If not provided, compliance will be computed for the entire decision.
    # @return [Array]
    def compliance(committee = nil)
      committee ? compliance_from(committee) : general_compliance
    end

    private

    def general_compliance
      reports.map(&:quorum).map(&:compliance).inject do |memo, c|
        next c unless memo
        memo & c
      end
    end

    def compliance_from(committee)
      if report = report(committee)
        compliance = report.quorum.requirements.inject(nil) do |memo, requirement|
          if subcompliance = compliance_from(requirement)
            memo ? memo & subcompliance : subcompliance
          else
            memo
          end
        end
        report.quorum.compliance & (compliance || report.quorum.compliance)
      end
    end
  end
end
