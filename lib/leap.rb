require 'active_support'
require 'active_support/version'
if ActiveSupport::VERSION::MAJOR >= 3
  require 'active_support/core_ext'
end

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
require 'leap/register'
require 'leap/whip'

# Leap is a system for: 1) describing decision-making strategies used to determine a potentially non-obvious attribute of an object and 2)
# computing that attribute by choosing appropriate strategies given a specific set of input information
module Leap
  # Injects <tt>Leap::Subject</tt> into the host class
  # @see Subject
  def self.included(base)
    base.extend ::Leap::Subject
  end
end
