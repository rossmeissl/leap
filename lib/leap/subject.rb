module Leap
  module Subject
    def self.extended(base)
      base.instance_variable_set :@decisions, {}
      base.send :attr_reader, :deliberations
      base.send :include, ::Leap::ImplicitAttributes
    end
    attr_reader :decisions
    def decide(goal, options = {}, &blk)
      decisions[goal] = ::Leap::Decision.new goal, options
      Blockenspiel.invoke(blk, decisions[goal])
      define_method goal do |*considerations|
        options = considerations.extract_options!
        @deliberations ||= {}
        @deliberations[goal] = self.class.decisions[goal].make(self, *considerations.push(options))
        @deliberations[goal][goal] or raise ::Leap::NoSolutionError, goal
      end
    end
  end
end
