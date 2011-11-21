module Leap
  require 'logger'
  
  def log!(logger = nil)
    @@logger = Register.new logger
  end
  module_function :log!

  def log?
    @@logger
  end
  module_function :log?

  def log
    @@logger || @@shredder = Shredder.new 
  end
  module_function :log

  class Register
    def initialize(logger = nil)
      @logger = logger || ::Logger.new($stdout)
    end

    def record(name, message, indents)
      @logger.info 'Leap ' + (' ' * indents * 2) + " [#{name}] #{message}"  
    end

    def decision(message, name)
      record name, message, 0
    end

    def committee(message, name)
      record name, message, 1
    end

    def quorum(message, name)
      record name, message, 2
    end
  end

  class Shredder
    def decision(*) nil end
    def committee(*) nil end
    def quorum(*) nil end
  end
end
