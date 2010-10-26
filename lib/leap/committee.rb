module Leap
  class Committee
    include XmlSerializer

    attr_reader :name, :quorums
    
    def initialize(name)
      @name = name
      @quorums = []
    end
    
    def report(characteristics, considerations, options = {})
      quorums.grab do |quorum|
        next unless quorum.satisfied_by? characteristics and quorum.complies_with? Array.wrap(options[:comply])
        if conclusion = quorum.acknowledge(characteristics.slice(*quorum.characteristics), considerations.dup)
          ::Leap::Report.new self, quorum => conclusion
        end
      end
    end

    def as_json(*)
      {
        'name' => name.to_s,
        'quorums' => quorums.map(&:as_json)
      }
    end

    def to_xml(options = {})
      super options do |xml|
        xml.committee do |committee_block|
          committee_block.name name.to_s, :type => 'string'
          array_to_xml(committee_block, :quorums, quorums)
        end
      end
    end
    
    include ::Blockenspiel::DSL
    def quorum(name, options = {}, &blk)
      @quorums << ::Leap::Quorum.new(name, options, blk)
    end
    
    def default(options = {}, &blk)
      quorum 'default', options, &blk
    end
  end
end
