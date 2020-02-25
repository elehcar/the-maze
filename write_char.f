HEX

VARIABLE NEW_INDEX
VARIABLE CONT
VARIABLE CONT2
VARIABLE CONT3


DECIMAL

\ ( dato un valore a 32 bit restituisce il colore che corrisponde al bit n-esimo (che dipende da CONT) )
\ ( 32 bit val -- color )
: GET_COLOR 1 CONT3 @ LSHIFT AND 0 = IF YELLOW ELSE BG_COLOR THEN CONT3 @ 1 - CONT3 ! ;

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

\ ( disegna la lettera passata a partire dalla colonna e riga specificata ) 
\ ( char n_col n_row -- )
: MATRIX FIND_ADDRESS NEW_INDEX ! GET_CHAR HALF_MATRIX HALF_MATRIX ;


: FAIL 70 57 310 MATRIX 65 67 310 MATRIX 73 77 310 MATRIX 76 87 310 MATRIX ;
: OK 79 65 310 MATRIX 75 75 310 MATRIX ;
: WRITE_START 83 52 310 MATRIX 84 62 310 MATRIX 65 72 310 MATRIX 82 82 310 MATRIX 84 92 310 MATRIX ;

: GO 71 65 310 MATRIX 79 75 310 MATRIX ;

: THE_MAZE 84 52 99 MATRIX 72 62 99 MATRIX 69 72 99 MATRIX 77 92 99 MATRIX 65 102 99 MATRIX 90 112 99 MATRIX 69 122 99 MATRIX ;

: YEAR 49 786 620 MATRIX 57 794 620 MATRIX 47 802 620 MATRIX 50 810 620 MATRIX 48 818 620 MATRIX ;
: SISTEMI_EMBEDDED 83 650 620 MATRIX 73 658 620 MATRIX 83 666 620 MATRIX 84 674 620 MATRIX 69 682 620 MATRIX 77 690 620 MATRIX 73 698 620 MATRIX 44 706 620 MATRIX 69 714 620 MATRIX 77 722 620 MATRIX 66 730 620 MATRIX 69 738 620 MATRIX 68 746 620 MATRIX 68 754 620 MATRIX 69 762 620 MATRIX 68 770 620 MATRIX YELLOW COLOR ! 650 619 826 619 DRAW_ROW ;

: FOOTER SISTEMI_EMBEDDED 44 778 620 MATRIX YEAR ;






