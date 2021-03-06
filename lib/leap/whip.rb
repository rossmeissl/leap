module Leap
  require 'benchmark'
  
  # Begin instrumenting Leap activity. Automatically enables logging.
  def instrument!
    Leap.log! unless Leap.log?
    @@whip = Whip.new
  end
  module_function :instrument!

  # Returns the instrumentation object if enabled
  def instrument?
    defined?(@@whip)
  end
  module_function :instrument?

  # Returns the instrumentation object--or a "pass-through" substitute if not enabled
  def instrument(&blk)
    instrument? ? @@whip : @@bystander ||= Bystander.new
  end
  module_function :instrument

  # Facilitates the instrumentation of Leap activity
  class Whip
    # Instrument a Leap decision
    #
    # @param [String, Symbol] name The decision's name
    # @param [Proc] blk A proc wrapping the decision to instrument
    def decision(name, &blk)
      Leap.log.decision instrument(&blk), name
    end

    # Instrument Leap committee activity
    #
    # @param [String, Symbol] name The committee's name
    # @param [Proc] blk A proc wrapping the committee convention to instrument
    def committee(name, &blk)
      Leap.log.committee instrument(&blk), name
    end

    # Instrument Leap quorum activity
    #
    # @param [String, Symbol] name The quorum's name
    # @param [Proc] blk A proc wrapping the quorum activity to instrument
    def quorum(name, &blk)
      message, result = instrument(true, &blk) 
      Leap.log.quorum message, name
      result
    end

    private
    
    # Give Procs the capacity to remember their result.
    module Registered
      # Result storage
      attr_reader :result

      # Override Proc#call here to ensure storage
      def call
        @result = super
      end
    end
    
    def instrument(return_result_of_measured_block = false, &blk)
      blk = blk.dup.extend Registered
      message = 'Completed in ' + Benchmark.measure { blk.call }.format('%10.6r').gsub(/[()]/,'').strip + 's'
      return_result_of_measured_block ? [message, blk.result] : message
    end
  end

  # Allows Leap activity to continue uninstrumented
  class Bystander
    def decision(_, &blk) yield end
    def committee(_, &blk) yield end
    def quorum(_, &blk) yield end
  end
end
