begin
  require "guard/minitest/notifier"
rescue LoadError
  puts "You need guard-minitest to use this reporter."
  exit 1
end

module MiniTest
  module Reporters
    class GuardReporter
      include Reporter

      def notifier_class
        if ::Guard.const_defined? "MinitestNotifier"
          # old guard-minitest API prior to 1.0.0.beta.2
          ::Guard::MinitestNotifier
        elsif ::Guard.const_defined? "Minitest" and ::Guard::Minitest.const_defined? "Notifier"
          # new guard-minitest API, by 02b46ee in between
          # 1.0.0.beta1 and 1.0.0.beta.2
          ::Guard::Minitest::Notifier
        end
      end

      def after_suites(*args)
        duration = Time.now - runner.suites_start_time
        notifier_class.notify(runner.test_count, runner.assertion_count,
                             runner.failures, runner.errors,
                             runner.skips, duration)
      end
    end
  end
end
