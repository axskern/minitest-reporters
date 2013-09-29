module MiniTest
  module Reporters
    class BaseReporter < Minitest::StatisticsReporter
      attr_accessor :total_count
      attr_accessor :tests

      def initialize(options={})
        super($stdout, options)
        self.tests = []
      end

      def add_defaults(defaults)
        self.options = defaults.merge(options)
      end

      # called by our own before hooks
      def before_test(test)
        last_test = tests.last
        if last_test.class != test.class
          after_suite(test.class) if last_test
          before_suite(test.class)
        end
      end

      def record(test)
        super
        tests << test
      end

      # called by our own after hooks
      def after_test(test)
      end

      def report
        super
        after_suite(tests.last.class)
      end

      protected

      def after_suite(test)
      end

      def before_suite(test)
      end

      def result(test)
        if test.error?
          :error
        elsif test.failure
          :fail
        elsif test.skipped?
          :skip
        else
          :pass
        end
      end

      def total_time
        super || Time.now - start_time
      end

      def total_count
        options[:total_count]
      end

      def filter_backtrace(backtrace)
        Minitest.filter_backtrace(backtrace)
      end

      def puts(*args)
        io.puts(*args)
      end

      def print(*args)
        io.print(*args)
      end

      def print_info(e, name=true)
        print "#{e.exception.class.to_s}: " if name
        e.message.each_line { |line| print_with_info_padding(line) }

        trace = filter_backtrace(e.backtrace)
        trace.each { |line| print_with_info_padding(line) }
      end
    end
  end
end
