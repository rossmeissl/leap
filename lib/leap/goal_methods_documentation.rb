module Leap
  # Used strictly for documenting the dynamic methods created by <tt>Leap::Subject#decide</tt>
  #
  # @note This module is provided due to limitations in the YARD documentation system.
  # @see Leap::Subject#decide
  module GoalMethodsDocumentation
    
    # @overload your_goal_name(*considerations = [], options = {})
    #   Computes a previously-defined Leap decision named <tt>your_goal_name</tt>.
    #   
    #   @param [optional, Array] considerations An ordered array of additional details, immutable during the course of deliberation, that should be made available to each committee for provision, upon request, to quorums.
    #   @param [optional, Hash] options Additional options
    #   @option comply Force the ensuing deliberation to comply with one or more "protocols" by only respecting quorums that comply with this (these) protocol(s). Protocols can be anything--a Fixnum, a String, whatever, but by tradition a Symbol. If compliance is required with multiple protocols, they should be passed in an Array. If complex compliance is desired, where certain conclusions must comply with specific protocols, use a Hash in the form of <tt>{ :first_protocol => [:a_committee, :another_committee], :second_protocol => :another_committee }</tt>.
    #   @return The value of the newly-decided goal--or, if there is no committee with the same name as the goal, a hash of committee reports
    #   @raise [Leap::NoSolutionError] Leap could not compute the decision's goal on this subject instance given its characteristics and compliance constraint. 
    def method_missing(*args, &blk)
      super
    end
  end
end
