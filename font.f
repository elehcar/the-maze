DECIMAL
: 2>R >R >R ;
: 2R> R> R> ;
: 3DUP DUP 2OVER ROT ;
: R@ R> DUP >R ;
: C, HERE @ C! 1 HERE +! ;

VARIABLE END_LOOP
VARIABLE BASE_ADDR
: FONT CREATE HERE 8 256 * ALLOT DOES> SWAP 8 * + ;

\ ( baseaddr c c c c c c c c cindex -- baseaddr )
\ : FONT-SHAPE 9 PICK SWAP 8 * + DUP 8 + SWAP END_LOOP1 ! BEGIN DUP ROT SWAP C! 1 -  DUP END_LOOP1 @ = UNTIL DROP ;
: FONT-SHAPE 9 PICK SWAP 8 * + DUP 8 + END_LOOP ! BEGIN DUP ROT SWAP C! 1 + DUP END_LOOP @ = UNTIL DROP ;
 


\ ( baseaddr cindex1 cindex2 -- )
\ : FONT-SHAPE-COPY  >R OVER SWAP 8 * + SWAP R> 8 * + 8 CMOVE ; 

\ : FONT-SHAPES OVER 2>R FONT-SHAPE 2R> TUCK  1 + SWAP END_LOOP ! BEGIN 3DUP FONT-SHAPE-COPY 1 + DUP END_LOOP @ = UNTIL RDROP ;

: BINARY 2 BASE ! ;

BINARY
FONT TheMaze BASE_ADDR !

BASE_ADDR @

00000000
00000000
00000000
00000000
00000000
00000000
00000000
00000000
CHAR , FONT-SHAPE

00110000
01111000
11001100
11001100
11111100
11001100
11001100
00000000
CHAR A FONT-SHAPE

11111100
01100110
01100110
01111100
01100110
01100110
11111100
00000000
CHAR B FONT-SHAPE

11111000
01101100
01100110
01100110
01100110
01101100
11111000
00000000
CHAR D FONT-SHAPE

11111110
01100010
01101000
01111000
01101000
01100000
11110000
00000000
CHAR F FONT-SHAPE

01111000
00110000
00110000
00110000
00110000
00110000
01111000
00000000
CHAR I FONT-SHAPE

11110000
01100000
01100000
01100000
01100010
01100110
11111110
00000000
CHAR L FONT-SHAPE

00111000
01101100
11000110
11000110
11000110
01101100
00111000
00000000
CHAR O FONT-SHAPE

11100110
01100110
01101100
01111000
01101100
01100110
11100110
00000000
CHAR K FONT-SHAPE

01111000
11001100
11100000
01110000
00011100
11001100
01111000
00000000
CHAR S FONT-SHAPE

11111100
10110100
00110000
00110000
00110000
00110000
01111000
00000000
CHAR T FONT-SHAPE

11111100
01100110
01100110
01111100
01101100
01100110
11100110
00000000
CHAR R FONT-SHAPE

00111100
01100110
11000000
11000000
11001110
01100110
00111110
00000000
CHAR G FONT-SHAPE

11001100
11001100
11001100
11111100
11001100
11001100
11001100
00000000
CHAR H FONT-SHAPE

11111110
01100010
01101000
01111000
01101000
01100010
11111110
00000000
CHAR E FONT-SHAPE

11000110
11101110
11111110
11111110
11010110
11000110
11000110
00000000
CHAR M FONT-SHAPE

11111110
11000110
10001100
00011000
00110010
01100110
11111110
00000000
CHAR Z FONT-SHAPE

01111000
11001100
00001100
00111000
01100000
11000100
11111100
00000000
CHAR 2 FONT-SHAPE

01111100
11000110
11001110
11011110
11110110
11100110
01111100
00000000
CHAR 0 FONT-SHAPE

00110000
01110000
00110000
00110000
00110000
00110000
11111100
00000000
CHAR 1 FONT-SHAPE

01111000
11001100
11001100
01111100
00001100
00011000
01110000
00000000
CHAR 9 FONT-SHAPE

00000110
00001100
00011000
00110000
01100000
11000000
10000000
00000000
CHAR / FONT-SHAPE

DROP
HEX



   




