module Leap
  module Subject
    def self.extended(base)
      base.instance_variable_set :@decisions, {}
      base.send :attr_reader, :deliberations
    end
    attr_reader :decisions
    def decide(goal, options = {}, &blk)
      decisions[goal] = ::Leap::Decision.new goal, options
      Blockenspiel.invoke(blk, decisions[goal])
      define_method goal do |*considerations|
        @deliberations ||= {}
        @deliberations[goal] = self.class.decisions[goal].make send(self.class.decisions[goal].signature_method), *considerations
        @deliberations[goal][goal]
      end
    end
  end
end
