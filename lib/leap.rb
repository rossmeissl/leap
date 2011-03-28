require 'active_support/version'
%w{
  active_support/core_ext/hash/slice
  active_support/core_ext/array/wrap
  active_support/core_ext/array/extract_options
}.each do |active_support_3_requirement|
  require active_support_3_requirement
end if ActiveSupport::VERSION::MAJOR == 3
require 'blockenspiel'

require 'leap/core_ext'
require 'leap/xml_serializer'
require 'leap/subject'
require 'leap/committee'
require 'leap/quorum'
require 'leap/decision'
require 'leap/report'
require 'leap/deliberation'
require 'leap/implicit_attributes'
require 'leap/no_solution_error'
require 'leap/deliberations_accessor'

module Leap
  def self.included(base)
    base.extend ::Leap::Subject
  end
end
