#!/usr/bin/env ruby

require 'benchmark'
require 'yaml'
require './model_classes'

puts "JRUBY VERSION: #{JRUBY_VERSION}"
compile_mode = ENV['COMPILE_MODE']
puts "COMPILE MODE: #{compile_mode}"

def roundtrip()
  parsed = YAML.load_file("./report.yaml")
  back_to_yaml = YAML.dump(parsed)
end

open('maven_yaml_benchmark_output.csv', 'a') { |csv|
  num_warmup_runs = 100
  num_main_runs = 1000
  num_tail_runs = 100
  Benchmark.bm(7) do |x|
    warmup = x.report("warmup (#{num_warmup_runs} runs):") { (1..num_warmup_runs).each {|i| roundtrip() } }
    csv.puts("#{JRUBY_VERSION},#{compile_mode},warmup,#{warmup.utime},#{warmup.stime},#{warmup.total},#{warmup.real}")
    middle = x.report("middle (#{num_main_runs} runs):") { (1..num_main_runs).each {|i| roundtrip() } }
    csv.puts("#{JRUBY_VERSION},#{compile_mode},middle,#{middle.utime},#{middle.stime},#{middle.total},#{middle.real}")
    tail = x.report("tail (#{num_tail_runs} runs):") { (1..num_tail_runs).each {|i| roundtrip() } }
    csv.puts("#{JRUBY_VERSION},#{compile_mode},tail,#{tail.utime},#{tail.stime},#{tail.total},#{tail.real}")
  end

  puts
}
