module Leap
  class NoSolutionError < ArgumentError;
    def initialize(options = {})
      if goal = options[:goal]
        help = "No solution was found for \"#{goal}\"."
      else
        help = "No solution was found."
      end
      if deliberation = options[:deliberation]
        help << " Characteristics considered: #{deliberation.characteristics.keys.sort.inspect}."
      end
      super help
    end
  end
end
