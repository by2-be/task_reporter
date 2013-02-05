require "task_reporter/version"
require "twitter"
require "singleton"

require "task_reporter/reporter"
require "task_reporter/task"

module TaskReporter
  class NullLogger
    def method_missing(method, *args)
      puts "warning: called logger without a logger available"
      puts "   Logger #{method}: #{args.join('\n')}"
    end
  end

  def self.configure
    yield Reporter.instance
  end

  def self.method_missing(method, *args, &block)
    Reporter.instance.send(method, *args, &block)
  end

  class TaskReporterError < StandardError; end
  class NoLoggerAvailable < TaskReporterError; end
end
