module Leap
  module Subject
    def self.extended(base)
      base.instance_variable_set :@decisions, {}
    end
    attr_reader :decisions
    def decide(goal, options = {}, &blk)
      decisions[goal] = Decision.new goal, options
      Blockenspiel.invoke blk, decisions[goal]
      module_eval %{
        def #{goal}(*args)
          considerations = args.first
          self.class.decisions[#{goal.inspect}].make send(self.class.decisions[#{goal.inspect}].signature_method), considerations
        end
      }, __FILE__, __LINE__
    end
  end
end
