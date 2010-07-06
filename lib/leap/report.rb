module Leap
  class Report
    attr_reader :committee, :conclusion, :quorum
    
    def initialize(committee, report)
      raise ArgumentError, 'Reports must identify themselves' unless committee.is_a?(::Leap::Committee)
      @committee = committee
      raise ArgumentError, 'Please report with quorum => conclusion' unless report.is_a?(Hash) and report.length == 1
      @quorum, @conclusion = report.first
    end
  end
end
