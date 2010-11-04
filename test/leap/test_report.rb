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
  context 'to_xml' do
    should 'serialize to xml' do
      choc = Leap::Quorum.new('with chocolate chips', {}, Proc.new {})
      mac = Leap::Quorum.new('with macadamia nuts', {}, Proc.new {})
      committee = Leap::Committee.new :scruples
      committee.instance_variable_set :@quorums, [choc, mac]

      report = Leap::Report.new Vagabond.new, committee, choc => 'good'

      output = ''
      report.to_xml(:target => output)
      assert_equal(<<-XML, output)
<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<report>
  <committee>
    <name type="string">scruples</name>
    <quorums type="array">
      <quorum>
        <name type="string">with chocolate chips</name>
        <requirements type="array">
        </requirements>
        <appreciates type="array">
        </appreciates>
        <complies type="array">
        </complies>
      </quorum>
      <quorum>
        <name type="string">with macadamia nuts</name>
        <requirements type="array">
        </requirements>
        <appreciates type="array">
        </appreciates>
        <complies type="array">
        </complies>
      </quorum>
    </quorums>
  </committee>
  <conclusion type="string">good</conclusion>
  <quorum>
    <name type="string">with chocolate chips</name>
    <requirements type="array">
    </requirements>
    <appreciates type="array">
    </appreciates>
    <complies type="array">
    </complies>
  </quorum>
</report>
      XML
    end
    should 'use a custom conclusion' do
      choc = Leap::Quorum.new('with chocolate chips', {}, Proc.new {})
      mac = Leap::Quorum.new('with macadamia nuts', {}, Proc.new {})
      committee = Leap::Committee.new :tenacity
      committee.instance_variable_set :@quorums, [choc, mac]

      report = Leap::Report.new Vagabond.new, committee, choc => 'tough'

      output = ''
      report.to_xml :target => output
      assert_equal(<<-XML, output)
<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<report>
  <committee>
    <name type="string">tenacity</name>
    <quorums type="array">
      <quorum>
        <name type="string">with chocolate chips</name>
        <requirements type="array">
        </requirements>
        <appreciates type="array">
        </appreciates>
        <complies type="array">
        </complies>
      </quorum>
      <quorum>
        <name type="string">with macadamia nuts</name>
        <requirements type="array">
        </requirements>
        <appreciates type="array">
        </appreciates>
        <complies type="array">
        </complies>
      </quorum>
    </quorums>
  </committee>
  <conclusion type="string">ferocious</conclusion>
  <quorum>
    <name type="string">with chocolate chips</name>
    <requirements type="array">
    </requirements>
    <appreciates type="array">
    </appreciates>
    <complies type="array">
    </complies>
  </quorum>
</report>
      XML
    end
  end

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
