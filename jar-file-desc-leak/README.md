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
Iteration #0; number of open fd: 115
Iteration #1; number of open fd: 120
Iteration #2; number of open fd: 125
Iteration #3; number of open fd: 130
Iteration #4; number of open fd: 135
Iteration #5; number of open fd: 140
Iteration #6; number of open fd: 145
Iteration #7; number of open fd: 150
Iteration #8; number of open fd: 155
Iteration #9; number of open fd: 160
Final list of JRuby jar fds from lsof output:

java    16802 cprice  mem    REG                8,1  1029206  1848495 /tmp/jruby-16802/jruby4734983808548108497jopenssl.jar
java    16802 cprice  mem    REG                8,1  3277268  1848494 /tmp/jruby-16802/jruby6109779259907062980bcprov-jdk15on-1.54.jar
java    16802 cprice  mem    REG                8,1   673715  1848493 /tmp/jruby-16802/jruby2517646537378734847bcpkix-jdk15on-1.54.jar
java    16802 cprice  mem    REG                8,1    29184  1848496 /tmp/jruby-16802/jruby1658078054671173220parser.jar
java    16802 cprice  mem    REG                8,1  1029206  1848488 /tmp/jruby-16802/jruby2262201270422384640jopenssl.jar
java    16802 cprice  mem    REG                8,1  3277268  1848487 /tmp/jruby-16802/jruby8183181496442107777bcprov-jdk15on-1.54.jar
java    16802 cprice  mem    REG                8,1   673715  1848486 /tmp/jruby-16802/jruby791041166383033485bcpkix-jdk15on-1.54.jar
java    16802 cprice  mem    REG                8,1  1029206  1848481 /tmp/jruby-16802/jruby8134376450898266715jopenssl.jar
java    16802 cprice  mem    REG                8,1  3277268  1848480 /tmp/jruby-16802/jruby2526682390458341590bcprov-jdk15on-1.54.jar
java    16802 cprice  mem    REG                8,1   673715  1848479 /tmp/jruby-16802/jruby4231261797459246050bcpkix-jdk15on-1.54.jar
java    16802 cprice  mem    REG                8,1  1029206  1848474 /tmp/jruby-16802/jruby8994351991239887757jopenssl.jar
java    16802 cprice  mem    REG                8,1  3277268  1848473 /tmp/jruby-16802/jruby6798692314103109139bcprov-jdk15on-1.54.jar
java    16802 cprice  mem    REG                8,1   673715  1848472 /tmp/jruby-16802/jruby6806797996603436306bcpkix-jdk15on-1.54.jar
java    16802 cprice  mem    REG                8,1  1029206  1848467 /tmp/jruby-16802/jruby7322224334486612844jopenssl.jar
java    16802 cprice  mem    REG                8,1  3277268  1848466 /tmp/jruby-16802/jruby1235438216237632531bcprov-jdk15on-1.54.jar
java    16802 cprice  mem    REG                8,1   673715  1848465 /tmp/jruby-16802/jruby2860243065379450626bcpkix-jdk15on-1.54.jar
java    16802 cprice  mem    REG                8,1  1029206  1848460 /tmp/jruby-16802/jruby1613901645171645387jopenssl.jar
java    16802 cprice  mem    REG                8,1  3277268  1848459 /tmp/jruby-16802/jruby522008274529111432bcprov-jdk15on-1.54.jar
java    16802 cprice  mem    REG                8,1   673715  1848458 /tmp/jruby-16802/jruby6532977639317181952bcpkix-jdk15on-1.54.jar
java    16802 cprice  mem    REG                8,1  1029206  1848453 /tmp/jruby-16802/jruby7020938871358899637jopenssl.jar
java    16802 cprice  mem    REG                8,1  3277268  1848452 /tmp/jruby-16802/jruby7623702282264772038bcprov-jdk15on-1.54.jar
java    16802 cprice  mem    REG                8,1   673715  1848451 /tmp/jruby-16802/jruby6069704161624954428bcpkix-jdk15on-1.54.jar
java    16802 cprice  mem    REG                8,1  1029206  1848446 /tmp/jruby-16802/jruby7076612372144062357jopenssl.jar
java    16802 cprice  mem    REG                8,1  3277268  1848445 /tmp/jruby-16802/jruby8110669387248216213bcprov-jdk15on-1.54.jar
java    16802 cprice  mem    REG                8,1   673715  1848444 /tmp/jruby-16802/jruby6621168293498756186bcpkix-jdk15on-1.54.jar
java    16802 cprice  mem    REG                8,1    36598  1848497 /tmp/jruby-16802/jruby3451778285607680674generator.jar
java    16802 cprice  mem    REG                8,1    36598  1848490 /tmp/jruby-16802/jruby8249386243245178423generator.jar
java    16802 cprice  mem    REG                8,1    29184  1848489 /tmp/jruby-16802/jruby7381052665382428377parser.jar
java    16802 cprice  mem    REG                8,1    36598  1848483 /tmp/jruby-16802/jruby8382658838024689723generator.jar
java    16802 cprice  mem    REG                8,1    29184  1848482 /tmp/jruby-16802/jruby2150106223798361691parser.jar
java    16802 cprice  mem    REG                8,1    36598  1848476 /tmp/jruby-16802/jruby5094925116383850051generator.jar
java    16802 cprice  mem    REG                8,1    29184  1848475 /tmp/jruby-16802/jruby2904537160201255642parser.jar
java    16802 cprice  mem    REG                8,1    36598  1848469 /tmp/jruby-16802/jruby36287313852322354generator.jar
java    16802 cprice  mem    REG                8,1    29184  1848468 /tmp/jruby-16802/jruby6187864258779301494parser.jar
java    16802 cprice  mem    REG                8,1    36598  1848462 /tmp/jruby-16802/jruby4831266292873055467generator.jar
java    16802 cprice  mem    REG                8,1  1029206  1848439 /tmp/jruby-16802/jruby1562241704385263944jopenssl.jar
java    16802 cprice  mem    REG                8,1  3277268  1848429 /tmp/jruby-16802/jruby7293487044124451845bcprov-jdk15on-1.54.jar
java    16802 cprice  mem    REG                8,1   673715  1848428 /tmp/jruby-16802/jruby6998982010056646143bcpkix-jdk15on-1.54.jar
java    16802 cprice  mem    REG                8,1  3277268  1848356 /tmp/jruby-16802/jruby2880599875144465129bcprov-jdk15on-1.54.jar
java    16802 cprice  mem    REG                8,1    29184  1848461 /tmp/jruby-16802/jruby2206016142659414194parser.jar
java    16802 cprice  mem    REG                8,1    36598  1848455 /tmp/jruby-16802/jruby5946497252110209787generator.jar
java    16802 cprice  mem    REG                8,1    29184  1848454 /tmp/jruby-16802/jruby8058906526608739574parser.jar
java    16802 cprice  mem    REG                8,1    36598  1848448 /tmp/jruby-16802/jruby5063674058304494719generator.jar
java    16802 cprice  mem    REG                8,1    29184  1848447 /tmp/jruby-16802/jruby3559685445711298115parser.jar
java    16802 cprice  mem    REG                8,1    36598  1848441 /tmp/jruby-16802/jruby4438480707448285767generator.jar
java    16802 cprice  mem    REG                8,1    29184  1848440 /tmp/jruby-16802/jruby5141171918222021903parser.jar
java    16802 cprice  mem    REG                8,1    36598  1848422 /tmp/jruby-16802/jruby1082429988669392443generator.jar
java    16802 cprice  mem    REG                8,1    29184  1848421 /tmp/jruby-16802/jruby7709661628926499696parser.jar
java    16802 cprice  mem    REG                8,1  1029206  1848358 /tmp/jruby-16802/jruby6582576277490479690jopenssl.jar
java    16802 cprice  mem    REG                8,1   673715  1848353 /tmp/jruby-16802/jruby2123769191320854687bcpkix-jdk15on-1.54.jar
java    16802 cprice  mem    REG               8,17 10384505 11274416 /home/cprice/.m2/repository/org/jruby/jruby-stdlib/9.1.1.0/jruby-stdlib-9.1.1.0.jar
java    16802 cprice  mem    REG               8,17    16400 11274395 /home/cprice/.m2/repository/org/jruby/dirgra/0.3/dirgra-0.3.jar
java    16802 cprice  mem    REG               8,17  1600548 11274394 /home/cprice/.m2/repository/org/jruby/jcodings/jcodings/1.0.17/jcodings-1.0.17.jar
java    16802 cprice  mem    REG               8,17    11031 11274393 /home/cprice/.m2/repository/org/jruby/extras/bytelist/1.0.13/bytelist-1.0.13.jar
java    16802 cprice  mem    REG               8,17   190899 11274390 /home/cprice/.m2/repository/org/jruby/joni/joni/2.1.10/joni-2.1.10.jar
java    16802 cprice  mem    REG               8,17  8960776 11274414 /home/cprice/.m2/repository/org/jruby/jruby-core/9.1.1.0/jruby-core-9.1.1.0.jar
java    16802 cprice   81r   REG               8,17  8960776 11274414 /home/cprice/.m2/repository/org/jruby/jruby-core/9.1.1.0/jruby-core-9.1.1.0.jar
java    16802 cprice   89r   REG               8,17   190899 11274390 /home/cprice/.m2/repository/org/jruby/joni/joni/2.1.10/joni-2.1.10.jar
java    16802 cprice   90r   REG               8,17    11031 11274393 /home/cprice/.m2/repository/org/jruby/extras/bytelist/1.0.13/bytelist-1.0.13.jar
java    16802 cprice   91r   REG               8,17  1600548 11274394 /home/cprice/.m2/repository/org/jruby/jcodings/jcodings/1.0.17/jcodings-1.0.17.jar
java    16802 cprice   92r   REG               8,17    16400 11274395 /home/cprice/.m2/repository/org/jruby/dirgra/0.3/dirgra-0.3.jar
java    16802 cprice   98r   REG               8,17 10384505 11274416 /home/cprice/.m2/repository/org/jruby/jruby-stdlib/9.1.1.0/jruby-stdlib-9.1.1.0.jar
java    16802 cprice  108r   REG                8,1   673715  1848353 /tmp/jruby-16802/jruby2123769191320854687bcpkix-jdk15on-1.54.jar
java    16802 cprice  110r   REG                8,1  3277268  1848356 /tmp/jruby-16802/jruby2880599875144465129bcprov-jdk15on-1.54.jar
java    16802 cprice  111r   REG                8,1  1029206  1848358 /tmp/jruby-16802/jruby6582576277490479690jopenssl.jar
java    16802 cprice  112r   REG                8,1    29184  1848421 /tmp/jruby-16802/jruby7709661628926499696parser.jar
java    16802 cprice  114r   REG                8,1    36598  1848422 /tmp/jruby-16802/jruby1082429988669392443generator.jar
java    16802 cprice  115r   REG                8,1   673715  1848428 /tmp/jruby-16802/jruby6998982010056646143bcpkix-jdk15on-1.54.jar
java    16802 cprice  116r   REG                8,1  3277268  1848429 /tmp/jruby-16802/jruby7293487044124451845bcprov-jdk15on-1.54.jar
java    16802 cprice  117r   REG                8,1  1029206  1848439 /tmp/jruby-16802/jruby1562241704385263944jopenssl.jar
java    16802 cprice  118r   REG                8,1    29184  1848440 /tmp/jruby-16802/jruby5141171918222021903parser.jar
java    16802 cprice  119r   REG                8,1    36598  1848441 /tmp/jruby-16802/jruby4438480707448285767generator.jar
java    16802 cprice  120r   REG                8,1   673715  1848444 /tmp/jruby-16802/jruby6621168293498756186bcpkix-jdk15on-1.54.jar
java    16802 cprice  121r   REG                8,1  3277268  1848445 /tmp/jruby-16802/jruby8110669387248216213bcprov-jdk15on-1.54.jar
java    16802 cprice  122r   REG                8,1  1029206  1848446 /tmp/jruby-16802/jruby7076612372144062357jopenssl.jar
java    16802 cprice  123r   REG                8,1    29184  1848447 /tmp/jruby-16802/jruby3559685445711298115parser.jar
java    16802 cprice  124r   REG                8,1    36598  1848448 /tmp/jruby-16802/jruby5063674058304494719generator.jar
java    16802 cprice  125r   REG                8,1   673715  1848451 /tmp/jruby-16802/jruby6069704161624954428bcpkix-jdk15on-1.54.jar
java    16802 cprice  126r   REG                8,1  3277268  1848452 /tmp/jruby-16802/jruby7623702282264772038bcprov-jdk15on-1.54.jar
java    16802 cprice  127r   REG                8,1  1029206  1848453 /tmp/jruby-16802/jruby7020938871358899637jopenssl.jar
java    16802 cprice  128r   REG                8,1    29184  1848454 /tmp/jruby-16802/jruby8058906526608739574parser.jar
java    16802 cprice  129r   REG                8,1    36598  1848455 /tmp/jruby-16802/jruby5946497252110209787generator.jar
java    16802 cprice  130r   REG                8,1   673715  1848458 /tmp/jruby-16802/jruby6532977639317181952bcpkix-jdk15on-1.54.jar
java    16802 cprice  131r   REG                8,1  3277268  1848459 /tmp/jruby-16802/jruby522008274529111432bcprov-jdk15on-1.54.jar
java    16802 cprice  132r   REG                8,1  1029206  1848460 /tmp/jruby-16802/jruby1613901645171645387jopenssl.jar
java    16802 cprice  133r   REG                8,1    29184  1848461 /tmp/jruby-16802/jruby2206016142659414194parser.jar
java    16802 cprice  134r   REG                8,1    36598  1848462 /tmp/jruby-16802/jruby4831266292873055467generator.jar
java    16802 cprice  135r   REG                8,1   673715  1848465 /tmp/jruby-16802/jruby2860243065379450626bcpkix-jdk15on-1.54.jar
java    16802 cprice  136r   REG                8,1  3277268  1848466 /tmp/jruby-16802/jruby1235438216237632531bcprov-jdk15on-1.54.jar
java    16802 cprice  137r   REG                8,1  1029206  1848467 /tmp/jruby-16802/jruby7322224334486612844jopenssl.jar
java    16802 cprice  138r   REG                8,1    29184  1848468 /tmp/jruby-16802/jruby6187864258779301494parser.jar
java    16802 cprice  139r   REG                8,1    36598  1848469 /tmp/jruby-16802/jruby36287313852322354generator.jar
java    16802 cprice  140r   REG                8,1   673715  1848472 /tmp/jruby-16802/jruby6806797996603436306bcpkix-jdk15on-1.54.jar
java    16802 cprice  141r   REG                8,1  3277268  1848473 /tmp/jruby-16802/jruby6798692314103109139bcprov-jdk15on-1.54.jar
java    16802 cprice  142r   REG                8,1  1029206  1848474 /tmp/jruby-16802/jruby8994351991239887757jopenssl.jar
java    16802 cprice  143r   REG                8,1    29184  1848475 /tmp/jruby-16802/jruby2904537160201255642parser.jar
java    16802 cprice  144r   REG                8,1    36598  1848476 /tmp/jruby-16802/jruby5094925116383850051generator.jar
java    16802 cprice  145r   REG                8,1   673715  1848479 /tmp/jruby-16802/jruby4231261797459246050bcpkix-jdk15on-1.54.jar
java    16802 cprice  146r   REG                8,1  3277268  1848480 /tmp/jruby-16802/jruby2526682390458341590bcprov-jdk15on-1.54.jar
java    16802 cprice  147r   REG                8,1  1029206  1848481 /tmp/jruby-16802/jruby8134376450898266715jopenssl.jar
java    16802 cprice  148r   REG                8,1    29184  1848482 /tmp/jruby-16802/jruby2150106223798361691parser.jar
java    16802 cprice  149r   REG                8,1    36598  1848483 /tmp/jruby-16802/jruby8382658838024689723generator.jar
java    16802 cprice  150r   REG                8,1   673715  1848486 /tmp/jruby-16802/jruby791041166383033485bcpkix-jdk15on-1.54.jar
java    16802 cprice  151r   REG                8,1  3277268  1848487 /tmp/jruby-16802/jruby8183181496442107777bcprov-jdk15on-1.54.jar
java    16802 cprice  152r   REG                8,1  1029206  1848488 /tmp/jruby-16802/jruby2262201270422384640jopenssl.jar
java    16802 cprice  153r   REG                8,1    29184  1848489 /tmp/jruby-16802/jruby7381052665382428377parser.jar
java    16802 cprice  154r   REG                8,1    36598  1848490 /tmp/jruby-16802/jruby8249386243245178423generator.jar
java    16802 cprice  155r   REG                8,1   673715  1848493 /tmp/jruby-16802/jruby2517646537378734847bcpkix-jdk15on-1.54.jar
java    16802 cprice  156r   REG                8,1  3277268  1848494 /tmp/jruby-16802/jruby6109779259907062980bcprov-jdk15on-1.54.jar
java    16802 cprice  157r   REG                8,1  1029206  1848495 /tmp/jruby-16802/jruby4734983808548108497jopenssl.jar
java    16802 cprice  158r   REG                8,1    29184  1848496 /tmp/jruby-16802/jruby1658078054671173220parser.jar
java    16802 cprice  159r   REG                8,1    36598  1848497 /tmp/jruby-16802/jruby3451778285607680674generator.jar
Final FD count exceeds initial FD count by: 79
Final JRuby Jar FD count exceeds initial by: 100
```
