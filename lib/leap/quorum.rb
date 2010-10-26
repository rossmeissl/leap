module Leap
  class Quorum
    include XmlSerializer

    attr_reader :name, :requirements, :supplements, :process, :compliance
    def initialize(name, options, blk)
      @name = name
      @requirements = Array.wrap options[:needs]
      @supplements = Array.wrap options[:appreciates]
      @compliance = Array.wrap options[:complies]
      @process = blk
    end
    
    def satisfied_by?(characteristics)
      (requirements - characteristics.keys).empty?
    end
    
    def complies_with?(guidelines)
      (guidelines - compliance).empty?
    end
    
    def acknowledge(characteristics, considerations)
      considerations.unshift characteristics
      process.call(*considerations[0...process.arity])
    end
    
    def characteristics
      requirements + supplements
    end

    def as_json(*)
      { 
        'name' => name.to_s,
        'requirements' => requirements.map(&:to_s),
        'appreciates' => supplements.map(&:to_s),
        'complies' => compliance.map(&:to_s)
      }
    end

    def to_xml(options = {})
      super options do |xml|
        xml.quorum do |quorum_block|
          quorum_block.name name.to_s, :type => 'string'
          array_to_xml(quorum_block, :requirements, requirements)
          array_to_xml(quorum_block, :appreciates, supplements, 'supplement')
          array_to_xml(quorum_block, :complies, compliance, 'compliance')
        end
      end
    end
  end
end
