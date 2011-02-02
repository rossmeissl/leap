module Leap
  class NoSolutionError < ArgumentError;
    def initialize(goal)
      super "No solution was found for \"#{goal}\""
    end
  end
end
