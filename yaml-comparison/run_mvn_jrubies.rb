#!/usr/bin/env ruby

subcommand_output = 'maven_yaml_subcommand_output.txt'

benchmark_output_files = ['maven_yaml_benchmark_output.txt',
                          'maven_yaml_benchmark_output.csv',
                          subcommand_output]
benchmark_output_files.each do |f|
  if File.exists?(f)
    puts "Removing old benchmark output ('#{f}')"
    File.delete(f)
  end
end

jrubies = {
   "1.7.20.1" => {:mvn_profile => "jruby17"},
   #"9.1.0.0" => {:mvn_profile => "jruby9100"},
   "9.1.1.0" => {:mvn_profile => "jruby9110"},
}

compile_modes = [
   #"default",
   "jit",
   "off",
   #"force"
]

puts "Logging subcommand output to: #{subcommand_output}"
open(subcommand_output, 'w') do |f|
  jrubies.each do |jruby_version, info|
    puts "Cleaning to compile for JRuby version '#{jruby_version}'"
    f.puts `mvn clean`
    mvn_profile = info[:mvn_profile]
    puts "Compiling for JRuby version '#{jruby_version}'; mvn profile: '#{mvn_profile}'"
    f.puts `mvn -P #{mvn_profile} compile`
    compile_modes.each do |compile_mode|
      puts "Running JRuby #{jruby_version}, compile_mode: #{compile_mode}"
      f.puts `mvn -P #{mvn_profile} exec:java -Dexec.mainClass=jruby9k.Jruby9kYamlBenchmarkDriver -Dexec.args="#{jruby_version} #{compile_mode}"`
    end
  end
end
