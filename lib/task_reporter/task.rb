module TaskReporter
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
end
