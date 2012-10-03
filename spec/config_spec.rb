require "spec_helper"

describe TaskReporter, "configurate" do
  %w(customer project).each do |setting|

    it "should be possible to set and get#{setting}" do
      lambda do
        TaskReporter.configure do |c|
          c.send(setting+"=", "test")
        end
      end.should change(TaskReporter, setting)
    end

  end
end
