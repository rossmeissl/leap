require 'helper'

class Leap::ReportTest < Test::Unit::TestCase
  context 'to_xml' do
    should 'serialize to xml' do
      choc = Leap::Quorum.new('with chocolate chips', {}, Proc.new {})
      mac = Leap::Quorum.new('with macadamia nuts', {}, Proc.new {})
      committee = Leap::Committee.new 'Senate Committee on Chocolate Cookies'
      committee.instance_variable_set :@quorums, [choc, mac]

      report = Leap::Report.new committee, choc => 'good'

      output = ''
      report.to_xml(:target => output)
      assert_equal(<<XML, output)
<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<report>
  <committee>
    <name type="string">Senate Committee on Chocolate Cookies</name>
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
  end
end
