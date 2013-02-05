require "task_reporter/version"
require "twitter"
require "singleton"

module TaskReporter
  class Reporter
    include Singleton
    attr_reader :test_reports
    attr_accessor :project, :customer

    def initialize(framework=Rails)
      @framework = framework
      @env = @framework.env
      @test_reports = []
    end

    def task(name)
      task = Task.new(name)
      begin
        yield task
      rescue Exception => error
        task.error error

        logger.error error
        logger.error error.backtrace
      else
        task.success unless task.reported?
      end
    end

    def self.method_missing(method, *args)
      self.instance.send(method, *args)
    end

    def logger
      @framework.respond_to?(:logger) ? @framework.logger : NullLogger.new
    end

    def report(task)
      message = task.to_s[0..139]

      if @env.test?
        @test_reports << message
      else
        Twitter.update(message)
      end
    end
  end

  class Task
    attr_reader :name

    def initialize(name)
      @name = name
      @message = nil
      @status = nil
    end

    def to_s
      task = @name
      status = @status
      project = Reporter.project
      customer = Reporter.customer
      message = @message
      "[#{task}::#{status}] [##{project} ##{customer}] #{message} (@#{Time.now})"
    end

    def success(message=nil)
      @status = :success
      @message = message
      Reporter.instance.report(self)
    end

    def error(message=nil)
      @status = :error
      @message = message
      Reporter.instance.report(self)
    end

    def reported?
      !@status.nil?
    end
  end

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
