# Processing Euclidean Sequencer
An algorithm that produces [euclidean patterns](http://cgm.cs.mcgill.ca/~godfried/publications/banff.pdf) with capability of connecting MIDI inputs and outputs

![sequencer](https://i.imgur.com/LKizpDt.png)

## Overview
It's an implementation of my concept of creating such patterns which seems to be way simpler approach than [bjorklund's Algorithm](https://github.com/brianhouse/bjorklund). In order to create rhytmic pattern of length N with K steps one could simply quantize a segment between (0,0) and (N,K) and check at where the values change.

![quantizing example](https://i.imgur.com/80rE6MC.png)
It's easy to see that for N=13, K=5 the corresponding euclidean pattern is [1, 0, 0, 1, 0, 0, 1, 0, 1, 0, 0, 1, 0]
