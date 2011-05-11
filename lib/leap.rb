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
require 'leap/subject'
require 'leap/committee'
require 'leap/quorum'
require 'leap/decision'
require 'leap/report'
require 'leap/deliberation'
require 'leap/implicit_attributes'
require 'leap/no_solution_error'
require 'leap/deliberations_accessor'
require 'leap/goal_methods_documentation'

# Leap is a system for: 1) describing decision-making strategies used to determine a potentially non-obvious attribute of an object and 2)
# computing that attribute by choosing appropriate strategies given a specific set of input information
module Leap
  # Injects <tt>Leap::Subject</tt> into the host class
  # @see Subject
  def self.included(base)
    base.extend ::Leap::Subject
  end
end
