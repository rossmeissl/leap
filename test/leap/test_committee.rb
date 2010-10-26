require 'helper'

class Leap::CommitteeTest < Test::Unit::TestCase
  context 'to_xml' do
    should 'serialize to xml' do
      committee = Leap::Committee.new 'Senate Committee on Chocolate Cookies'
      committee.instance_variable_set :@quorums, [
        Leap::Quorum.new('with chocolate chips', {}, Proc.new {}),
        Leap::Quorum.new('with macadamia nuts', {}, Proc.new {})
      ]

      output = ''
      committee.to_xml(:target => output)
      assert_equal(<<XML, output)
<?xml version=\"1.0\" encoding=\"UTF-8\"?>
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
XML
    end
  end
end
