module Leap
  class Report
    include XmlSerializer

    attr_reader :subject, :committee, :conclusion, :quorum
    
    def initialize(subject, committee, report)
      raise ArgumentError, 'Reports must identify themselves' unless committee.is_a?(::Leap::Committee)
      @subject = subject
      @committee = committee
      raise ArgumentError, 'Please report with quorum => conclusion' unless report.is_a?(Hash) and report.length == 1
      @quorum, @conclusion = report.first
    end

    def formatted_conclusion
      return @formatted_conclusion unless @formatted_conclusion.nil?
      if characteristic = subject.class.characteristics[committee.name]
        @formatted_conclusion = characteristic.display committee.name => conclusion
      end
      @formatted_conclusion ||= conclusion
    end

    def as_json(*)
      {
        'committee' => committee.as_json,
        'conclusion' => formatted_conclusion,
        'quorum' => quorum.as_json
      }
    end

    def to_xml(options = {})
      super options do |xml|
        xml.report do |report_block|
          committee.to_xml(options.merge :skip_instruct => true, :builder => report_block)
          report_block.conclusion formatted_conclusion, :type => formatted_conclusion.class.to_s.downcase
          quorum.to_xml(options.merge :skip_instruct => true, :builder => report_block)
        end
      end
    end
  end
end
