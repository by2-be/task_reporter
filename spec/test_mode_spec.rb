require "spec_helper"

describe TaskReporter, "test environment" do
  def do_action
    TaskReporter.report(nil)
  end

  it "should not send to twitter" do
    Twitter.should_not_receive(:update)

    do_action
  end

  it "should place the message in test_reports" do
    TaskReporter.test_reports.length.should be_zero

    do_action

    TaskReporter.test_reports.length.should == 1
  end
end

describe TaskReporter, "production environment" do
  before do
    Rails.stub(:env){double(:test? => false)}
  end

  def do_action
    TaskReporter.report(nil)
  end

  it "should sent to twitter" do
    Twitter.should_receive(:update)

    do_action
  end
end
