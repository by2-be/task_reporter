require "spec_helper"

describe TaskReporter::Task do
  it "should be possible to read the name" do
    TaskReporter::Task.new("name").name.should == "name"
  end
end
