module Leap
  require 'logger'

  # Begin logging Leap activity
  #
  # @param [optional] logger An object to receive logging signals (currently <tt>#info</tt>). If not provided, Leap will log to <tt>Logger.new($stdout)</tt>. 
  def log!(logger = nil)
    @@logger = Register.new logger
  end
  module_function :log!

  # Returns the logger object if logging is enabled
  def log?
    defined?(@@logger)
  end
  module_function :log?

  # Returns the logging object--or a "black hole" logger if logging is not enabled.
  def log
   log? ? @@logger : @@shredder ||= Shredder.new 
  end
  module_function :log

  # Facilitates the logging of Leap activity
  class Register
    # Creates a <tt>Leap::Register</tt> wrapper around a given (optional) logger. If no logger is provided, Leap assumes <tt>Logger.new($stdout)</tt>.
    def initialize(logger = nil)
      @logger = logger || ::Logger.new($stdout)
    end

    # Log a Leap decision
    #
    # @param [String] message The message to be logged
    # @param [String] name The name of the decision
    def decision(message, name)
      record name, message, 0
    end

    # Log Leap committee action
    #
    # @param [String] message The message to be logged
    # @param [String] name The name of the committee
    def committee(message, name)
      record name, message, 1
    end

    # Log Leap quorum activity
    #
    # @param [String] message The message to be logged
    # @param [String] name The name of the quorum
    def quorum(message, name)
      record name, message, 2
    end

    private
    
    def record(name, message, indents)
      @logger.info 'Leap ' + (' ' * indents * 2) + " [#{name}] #{message}"  
    end
  end

  # A "black hole" logging class that does absolutely nothing with the logging messages it receives.
  class Shredder
    def decision(*) nil end
    def committee(*) nil end
    def quorum(*) nil end
  end
end
