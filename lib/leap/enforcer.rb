module Leap
  class Enforcer
    cattr_accessor :techniques
    def self.enforce(*types, &technique)
      technique = types.pop unless block_given?
      @@techniques ||= {}
      @@techniques.merge! types.inject({}) { |memo, t| memo[t] = technique; memo }
    end
  end
end
