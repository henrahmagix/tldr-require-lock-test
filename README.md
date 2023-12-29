# tldr-require-lock-test

This is the smallest reproduction of a case where TLDR tests hangup forever when faced with loading the same constant in concurrent tests.

To replicate, run the tests until you see "too long; didn't run!"
```sh
bin/test
```

To help debug, you can edit the TLDR source files to print the stack trace of each test thread at the point that the test runner exits. Here's a patch you can apply:
```diff
# lib/tldr/value/wip_test.rb
@@ -1,3 +1,3 @@
 class TLDR
-  WIPTest = Struct.new(:test, :start_time)
+  WIPTest = Struct.new(:test, :start_time, :thread)
 end

# lib/tldr/runner.rb
@@ -20,6 +20,7 @@
           next if ENV["CI"] && !$stderr.tty?
           next if @run_aborted.true?
           @run_aborted.make_true
+          @wip.each { |wip_test| puts "-----\nWIP TRACE\n  #{wip_test.thread.backtrace_locations&.join("\n  ")}" }
           reporter.after_tldr(plan.tests, @wip.dup, @results.dup)
           exit!(3)
         end
@@ -51,7 +52,7 @@
     def run_test test, config, plan, reporter
       e = nil
       start_time = Process.clock_gettime(Process::CLOCK_MONOTONIC, :microsecond)
-      wip_test = WIPTest.new(test, start_time)
+      wip_test = WIPTest.new(test, start_time, Thread.current)
       @wip << wip_test
       runtime = time_it(start_time) do
         instance = test.test_class.new
```
