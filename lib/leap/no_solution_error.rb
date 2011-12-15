require 'active_support/inflector'

module Leap
  # Raised when a Leap solution cannot be found. 
  #
  # If this is raised unexpectedly, try removing compliance constraints or double-checking that you have enough quorums within mainline committees to provide conclusions given any combination of input data.
  class NoSolutionError < ArgumentError;
    # Create the excpetion
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
    
    # A report on the deliberation proceedings, for debugging purposes.
    def deliberation_report
      @deliberation.characteristics.keys.sort_by(&:to_s).map do |characteristic|
        statement = "#{characteristic}: "
        if report = @deliberation.report(characteristic)
          statement << report.quorum.name.humanize.downcase
        else
          statement << 'provided as input'
        end
      end.join ', '
    end
  end
end
