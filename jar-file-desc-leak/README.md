## Jar file descriptor leak in JRuby 9k

This reproducer is executed by running the `run_mvn_jruby.rb`
script in this directory.  The test performs a loop, in each
iteration of which, a `ScriptingContainer` is created, a few
`require` statements are executed in order to trigger the loading
of some jar files from jruby-stdlib, and then the `ScriptingContainer`
is terminated.

The reproducer illustrates that with each new `ScriptingContainer`
that is constructed, a few file descriptors are created that are
not closed when the `ScriptingContainer` is terminated.  If the
loop were run indefinitely, this would
result in an error and JVM shutdown when the process exceeds the
max number of open file descriptors.

Here is the relevant output from a run:

```
Iteration #0; number of open fd: 113
Iteration #1; number of open fd: 116
Iteration #2; number of open fd: 119
Iteration #3; number of open fd: 122
Iteration #4; number of open fd: 125
Iteration #5; number of open fd: 128
Iteration #6; number of open fd: 131
Iteration #7; number of open fd: 134
Iteration #8; number of open fd: 137
Iteration #9; number of open fd: 140
Final list of JRuby jar fds from lsof output:

java    11917 cprice  mem    REG                8,1  1029206  1848477 /tmp/jruby-11917/jruby6116449132616665179jopenssl.jar
java    11917 cprice  mem    REG                8,1  3277268  1848476 /tmp/jruby-11917/jruby8057980044110295514bcprov-jdk15on-1.54.jar
java    11917 cprice  mem    REG                8,1   673715  1848475 /tmp/jruby-11917/jruby6746548661217345001bcpkix-jdk15on-1.54.jar
java    11917 cprice  mem    REG                8,1  1029206  1848472 /tmp/jruby-11917/jruby5268671342197714636jopenssl.jar
java    11917 cprice  mem    REG                8,1  3277268  1848471 /tmp/jruby-11917/jruby8616924652119935894bcprov-jdk15on-1.54.jar
java    11917 cprice  mem    REG                8,1   673715  1848470 /tmp/jruby-11917/jruby718961693492830398bcpkix-jdk15on-1.54.jar
java    11917 cprice  mem    REG                8,1  1029206  1848467 /tmp/jruby-11917/jruby2224460315049133366jopenssl.jar
java    11917 cprice  mem    REG                8,1  3277268  1848466 /tmp/jruby-11917/jruby1625116621031038430bcprov-jdk15on-1.54.jar
java    11917 cprice  mem    REG                8,1   673715  1848465 /tmp/jruby-11917/jruby7934760686526010976bcpkix-jdk15on-1.54.jar
java    11917 cprice  mem    REG                8,1  1029206  1848462 /tmp/jruby-11917/jruby5691824255259771280jopenssl.jar
java    11917 cprice  mem    REG                8,1  3277268  1848461 /tmp/jruby-11917/jruby8223665694054971489bcprov-jdk15on-1.54.jar
java    11917 cprice  mem    REG                8,1   673715  1848460 /tmp/jruby-11917/jruby9133328989809074645bcpkix-jdk15on-1.54.jar
java    11917 cprice  mem    REG                8,1  1029206  1848457 /tmp/jruby-11917/jruby6690709371337774588jopenssl.jar
java    11917 cprice  mem    REG                8,1  3277268  1848456 /tmp/jruby-11917/jruby2751744501674940406bcprov-jdk15on-1.54.jar
java    11917 cprice  mem    REG                8,1   673715  1848455 /tmp/jruby-11917/jruby3894242426847276881bcpkix-jdk15on-1.54.jar
java    11917 cprice  mem    REG                8,1  1029206  1848452 /tmp/jruby-11917/jruby5298227196782168359jopenssl.jar
java    11917 cprice  mem    REG                8,1  3277268  1848451 /tmp/jruby-11917/jruby6428163232732671117bcprov-jdk15on-1.54.jar
java    11917 cprice  mem    REG                8,1   673715  1848450 /tmp/jruby-11917/jruby530422175687396649bcpkix-jdk15on-1.54.jar
java    11917 cprice  mem    REG                8,1  1029206  1848447 /tmp/jruby-11917/jruby3827382223256559228jopenssl.jar
java    11917 cprice  mem    REG                8,1  3277268  1848446 /tmp/jruby-11917/jruby4947968028008718370bcprov-jdk15on-1.54.jar
java    11917 cprice  mem    REG                8,1   673715  1848445 /tmp/jruby-11917/jruby4152738364162376673bcpkix-jdk15on-1.54.jar
java    11917 cprice  mem    REG                8,1  1029206  1848442 /tmp/jruby-11917/jruby8281334684274781156jopenssl.jar
java    11917 cprice  mem    REG                8,1  3277268  1848441 /tmp/jruby-11917/jruby4871703274166521937bcprov-jdk15on-1.54.jar
java    11917 cprice  mem    REG                8,1   673715  1848440 /tmp/jruby-11917/jruby7486828636589077140bcpkix-jdk15on-1.54.jar
java    11917 cprice  mem    REG                8,1  1029206  1848428 /tmp/jruby-11917/jruby6324730607760993600jopenssl.jar
java    11917 cprice  mem    REG                8,1  3277268  1848425 /tmp/jruby-11917/jruby1912676123007109117bcprov-jdk15on-1.54.jar
java    11917 cprice  mem    REG                8,1   673715  1848424 /tmp/jruby-11917/jruby4743370077647379364bcpkix-jdk15on-1.54.jar
java    11917 cprice  mem    REG                8,1  3277268  1848356 /tmp/jruby-11917/jruby5213953911229735329bcprov-jdk15on-1.54.jar
java    11917 cprice  mem    REG                8,1  1029206  1848358 /tmp/jruby-11917/jruby5720880290818518395jopenssl.jar
java    11917 cprice  mem    REG                8,1   673715  1848353 /tmp/jruby-11917/jruby734320860519953417bcpkix-jdk15on-1.54.jar
java    11917 cprice  mem    REG               8,17 10384505 11274416 /home/cprice/.m2/repository/org/jruby/jruby-stdlib/9.1.1.0/jruby-stdlib-9.1.1.0.jar
java    11917 cprice  mem    REG               8,17    16400 11274395 /home/cprice/.m2/repository/org/jruby/dirgra/0.3/dirgra-0.3.jar
java    11917 cprice  mem    REG               8,17  1600548 11274394 /home/cprice/.m2/repository/org/jruby/jcodings/jcodings/1.0.17/jcodings-1.0.17.jar
java    11917 cprice  mem    REG               8,17    11031 11274393 /home/cprice/.m2/repository/org/jruby/extras/bytelist/1.0.13/bytelist-1.0.13.jar
java    11917 cprice  mem    REG               8,17   190899 11274390 /home/cprice/.m2/repository/org/jruby/joni/joni/2.1.10/joni-2.1.10.jar
java    11917 cprice  mem    REG               8,17  8960776 11274414 /home/cprice/.m2/repository/org/jruby/jruby-core/9.1.1.0/jruby-core-9.1.1.0.jar
java    11917 cprice   81r   REG               8,17  8960776 11274414 /home/cprice/.m2/repository/org/jruby/jruby-core/9.1.1.0/jruby-core-9.1.1.0.jar
java    11917 cprice   89r   REG               8,17   190899 11274390 /home/cprice/.m2/repository/org/jruby/joni/joni/2.1.10/joni-2.1.10.jar
java    11917 cprice   90r   REG               8,17    11031 11274393 /home/cprice/.m2/repository/org/jruby/extras/bytelist/1.0.13/bytelist-1.0.13.jar
java    11917 cprice   91r   REG               8,17  1600548 11274394 /home/cprice/.m2/repository/org/jruby/jcodings/jcodings/1.0.17/jcodings-1.0.17.jar
java    11917 cprice   92r   REG               8,17    16400 11274395 /home/cprice/.m2/repository/org/jruby/dirgra/0.3/dirgra-0.3.jar
java    11917 cprice   98r   REG               8,17 10384505 11274416 /home/cprice/.m2/repository/org/jruby/jruby-stdlib/9.1.1.0/jruby-stdlib-9.1.1.0.jar
java    11917 cprice  108r   REG                8,1   673715  1848353 /tmp/jruby-11917/jruby734320860519953417bcpkix-jdk15on-1.54.jar
java    11917 cprice  110r   REG                8,1  3277268  1848356 /tmp/jruby-11917/jruby5213953911229735329bcprov-jdk15on-1.54.jar
java    11917 cprice  111r   REG                8,1  1029206  1848358 /tmp/jruby-11917/jruby5720880290818518395jopenssl.jar
java    11917 cprice  112r   REG                8,1   673715  1848424 /tmp/jruby-11917/jruby4743370077647379364bcpkix-jdk15on-1.54.jar
java    11917 cprice  114r   REG                8,1  3277268  1848425 /tmp/jruby-11917/jruby1912676123007109117bcprov-jdk15on-1.54.jar
java    11917 cprice  115r   REG                8,1  1029206  1848428 /tmp/jruby-11917/jruby6324730607760993600jopenssl.jar
java    11917 cprice  116r   REG                8,1   673715  1848440 /tmp/jruby-11917/jruby7486828636589077140bcpkix-jdk15on-1.54.jar
java    11917 cprice  117r   REG                8,1  3277268  1848441 /tmp/jruby-11917/jruby4871703274166521937bcprov-jdk15on-1.54.jar
java    11917 cprice  118r   REG                8,1  1029206  1848442 /tmp/jruby-11917/jruby8281334684274781156jopenssl.jar
java    11917 cprice  119r   REG                8,1   673715  1848445 /tmp/jruby-11917/jruby4152738364162376673bcpkix-jdk15on-1.54.jar
java    11917 cprice  120r   REG                8,1  3277268  1848446 /tmp/jruby-11917/jruby4947968028008718370bcprov-jdk15on-1.54.jar
java    11917 cprice  121r   REG                8,1  1029206  1848447 /tmp/jruby-11917/jruby3827382223256559228jopenssl.jar
java    11917 cprice  122r   REG                8,1   673715  1848450 /tmp/jruby-11917/jruby530422175687396649bcpkix-jdk15on-1.54.jar
java    11917 cprice  123r   REG                8,1  3277268  1848451 /tmp/jruby-11917/jruby6428163232732671117bcprov-jdk15on-1.54.jar
java    11917 cprice  124r   REG                8,1  1029206  1848452 /tmp/jruby-11917/jruby5298227196782168359jopenssl.jar
java    11917 cprice  125r   REG                8,1   673715  1848455 /tmp/jruby-11917/jruby3894242426847276881bcpkix-jdk15on-1.54.jar
java    11917 cprice  126r   REG                8,1  3277268  1848456 /tmp/jruby-11917/jruby2751744501674940406bcprov-jdk15on-1.54.jar
java    11917 cprice  127r   REG                8,1  1029206  1848457 /tmp/jruby-11917/jruby6690709371337774588jopenssl.jar
java    11917 cprice  128r   REG                8,1   673715  1848460 /tmp/jruby-11917/jruby9133328989809074645bcpkix-jdk15on-1.54.jar
java    11917 cprice  129r   REG                8,1  3277268  1848461 /tmp/jruby-11917/jruby8223665694054971489bcprov-jdk15on-1.54.jar
java    11917 cprice  130r   REG                8,1  1029206  1848462 /tmp/jruby-11917/jruby5691824255259771280jopenssl.jar
java    11917 cprice  131r   REG                8,1   673715  1848465 /tmp/jruby-11917/jruby7934760686526010976bcpkix-jdk15on-1.54.jar
java    11917 cprice  132r   REG                8,1  3277268  1848466 /tmp/jruby-11917/jruby1625116621031038430bcprov-jdk15on-1.54.jar
java    11917 cprice  133r   REG                8,1  1029206  1848467 /tmp/jruby-11917/jruby2224460315049133366jopenssl.jar
java    11917 cprice  134r   REG                8,1   673715  1848470 /tmp/jruby-11917/jruby718961693492830398bcpkix-jdk15on-1.54.jar
java    11917 cprice  135r   REG                8,1  3277268  1848471 /tmp/jruby-11917/jruby8616924652119935894bcprov-jdk15on-1.54.jar
java    11917 cprice  136r   REG                8,1  1029206  1848472 /tmp/jruby-11917/jruby5268671342197714636jopenssl.jar
java    11917 cprice  137r   REG                8,1   673715  1848475 /tmp/jruby-11917/jruby6746548661217345001bcpkix-jdk15on-1.54.jar
java    11917 cprice  138r   REG                8,1  3277268  1848476 /tmp/jruby-11917/jruby8057980044110295514bcprov-jdk15on-1.54.jar
java    11917 cprice  139r   REG                8,1  1029206  1848477 /tmp/jruby-11917/jruby6116449132616665179jopenssl.jar
Final FD count exceeds initial FD count by: 59
Final JRuby Jar FD count exceeds initial by: 60
```