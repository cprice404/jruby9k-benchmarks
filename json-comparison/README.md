## JSON Comparison: JRuby 1.7 vs. 9k

This benchmark is executed by running the `run_mvn_jrubies.rb`
script in this directory.  The script can iterate over several
different versions of JRuby (1.7.20.1, 9.1.0.0, and 9.1.1.0),
several different values for the JRuby `compileMode` setting
(default/not specified, `jit`, `off`, and `force`), and
several different JSON parsing libraries (`json/pure`, `json/ext`,
and `jrjackson`).

For each permutation the benchmark simply serializes and
deserializes the `report.json` file (which is about 2MB).
It does 100 executions of this as a "warm up" phase, then
1000 executions as the "main" phase, and then 100 more as
a final/tail phase.  The data for these phases can be found
in the csv file `maven_json_benchmark_output.csv`.

The main takeaways are:
* `json/ext` and `jrjackson` are obviously much, much faster
  than `json/pure`.
* JIT doesn't make a ton of difference in performance with
  `json/ext` and `jrjackson`, but it makes a huge difference
  in `json/pure`.
* The performance of JRuby 9k is similar to JRuby 1.7 in
  all cases except for the permutation where `compileMode`
  is set to `OFF` on `json/pure`.  In that combination,
  JRuby 1.7 is much faster than JRuby 9k.

Here is some of the relevant output:

```
JRUBY VERSION: 1.7.20.1
JSON VERSION: json/pure
COMPILE MODE: off
              user     system      total        real
warmup (100 runs): 79.419000   0.000000  79.419000 ( 79.418000)
middle (1000 runs):754.537000   0.000000 754.537000 (754.537000)
tail (100 runs): 74.968000   0.000000  74.968000 ( 74.968000)

JRUBY VERSION: 9.1.1.0
JSON VERSION: json/pure
COMPILE MODE: off
              user     system      total        real
warmup (100 runs):137.360000   1.240000 138.600000 (127.982415)
middle (1000 runs):1352.780000   1.620000 1354.400000 (1327.873641)
tail (100 runs):149.260000   0.350000 149.610000 (147.532336)
```
