module Leap
  class Whip
    def self.enforce(*names, &technique)
      technique = names.pop unless block_given?
      regulations.merge! names.inject({}) { |memo, t| memo[t] = technique; memo }
    end
    
    def self.regulations
      @@regulations ||= {}
    end
  end
end
