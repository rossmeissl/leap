module Leap
  # Encapsulates a committee's report; that is, the conclusion of its selected quorum, along with administrative details.
  class Report
    
    # The committee that produced the report
    attr_reader :committee
    
    # The committee's conclusion
    attr_reader :conclusion
    
    # The quorum whose methodology provided the conclusion.
    attr_reader :quorum
    
    # Create a new report.
    #
    # This is generally called in the midst of <tt>Leap::Committee#report</tt>
    # @param [Leap::Committee] The committee that produced the report.
    # @param [Hash] report A single-pair hash containing the responsible quorum and its conclusion.
    # @raise [ArgumentError] Raised for anonymous reports, or if the report is not made properly.
    def initialize(committee, report)
      raise ArgumentError, 'Reports must identify themselves' unless committee.is_a?(::Leap::Committee)
      @committee = committee
      raise ArgumentError, 'Please report with quorum => conclusion' unless report.is_a?(Hash) and report.length == 1
      @quorum, @conclusion = report.first
    end
  end
end
