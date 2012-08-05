require "spec_helper"

describe TaskReporter, "task interface" do
  it "should allow successfull tasks" do
    TaskReporter.task("backup") do |task|
      task.success
    end

    TaskReporter.test_reports.length.should == 1
    report = TaskReporter.test_reports.first
    report.should include("backup")
    report.should include("success")
  end

  it "should allow erronous tasks" do
    TaskReporter.task("backup") do |task|
      task.error
    end

    TaskReporter.test_reports.length.should == 1
    report = TaskReporter.test_reports.first
    report.should include("backup")
    report.should include("error")
  end
end
