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

    def report(project, customer, task, status, message="")
      message = "[#{task}::#{status}] [##{project} ##{customer}] #{message} (@#{Time.now})"

      if @env.test?
        @test_reports << message
      else
        Twitter.update(message)
      end
    end

    def self.method_missing(method, *args)
      self.instance.send(method, *args)
    end
  end

  def self.configure
    yield Reporter.instance
  end

  def self.method_missing(method, *args)
    Reporter.instance.send(method, *args)
  end
end
