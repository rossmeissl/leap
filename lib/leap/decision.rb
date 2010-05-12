module Leap
  class Decision
    attr_reader :goal, :signature_method, :committees
    
    def initialize(goal, options)
      @goal = goal
      @signature_method = options[:with] || {}
      @committees = []
    end
    
    def make(characteristics, *considerations)
      committees.reverse.inject(characteristics) do |characteristics, committee|
        if report = committee.report(characteristics, considerations)
          characteristics[committee.name] = report
        end
        characteristics
      end[goal]
    end
    
    include ::Blockenspiel::DSL
    def committee(name, &blk)
      committee = ::Leap::Committee.new(name)
      @committees << committee
      ::Blockenspiel.invoke blk, committee
    end
  end
end
