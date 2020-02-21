HEX

VARIABLE NEW_INDEX
VARIABLE CONT
VARIABLE CONT2
VARIABLE CONT3


DECIMAL

\ ( dato un valore a 32 bit restituisce il colore che corrisponde al bit n-esimo (che dipende da CONT) )
\ ( 32 bit val -- color )
: GET_COLOR 1 CONT3 @ LSHIFT AND 0 = IF WHITE ELSE BG_COLOR THEN CONT3 @ 1 - CONT3 ! ;

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


: FAIL 70 52 310 MATRIX 65 62 310 MATRIX 73 72 310 MATRIX 76 82 310 MATRIX ;
: OK 79 52 310 MATRIX 75 62 310 MATRIX ;
: WRITE_START 83 52 310 MATRIX 84 62 310 MATRIX 65 72 310 MATRIX 82 82 310 MATRIX 84 92 310 MATRIX ;













