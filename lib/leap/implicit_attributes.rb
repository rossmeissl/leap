module Leap
  module ImplicitAttributes
    def _leap_implicit_attributes
      Hash[*instance_variables.map { |variable| variable.delete('@').to_sym }.zip(instance_variables.map { |variable| instance_variable_get variable }).flatten]
    end
  end
end
