module Leap
  # Ideally Leap subjects will provide methods that return a curated hash of attributes suitable for Leap decisions and indicate them with the <tt>:with</tt> option on <tt>Leap::Subject#decide</tt>.
  # If this type of method is not available, or if it is not properly indicated, Leap will fall back to using the stopgap in this module.
  module ImplicitAttributes
    # Provides an articifial attributes hash constructed from the object's instance variables.
    # @return [Hash]
    def _leap_implicit_attributes
      Hash[*instance_variables.map { |variable| variable.to_s.delete('@').to_sym }.zip(instance_variables.map { |variable| instance_variable_get variable }).flatten].except(:deliberations)
    end
  end
end
