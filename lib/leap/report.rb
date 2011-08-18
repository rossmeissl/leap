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
    # @param [Leap::Quorum] The responsible quorum.
    # @param [any] The conclusion.
    # @param [Hash] report A single-pair hash containing the responsible quorum and its conclusion.
    # @raise [ArgumentError] Raised for anonymous reports.
    def initialize(committee, quorum, conclusion)
      raise ArgumentError, 'Reports must identify themselves' unless committee.is_a?(::Leap::Committee)
      @committee = committee
      @quorum = quorum
      @conclusion = conclusion
    end
  end
end
