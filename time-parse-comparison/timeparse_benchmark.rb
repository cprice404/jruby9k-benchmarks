#!/usr/bin/env ruby

require 'benchmark'
require 'time'

puts "JRUBY VERSION: #{JRUBY_VERSION}"
compile_mode = ENV['COMPILE_MODE']
puts "COMPILE MODE: #{compile_mode}"

def do_time()
  Time.parse("Thu Nov 29 14:33:20 GMT 2001")
end

num_warmup_runs = 100
num_main_runs = 10000
num_tail_runs = 100

Benchmark.bm(20) do |x|
  warmup = x.report("warmup (#{num_warmup_runs} runs):") { (1..num_warmup_runs).each {|i| do_time() } }
  middle = x.report("middle (#{num_main_runs} runs):") { (1..num_main_runs).each {|i| do_time() } }
  tail = x.report("tail (#{num_warmup_runs} runs):") { (1..num_tail_runs).each {|i| do_time() } }
end
