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

  describe "when a task throws an error" do
    let(:logger){ double(:error =>  true) }
    before do
      Rails.stub(:logger => logger)
    end

    def do_action
      TaskReporter.task("backup") do
        raise StandardError
      end
    end

    it "should not break" do
      lambda do
        do_action
      end.should_not raise_error
    end

    it "should report the task as an error" do
      do_action
      TaskReporter.test_reports.length.should == 1
      report = TaskReporter.test_reports.first
      report.should include("backup")
      report.should include("error")
    end

    it "should log the error" do
      logger = double
      expect(logger).to receive(:error).exactly(2).times

      Rails.stub(:logger => logger)

      do_action
    end
  end

  describe "when a task does not throw an error but doesn't report" do
    def do_action
      TaskReporter.task("backup"){}
    end

    it "should report the task as successful" do
      do_action

      TaskReporter.test_reports.length.should == 1
      report = TaskReporter.test_reports.first
      report.should include("backup")
      report.should_not include("error")
    end
  end
end

describe TaskReporter::Reporter do
  describe "report" do
    it "should cut off too long messages" do
      TaskReporter.report("a"*150)

      TaskReporter.test_reports.first.should == "a"*140
    end
  end
end
