module Leap
  class Minutes
    attr_reader :reports
    
    def initialize(reports = {})
      @reports = reports
    end
    
    def [](report)
      reports[report.to_sym]
    end
  end
end
