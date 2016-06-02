## YAML Comparison: JRuby 1.7 vs. 9k

This benchmark is executed by running the `run_mvn_jrubies.rb`
script in this directory.  The script can iterate over several
different versions of JRuby (1.7.20.1 and 9.1.1.0) and
several different values for the JRuby `compileMode` setting
(default/not specified, `jit`, `off`, and `force`).

For each permutation the benchmark simply serializes and
deserializes the `report.yaml` file (which is about 2MB).
It does 100 executions of this as a "warm up" phase, then
1000 executions as the "main" phase, and then 100 more as
a final/tail phase.  The data for these phases can be found
in the csv file `maven_yaml_benchmark_output.csv`.

The main takeaway is that JRuby 9k is slower than JRuby 1.7
for each `compileMode` but the value of the `compileMode`
setting makes a big difference in the delta between the two.

* For a `compileMode` of `OFF`, JRuby 9k is about 70% slower
  than JRuby 1.7.
* For a `compileMode` of `JIT`, JRuby 9k is about 6% slower
  than JRuby 1.7.

Here is some of the relevant output:

```
Setting compileMode to: 'OFF'
JRUBY VERSION: 1.7.20.1
COMPILE MODE: off
              user     system      total        real
warmup (100 runs):119.943000   0.000000 119.943000 (119.943000)
middle (1000 runs):1180.235000   0.000000 1180.235000 (1180.235000)
tail (100 runs):119.490000   0.000000 119.490000 (119.490000)

JRUBY VERSION: 9.1.1.0
COMPILE MODE: off
              user     system      total        real
warmup (100 runs):214.540000   1.580000 216.120000 (197.092316)
middle (1000 runs):1999.160000   4.980000 2004.140000 (1974.245946)
tail (100 runs):200.320000   0.510000 200.830000 (198.179622)
```
