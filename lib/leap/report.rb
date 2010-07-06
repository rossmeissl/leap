module Leap
  class Report
    attr_reader :conclusion, :quorum
    
    def initialize(report)
      raise ArgumentError, 'Please report with quorum => conclusion' unless report.is_a?(Hash) and report.length == 1
      @quorum, @conclusion = report.first
    end
  end
end
