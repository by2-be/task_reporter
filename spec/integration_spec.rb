require "spec_helper"

describe TaskReporter, "integration test" do
  before do
    TaskReporter.configure do |c|
      c.project = "Project"
      c.customer = "Customer"
    end
  end

  def do_action
    TaskReporter.task("task_name") do |task|
      task.success
    end
  end

  it "should create a new and correct report" do
    -> { do_action }.should change(TaskReporter.test_reports, :length).by(1)

    report = TaskReporter.test_reports.first
    report.should include "[task_name::success] [#Project #Customer]"
  end
end
