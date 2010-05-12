require 'active_support/version'
%w{
  active_support/core_ext/hash/slice
  active_support/core_ext/array/wrap
}.each do |active_support_3_requirement|
  require active_support_3_requirement
end if ActiveSupport::VERSION::MAJOR == 3
require 'blockenspiel'

require 'decider/subject'
require 'decider/committee'
require 'decider/quorum'
require 'decider/decision'

module Decider
  def self.included(base)
    base.extend ::Decider::Subject
  end
end