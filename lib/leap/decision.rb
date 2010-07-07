module Leap
  class Decision
    attr_reader :goal, :signature_method, :committees, :minutes
    
    def initialize(goal, options)
      @goal = goal
      @signature_method = options[:with] || {}
      @committees = []
    end
    
    def make(characteristics, *considerations)
      committees.reject { |c| characteristics.keys.include? c.name }.reverse.inject(Deliberation.new(characteristics)) do |deliberation, committee|
        if report = committee.report(deliberation.characteristics, considerations)
          deliberation.reports.unshift report
          deliberation.characteristics[committee.name] = report.conclusion
        end
        deliberation
      end
    end
    
    include ::Blockenspiel::DSL
    def committee(name, &blk)
      committee = ::Leap::Committee.new(name)
      @committees << committee
      ::Blockenspiel.invoke blk, committee
    end
  end
end
