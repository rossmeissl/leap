module Decider
  module Subject
    def decide(goal, options = {})
      define_method goal do
        false
      end
    end
  end
end
