require 'decider/subject'

module Decider
  def self.included(base)
    base.extend Subject
  end
end