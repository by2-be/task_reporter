# Singletons moeten tussen testen gereset worden
require 'singleton'

class <<Singleton
  def included_with_reset(klass)
    included_without_reset(klass)
    class <<klass
      def reset_instance
        Singleton.send :__init__, self
        self
      end
    end
  end
  alias_method :included_without_reset, :included
  alias_method :included, :included_with_reset
end

# Nu zijn we klaar om de rest te requiren
require File.join(  File.expand_path(File.dirname( __FILE__ )), "..", "lib", "task_reporter" )

RSpec.configure do |c|
  c.before(:each) do
    # na elke test de singleton resetten
    TaskReporter::Reporter.reset_instance
  end
end

# Rails faken
# Dit maakt de applicatie niet per se afhankelijk van rails
# zie code
module Rails
  class Env
    def test?
      true
    end

    def to_s
      "test"
    end
  end

  def self.env
    @env ||= Env.new
  end
end
