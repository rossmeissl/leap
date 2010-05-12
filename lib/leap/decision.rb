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
    
    include Blockenspiel::DSL
    def committee(name, &blk)
      new_committee = Committee.new(name)
      @committees << new_committee
      Blockenspiel.invoke blk, new_committee
    end
  end
end
