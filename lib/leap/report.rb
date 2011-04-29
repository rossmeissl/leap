module Leap
  # Encapsulates a committee's report; that is, the conclusion of its selected quorum, along with administrative details.
  class Report
    include XmlSerializer

    # The Leap subject for which the report was produced.
    attr_reader :subject
    
    # The committee that produced the report
    attr_reader :committee
    
    # The committee's conclusion
    attr_reader :conclusion
    
    # The quorum whose methodology provided the conclusion.
    attr_reader :quorum
    
    # Create a new report.
    #
    # This is generally called in the midst of <tt>Leap::Committee#report</tt>
    # @param subject The Leap subject for which this report was produced.
    # @param [Leap::Committee] The committee that produced the report.
    # @param [Hash] report A single-pair hash containing the responsible quorum and its conclusion.
    # @raise [ArgumentError] Raised for anonymous reports, or if the report is not made properly.
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
