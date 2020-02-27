
\ In questo file sono presenti tutte le definizioni necessarie per interagire con i pulsanti e per implementare la logica del gioco
HEX

3F200034 CONSTANT GPLEV0


VARIABLE START_POINT
VARIABLE START_CHECK
VARIABLE STOP_CHECK

\ Parola che, dato il numero della porta GPIO, restituisce la maschera corretta ovvero un numero che ha tutte le cifre pari a 0 ad eccezione del bit di posto pari al valore passato
\ ( button_gpio -- gpio_mask )
: GPIO_MASK 1 SWAP LSHIFT ;


\ Parola che permette di controllare se un pulsante è premuto o meno leggendo il valore contenuto nel registro GPLEV0

\ ( button_gpio -- flag )
: CHECK_BUTTON GPIO_MASK GPLEV0 @ AND 0 <> ;


\ Parola utilizzata per inizializzare lo schermo e le variabili 
: INIT_GAME
	\ Inizializziamo l'ambiente di gioco
	SET_UP
	\ Usiamo la variabile START_POINT per indicare il punto di partenza nel labirinto 
	100 135 FIND_ADDRESS START_POINT !
	\ inizializziamo la casella in cui scrivere informazioni sul gioco con la parola "START"
	RESET START ;


\ Ciclo che blocca il gioco qundo si arriva alla fine del labirinto finché non si preme il pulsante di Reset
: WAIT_RESET
	\ ( -- gpio_button )
	BUTTON_RESET 
	BEGIN
	   \ ( gpio_button -- gpio_button flag )
	   DUP CHECK_BUTTON 
	\ se il pulsante di Reset viene premuto si esce dal ciclo, si ripulisce lo stack e si inizializza il gioco
	\ ( gpio_button -- )
	UNTIL 
	   DROP INIT_GAME ;


\ Parola che verifica se il valore di START_POINT è uguale ad uno dei valori di uscita dal labirinto, memorizzati nella variabile START_CHECK

\ ( check_addr -- )
: CHECK_EXIT
	\ ( check_addr -- check_addr check_addr current_addr ) 
	DUP START_POINT @
	\ verifichiamo se l'indirizzo corrente corrisponde all'indirizzo di uscita check_addr 
	\ ( check_addr check_addr current_addr -- check_addr flag )
	=
	IF 
	   \ se la condizione è verificata viene stampato il messaggio "WIN" e il gioco viene fermato finché non si preme il pulsante Reset
	   \ ( check_addr -- )
	   DROP RESET WIN WAIT_RESET 
	ELSE 
	   \ altrimenti viene aggiornato il valore di START_CHECK
	   \ ( check_addr -- )
	   START_CHECK ! 
	THEN ;


\ Parola che serve per trovare il primo e l'ultimo indirizzo corrispondenti all'uscita del labirinto
\ Per salvare tali indirizzi vengono utilizzate le variabili START_CHECK e STOP_CHECK
: EXIT_ADDRS 2EC 12C FIND_ADDRESS START_CHECK ! 2EC 14B FIND_ADDRESS STOP_CHECK ! ;

\ Parola che permette di verificare se l'indirizzo in cui si sta scrivendo corrisponde all'uscita del labirinto
\ Se così è il gioco si ferma finché non si preme il pulsante di Reset
: TEST_WIN
	\ settiamo i valori delle variabili START_CHECK e STOP_CHECK 
	EXIT_ADDRS 
	BEGIN
	   \ spostiamo l'indirizzo corrente alla riga successiva
	   START_CHECK @ 4 WIDTH * +
	   \ controlliamo se il valore di START_CHECK corrisponde al valore di START_POINT
	   \ ( check_addr -- )
	   CHECK_EXIT
	   \ verifichiamo la condizione di fine ciclo, ovvero che START_CHECK e STOP_CHECK siano uguali
	   START_CHECK @ STOP_CHECK @ = 
	UNTIL ;



\ Si implementano i controlli del gioco: si verifica se la posizione in cui si deve scrivere è ammissibile o meno e inoltre si verifica se la posizione in cui si è arrivati corrisponde all'uscita del labirinto

\ ( green current_addr -- )
: CHECK 
	\ ( green current_addr -- green current_addr white current_addr )
	DUP WHITE SWAP @ 
	\ verifichiamo se l'indirizzo in cui dobbiamo scrivere non contiene già il colore bianco
	\ ( green current_addr white current_addr -- green current_addr flag )
	<> 
	IF
	   \ se la condizione è verificata salviamo l'indirizzo aggiornato nella variabile START_POINT e poi scriviamo il colore nella posizione specificata da current_addr
	   \ ( green current_addr -- )
	   DUP START_POINT ! ! 
	   \ verifichiamo se siamo arrivati alla fine del labirinto
	   TEST_WIN 
	ELSE 
	   \ se invece non è verificata ripuliamo lo stack e facciamo comparire il messaggio "FAIL" per poco tempo
	   \ ( green current_addr -- )
	   2DROP RESET FAIL 10000 DELAY 
	   \ stampiamo il messaggio "GO"
	   RESET GO 
	THEN ;


\ Le parole seguenti incrementano l'indirizzo in cui si scrive in maniera ooportuna a seconda della direzione in cui si deve andare, ovvero a seconda di quale pulsante è premuto, e successivamente viene decisa l'azione da compiere

\ ( green -- )
: VERIFY_R 
	START_POINT @ 4 + 
	\ (green current_addr -- )
	CHECK ;

\ ( green -- )
: VERIFY_L 
	START_POINT @ 4 - 
	\ (green current_addr -- )
	CHECK ;

\ ( green -- )
: VERIFY_U 
	START_POINT @ 4 WIDTH * -
	\ (green current_addr -- )
	CHECK ;

\ ( green -- )
: VERIFY_D 
	START_POINT @ 4 WIDTH * +
	\ (green current_addr -- ) 
	CHECK ;

\ Per ogni pulsante definiamo un ciclo che innanzitutto controlla se tale pulsante è premuto e se lo è chiama la logica per verificare l'azione da fare, altrimenti esce dal ciclo

\ ( green -- )
: WRITE_RIGHT
	\ ( green -- green button_right )
	BUTTON_RIGHT 
	BEGIN
	   \ verifichiamo se il pulsante è premuto
	   DUP CHECK_BUTTON
	WHILE 
	   \ se lo è controlliamo di stare scrivendo in un indirizzo possibile
	   \ ( green button_right -- button_right green green )
	   SWAP DUP
	   \ ( button_right green green -- green button_right )
	   VERIFY_R 1000 DELAY SWAP 
	REPEAT 
	\ se non lo è usciamo dal ciclo e ripuliamo lo stack
	\ ( green button_right -- )
	2DROP ;

\ ( green -- )
: WRITE_LEFT
	\ ( green -- green button_left ) 
	BUTTON_LEFT
	BEGIN
	   \ verifichiamo se il pulsante è premuto
	   DUP CHECK_BUTTON
	WHILE
	   \ se lo è controlliamo di stare scrivendo in un indirizzo possibile
	   \ ( green button_left -- button_left green green )
	   SWAP DUP 
	   \ ( button_left green green -- green button_left )
	   VERIFY_L 1000 DELAY SWAP 
	REPEAT 
	\ se non lo è usciamo dal ciclo e ripuliamo lo stack
	\ ( green button_left -- )
	2DROP ;

\ ( green -- )
: WRITE_DOWN
	\ ( green -- green button_down ) 
	BUTTON_DOWN 
	BEGIN
	   \ verifichiamo se il pulsante è premuto
	   DUP CHECK_BUTTON 
	WHILE
	   \ se lo è controlliamo di stare scrivendo in un indirizzo possibile
	   \ ( green button_down -- button_down green green )
	   SWAP DUP
	   \ ( button_down green green -- green button_down )
	   VERIFY_D 1000 DELAY SWAP 
	REPEAT
	\ se non lo è usciamo dal ciclo e ripuliamo lo stack
	\ ( green button_down -- )
	2DROP ;

\ ( green -- )
: WRITE_UP
	\ ( green -- green button_up )  
	BUTTON_UP 
	BEGIN 
	   \ verifichiamo se il pulsante è premuto
	   DUP CHECK_BUTTON 
	WHILE
	   \ se lo è controlliamo di stare scrivendo in un indirizzo possibile
	   \ ( green button_up -- button_up green green )
	   SWAP DUP 
	   \ ( button_up green green -- green button_up )
	   VERIFY_U 1000 DELAY SWAP 
	REPEAT
	\ se non lo è usciamo dal ciclo e ripuliamo lo stack
	\ ( green button_up -- )
	2DROP ;

\ ( green -- )
: GAME_CONTROL
	\ quadruplichiamo il green per poterlo passare a tutte le parole che controllano il valore dei pulsanti
	\ ( green -- green green green green )
	DUP 2DUP
	\ ( green green green green -- green green green )
	WRITE_RIGHT 
	\ ( green green green -- green green )
	WRITE_LEFT 
	\ ( green green -- green )
	WRITE_UP
	\ ( green -- )
	WRITE_DOWN ;


\ Parola utilizzata per resettare lo schermo e far ripartire il gioco da zero quando si preme il pulsante di Reset

: RESET_GAME
	\ verifichiamo che il pulsante di Reset sia premuto 
	BUTTON_RESET CHECK_BUTTON 
	IF
	   \ se la condizione è verificata inizializziamo lo schermo e le variabili
	   INIT_GAME
	\ altrimenti non fa nulla 
	THEN ;

\ Attraverso questa parola inizializziamo il gioco

: PLAY
	INIT_GAME
	BEGIN 
	   \ chiamiamo la logica che si occupa di controllare i diversi pulsanti e verificare se si è raggiunta la fine o si è sbattuto contro un muro del labirinto
	   GREEN GAME_CONTROL
	   \ controlliamo se il pulsante di RESET è stato premuto
	   RESET_GAME
	   \ verifichiamo la condizione di fine ciclo ovvero che il pulsante di OFF è stato premuto 
	   BUTTON_OFF CHECK_BUTTON
	\ se la condizione è verificata esce dal gioco e resetta lo schermo 
	UNTIL
	   DESKTOP ;


PLAY






