; Turn on Q when IN pushed
	ORG 0000h

START	REQ	; Q -> off
CHKIN	BN4 START ; goto start while IN not pressed.
	SEQ	; Q -> On
	BR CHKIN ; back to not pressed
	
	END
	0000000      0071    8bc0    9e00    81ff
	
	
Your engines will automatically shut down if you should attempt to leave the galaxy, or if you should try to maneuver through a star, a Starbase, or -- heaven help you -- a Klingon warship.


SEC  FEET      SPEED     FUEL     PLOT OF DISTANCE

 0    1000      50        150     I                                        *
? 0
 1    947.5     55        150     I                                      *
? 0
 2    890       60        150     I                                    *
? 0
 3    827.5     65        150     I                                 *
? 0
 4    760       70        150     I                              *
? 0
 5    687.5     75        150     I                            *
? 0
 6    610       80        150     I                        *
? 0
 7    527.5     85        150     I                     *
? 0
 8    440       90        150     I                  *
? 0
 9    347.5     95        150     I              *
? 16
 10   258       84        134     I          *
? 16
 11   179.5     73        118     I       *
? 16
 12   112       62        102     I    *
? 16
 13   55.5      51        86      I  *
? 30
 14   17        26        56      I *
? 30
 15   3.5       1         26      I*
? 6
 16   3         0         20      I*
? 4
 17   2.5       1         16      I*
? 5
 18   1.5       1         11      I*
? 5
 19   .5        1         6       I*
? 5
***** CONTACT *****