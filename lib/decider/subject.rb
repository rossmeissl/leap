module Decider
  module Subject
    def self.extended(base)
      base.instance_variable_set :@decisions, {}
      class << base
        attr_reader :decisions
      end
    end
    def decide(goal, options = {}, &blk)
      decisions[goal] = ::Decider::Decision.new goal, options
      Blockenspiel.invoke(blk, decisions[goal])
      define_method goal do |considerations|
        self.class.decisions[goal].make send(self.class.decisions[goal].signature_method), considerations
      end
    end
  end
end
