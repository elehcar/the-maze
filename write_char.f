HEX
3E8FA000 CONSTANT FRAME_BUFFER
00000400 CONSTANT WIDTH
00000300 CONSTANT HEIGHT
FFFFFFFF CONSTANT WHITE
00000000 CONSTANT BG_COLOR

VARIABLE NEW_INDEX
VARIABLE CONT
VARIABLE CONT2
VARIABLE CONT3


DECIMAL

\ ( trova l'indirizzo corrispondente a una riga e una colonna )
\ ( n_colonna n_riga -- addess)
: FIND_ADDRESS 4 WIDTH * * SWAP 4 * FRAME_BUFFER + + ;


\ ( dato un valore a 32 bit restituisce il colore che corrisponde al bit n-esimo (che dipende da CONT) )
\ ( 32 bit val -- color )
: GET_COLOR 1 CONT3 @ LSHIFT AND 0 = IF BG_COLOR ELSE WHITE THEN CONT3 @ 1 - CONT3 ! ;

\ ( memorizza il colore nell'indirizzo corrente e lo incrementa )
\ ( color -- )
: SET_PIXEL NEW_INDEX @ DUP ROT SWAP ! 4 + NEW_INDEX ! ;

\ ( disegna una riga della matrice a seconda del valore dei primi 8 bit del valore passato)
\ ( 32 bit val -- )
: SET_ROW 0 CONT ! BEGIN DUP GET_COLOR SET_PIXEL 1 CONT @ + DUP CONT ! 8 = UNTIL DROP ;

\ ( a partire dall'indirizzo corrente vado all'inizio della riga successiva) 
: NEW_ROW NEW_INDEX @ 4 8 * - 4 WIDTH * + NEW_INDEX ! ;
\ ( disegna 4 righe corrispondenti al valore passato )
\ ( 32bitval -- ) 
: HALF_MATRIX 31 CONT3 ! 0 CONT2 ! BEGIN DUP SET_ROW NEW_ROW 1 CONT2 @ + DUP CONT2 ! 4 = UNTIL DROP ;


\ ( restituisce i 2 valori a 32 bit che corrispondo alla forma della lettera passata )
\ ( char -- )
: GET_CHAR 8 * BASE_ADDR @ + DUP @ SWAP 4 + @ ;

\ ( disegna la lettera passata a partire dalla riga e colonna specificata ) 
\ ( char 70 60 -- )
: MATRIX FIND_ADDRESS NEW_INDEX ! GET_CHAR HALF_MATRIX HALF_MATRIX ;


: FAIL 70 10 60 MATRIX 65 20 60 MATRIX 73 30 60 MATRIX 76 40 60 MATRIX ;
: OK 79 10 70 MATRIX 75 20 70 MATRIX ;
: START 83 10 80 MATRIX 84 20 80 MATRIX 65 30 80 MATRIX 82 40 80 MATRIX 84 50 80 MATRIX ;






















