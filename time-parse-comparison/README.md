## Time.parse Comparison: JRuby 1.7 vs. 9k

This benchmark is executed by running the `run_mvn_jrubies.rb`
script in this directory.  The script can iterate over several
different versions of JRuby (1.7.20.1, 9.1.0.0, and 9.1.1.0),
and several different values for the JRuby `compileMode` setting
(default/not specified, `jit`, `off`, and `force`).

For each permutation the benchmark simply calls Time.parse
to parse a date string into a timestamp.  It does 100 executions
of this as a "warm up" phase, then 10000 executions as the "main"
phase, and then 100 more as a final/tail phase.  The data for
these phases can be found in the file
`maven_timestamp_benchmark_output.txt`.

The main takeaways are:
* JRuby 1.7 seems to be significantaly faster (over 60%) at
  parsing date strings.
* JIT doesn't make a ton of difference in performance for this
  operation in JRuby 1.7.
* JIT makes the parsing a good deal slower in JRuby 9k (though it's
  certainly possible that we'd need to run something for much longer
  than this benchmark to get a fair evaluation of the JIT).

Here is some of the relevant output:

```
JRUBY VERSION: 1.7.20.1
COMPILE MODE: off
                           user     system      total        real
warmup (100 runs):     0.213000   0.000000   0.213000 (  0.213000)
middle (10000 runs):   1.179000   0.000000   1.179000 (  1.179000)
tail (100 runs):       0.009000   0.000000   0.009000 (  0.009000)

JRUBY VERSION: 9.1.1.0
COMPILE MODE: off
                           user     system      total        real
warmup (100 runs):     0.730000   0.010000   0.740000 (  0.138776)
middle (10000 runs):   4.890000   0.300000   5.190000 (  1.905043)
tail (100 runs):       0.030000   0.010000   0.040000 (  0.019285)
```
