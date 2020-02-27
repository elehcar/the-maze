\ In questo file vengono definite le parole necessarie per la scrittura dei caratteri a video, una volta inseriti nel dizionario con il file font.f . Inoltre vengono definite delle parole per scrivere delle stringhe necessarie alla grafica del gioco
HEX

VARIABLE MAT_INDEX
VARIABLE CONT1
VARIABLE CONT2
VARIABLE CONT3


DECIMAL

\ Definiamo una parola per duplicare i primi tre valori presenti sullo stack
\ ( x y z - x y z x y z )
: 3DUP DUP 2OVER ROT ;

 
\ Definiamo una parola che permetta, dato un valore a 32 bit, di ottenere il colore che corrisponde al bit n-esimo: 0 corrisponde al colore di sfondo delle stringhe, 1 al colore di scrittura dei caratteri
\ ( val_32bit -- color )
: GET_COLOR
	\ generiamo un numero che abbia tutti i bit pari a 0 ad eccezione del bit di posizione pari al valore specificato in CONT3 
	\ (val_32bit -- val_32bit mask_val )
	1 CONT3 @ LSHIFT 
	\ otteniamo 0 se il bit n-esimo del valore specificato era 0, altrimenti mask_val
	AND 0 = 
	IF 
	   \ ( -- color_bg )
	   YELLOW 
	ELSE
	   \ ( -- color_char )
	   BG_COLOR 
	THEN
	   \ decrementiamo il conteggio dei bit e aggiorniamo il valore della variabile CONT3 
	   CONT3 @ 1 - CONT3 ! ;

\ Scrive il colore presente sullo stack nella posizione specificata nella variabile MAT_INDEX e lo aggiorna alla colonna successiva
\ ( color -- )
: SET_PIXEL 
	MAT_INDEX @ 
	DUP ROT SWAP ! 4 + 
	MAT_INDEX ! ;

\ Parola utilizzata per disegnare una riga della matrice a seconda del valore di 8 bit del numero passato sullo stack
\ ( val_32bit -- )
: SET_ROW 
	\ Usiamo la variabile CONT1 per contare il numero di bit considerati, da 0 a 8
	0 CONT1 ! 
	BEGIN 
	   \ ( val_32bit -- val_32bit color )
	   DUP GET_COLOR
	   \ ( val_32bit color -- val_32bit )
	   SET_PIXEL 
	   \ verifichiamo la condizione di uscita , cioè che il valore del contatore sia uguale a 8
	   1 CONT1 @ + DUP CONT1 ! 8 = 
	\ se è verificata ripuliamo lo stack
	\ ( val_32bit -- )
	UNTIL 
	   DROP ;


\ Con questa parola a partire dall'indirizzo corrente spostiamo l'indirizzo all'inizio della riga successiva
: NEW_ROW 
	\ spostiamo l'indirizzo nella prima colonna in cui dobbiamo scrivere
	MAT_INDEX @ 4 8 * - 
	\ spostiamo l'indirizzo alla riga successiva e lo salviamo nella variabile MAT_INDEX
	4 WIDTH * + MAT_INDEX ! ;

\ Utilizziamo questa parola per scrivere quattro righe del carattere specificato
\ ovvero scriviamo la forma corrispondente a 32 bit
\ ( val_32bit -- ) 
: HALF_MATRIX 
	\ usiamo due variabili:
	\ CONT3 conta il numero di bit valutati a partire da 31 fino a 0
	\ CONT2 conta le righe scritte da 0 a 4
	31 CONT3 ! 0 CONT2 ! 
	BEGIN 
	   \ ( val_32bit -- val_32bit val_32bit)
	   DUP
	   \ scriviamo una riga e spostiamo l'indirizzo in cui scrivere all'inizio della riga successiva
	   \ (val_32bit val_32bit -- val_32bit)
	   SET_ROW NEW_ROW 
	   \ verifichiamo la condizione di uscita, ovvero che il contatore sia pari a 4
	   1 CONT2 @ + DUP CONT2 ! 4 = 
	\ se è verificata ripuliamo lo stack
	\ ( val_32bit -- )
	UNTIL 
	   DROP ;


\ Parola usata per ottenere i 2 valori a 32 bit che corrispondo alla forma del carattere specificato presente nel dictionary
\ ( char -- first_half second_half )
: GET_CHAR
	\ otteniamo l'indirizzo della forma sommando al base_addr del font l'offset dato dal carattere moltiplicato per 8 
	\ ( char -- shape_addr )
	8 * BASE_ADDR @ + 
	\ otteniamo la prima metà della forma prendendo il valore contenuto nel dictionary nell'indirizzo calcolato
	\ ( shape_addr -- first_half shape_addr)
	DUP @ SWAP 
	\ per ottenere la seconda metà ovvero i successivi 4 byte aggiungiamo 4 all'indirizzo precedente
	\ ( first_half shape_addr -- first_half second_half )
	4 + @ ;

\ Questa parola scrive un carattere specificato nelle coordinate indicate
\ ( char n_col n_row -- )
: MATRIX 
	\ usiamo la variabile MAT_INDEX per memorizzare l'indirizzo corrispondente alle coordinate indicate
	FIND_ADDRESS MAT_INDEX ! 
	\ ( char -- first_half second_half )
	GET_CHAR 
	\ (first_half second_half -- first_half )
	HALF_MATRIX 
	\ (first_half -- )
	HALF_MATRIX ;

\ passaggio iterativo per la scrittura delle parole
\ ( char n_row n_col --  n_row n_col_new n_col_new )
: CYCLE 
	\ ( char n_row n_col -- char n_col n_row char n_col n_row )
	SWAP 3DUP 
	\ (char n_col n_row char n_col n_row -- n_col n_row )
	MATRIX ROT DROP 
	\ otteniamo n_col_new incrementando di 8 l'indice di colonna precedente
	SWAP 8 + DUP ;

\ Definiamo delle parole che permettono di scrivere delle stringhe di caratteri sfruttando la parola CYCLE, inserendo in ogni parola il numero ASCII decimale corrispondente al carattere e le coordinate in cui inserire la prima lettera

: FAIL 76 73 65 70 310 60 BEGIN CYCLE 92 = UNTIL 2DROP ;

: WIN 78 73 87 310 70 BEGIN CYCLE 94 = UNTIL 2DROP ;

: START 84 82 65 84 83 310 60 BEGIN CYCLE 100 = UNTIL 2DROP ;

: GO 79 71 310 70 BEGIN CYCLE 86 = UNTIL 2DROP ;

: THE_MAZE 69 90 65 77 44 69 72 84 99 60 BEGIN CYCLE 124 = UNTIL 2DROP ;
  
: YEAR 48 50 47 57 49 620 786 BEGIN CYCLE 826 = UNTIL 2DROP ;

: SISTEMI 73 77 69 84 83 73 83 620 650 BEGIN CYCLE 706 = UNTIL 2DROP ;
: EMBEDDED 68 69 68 68 69 66 77 69 620 714 BEGIN CYCLE 778 = UNTIL 2DROP ; 

\ Inseriamo uno spazio tra due parole definite in precedenza
: SISTEMI_EMBEDDED SISTEMI 44 706 620 MATRIX EMBEDDED ;

\ Creiamo il footer combinado le parole SISTEMI_EMBEDDED e YEAR con uno spazio, aggiungendo inoltre una riga in alto per una grafica migliore
: FOOTER SISTEMI_EMBEDDED 44 778 620 MATRIX YEAR YELLOW COLOR ! 650 619 826 619 DRAW_ROW ;

\ Attraverso questa parola possiamo inizializzare tutto l'ambiente di gioco

: SET_UP DESKTOP MAZE LOGO THE_MAZE FOOTER ;


