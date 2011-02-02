module Leap
  class NoSolutionError < ArgumentError;
    def initialize(options = {})
      @goal = options[:goal]
      @deliberation = options[:deliberation]
      
      if @goal
        help = "No solution was found for \"#{@goal}\"."
      else
        help = "No solution was found."
      end
      
      if @deliberation
        help << " (#{deliberation_report})"
      end
      
      super help
    end
    
    private
    
    def deliberation_report
      @deliberation.characteristics.keys.sort_by(&:to_s).map do |characteristic|
        statement = "#{characteristic}: "
        if report = @deliberation.reports.find { |r| r.committee.name == characteristic }
          statement << report.quorum.name.humanize.downcase
        else
          statement << 'provided as input'
        end
      end.join ', '
    end
  end
end
