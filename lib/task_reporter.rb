require "task_reporter/version"

module TaskReporter
  def self.report(project, customer, task, status, message="")
    Twitter.update("[#{task}::#{status}] [##{project} ##{customer}] #{message} (@#{Time.now})")
  end
end
