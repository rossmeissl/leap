require 'helper'

class Vagabond
  include Characterizable

  characterize do
    has :scruples
    has :tenacity do
      displays { |t| "ferocious" }
    end
  end
end

class Leap::ReportTest < Test::Unit::TestCase
  context 'formatted_conclusion' do
    should 'return the regular conclusion if there is no custom format for the conclusion corresponding characteristic' do
      choc = Leap::Quorum.new('with chocolate chips', {}, Proc.new {})
      committee = Leap::Committee.new :scruples
      committee.instance_variable_set :@quorums, [choc]

      report = Leap::Report.new Vagabond.new, committee, choc => 'good'
      assert_equal 'good', report.formatted_conclusion
    end
    should 'return the formatted conclusion if there is a custom format for the conclusion corresponding characteristic' do
      choc = Leap::Quorum.new('with chocolate chips', {}, Proc.new {})
      committee = Leap::Committee.new :tenacity
      committee.instance_variable_set :@quorums, [choc]

      report = Leap::Report.new Vagabond.new, committee, choc => 'good'
      assert_equal 'ferocious', report.formatted_conclusion
    end
  end
end
