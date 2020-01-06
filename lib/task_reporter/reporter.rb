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
        logger.error error.backtrace.join("\n")
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
      elsif @env.development?
        Rails.logger.info "[TaskReporter]: #{message}"
        puts "[TaskReporter]: #{message}"
      else
        TaskReporter::Twitter.update(message)
      end
    end
  end
end
