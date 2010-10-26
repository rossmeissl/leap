require 'helper'

class Leap::QuorumTest < Test::Unit::TestCase
  context 'to_xml' do
    should 'serialize to xml' do
      quorum = Leap::Quorum.new(
        'roll call', 
        { :needs => :count, :complies => :rules_of_endearment, :appreciates => [:adulation, :confirmation] },
        Proc.new {})

      output = ''
      quorum.to_xml(:target => output)
      assert_equal(<<XML, output)
<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<quorum>
  <name type="string">roll call</name>
  <requirements type="array">
    <requirement type="string">count</requirement>
  </requirements>
  <appreciates type="array">
    <supplement type="string">adulation</supplement>
    <supplement type="string">confirmation</supplement>
  </appreciates>
  <complies type="array">
    <compliance type="string">rules_of_endearment</compliance>
  </complies>
</quorum>
XML
    end
  end
end
