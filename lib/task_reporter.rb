require "task_reporter/version"
require "twitter"
require "singleton"

module TaskReporter
  class Reporter
    include Singleton
    attr_reader :test_reports
    attr_accessor :project, :customer

    def initialize(framework=Rails)
      @env = framework.env
      @test_reports = []
    end

    def task(name)
      yield Task.new(name)
    end

    def self.method_missing(method, *args)
      self.instance.send(method, *args)
    end

    def report(task)
      message = task.to_s

      if @env.test?
        @test_reports << message
      else
        Twitter.update(message)
      end
    end
  end

  class Task
    def initialize(name)
      @name = name
      @message = nil
    end

    def to_s
      task = @name
      status = @status
      project = Reporter.name
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
  end

  def self.configure
    yield Reporter.instance
  end

  def self.method_missing(method, *args, &block)
    Reporter.instance.send(method, *args, &block)
  end
end
