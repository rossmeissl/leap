require 'active_support/version'
%w{
  active_support/core_ext/hash/slice
  active_support/core_ext/array/wrap
}.each do |active_support_3_requirement|
  require active_support_3_requirement
end if ActiveSupport::VERSION::MAJOR == 3
require 'blockenspiel'

require 'leap/subject'
require 'leap/committee'
require 'leap/quorum'
require 'leap/decision'

module Leap
  def self.included(base)
    base.extend ::Leap::Subject
  end
end