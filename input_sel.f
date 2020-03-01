\ In questo file specifichiamo il funzionamento del GPIO n-esimo in modo tale che quelli connessi ai pulsanti siano di input

HEX

3F200000 CONSTANT GPFSEL0

\ Definiamo le costanti che corrispondono al pin GPIO cui sono collegati i pulsanti

\ GPIO 25
19 CONSTANT BUTTON_OFF
\ GPIO 16
10 CONSTANT BUTTON_RESET
\ GPIO 22
16 CONSTANT BUTTON_RIGHT
\ GPIO 23
17 CONSTANT BUTTON_DOWN
\ GPIO 24
18 CONSTANT BUTTON_UP
\ GPIO 27
1B CONSTANT BUTTON_LEFT


\ Questa parola ci permette, a partire dal numero di una porta, di ottenere l'indirizzo del registro GPFSEL e il bit n-esimo di tale registro da cui iniziare a scrivere

\ ( gpio_number -- GPFSELN offset )
: GPFSEL 
	\ Effettuiamo la divisione per 10 del numero del pin perché ogni registro GPFSEL permette di configurare 10 pin, e questo lo moltiplichiamo per 4
	\ ovvero la grandezza in byte di un registro,  e lo sommiamo al primo registro GPFSEL0 per ottenere l'indirizzo del GPFSEL corretto 
	\ ( gpio_number -- reminder GPFSELN )
	A /MOD 4 * GPFSEL0 + 
	\ Calcoliamo l'offset nel registro per trovare il primo bit di configurazione del pin di interesse
	\ Questo viene fatto moltiplicando il resto della divisione per 3, poiché ad ogni pin GPIO sono assegnti 3 bit nel registro
	\ ( reminder GPFSELN -- GPFSELN offset )
	SWAP 3 * ;


\ Attraverso questa definizione possiamo specificare il funzionamento del pin GPIO indicato come input

\ ( gpio_number -- )
: INPUT_SEL
	\ Ricaviamo con la parola GPFSEL il registro GPFSEL relativo al pin specificato e l'offset, inoltre inseriamo 7 che rappresenta una maschera con 3 bit a 1
	\ ( gpio_number -- GPFSELN 7 offset ) 
	GPFSEL 7 SWAP 
	\ Shiftiamo la maschera in modo che i 3 bit a 1 corrispondano ai bit del registro relativi al pin, attraverso l'offset ricavato
	\ Inoltre mettiamo sullo stack il valore contenuto in GPFSELN
	\ ( GPFSELN 7 offset -- GPFSELN gpfesln_value gpio_mask  )
	LSHIFT OVER @ SWAP 
	\ Le operazioni seguenti ci permettono di ottenere il nuovo valore da inserire in GPFSELN in modo da specificare a 0 tutti i bit relativi al pin di interesse, lasciando invece inalterati gli altri
	\ ( GPFSELN gpfesln_value gpio_mask -- GPFSELN new_fsel_value )
	INVERT AND 
	\ Infine salviamo il valore calcolato nel registro
	\ ( GPFSELN new_fsel_value -- )
	SWAP ! ;


\ Settiamo i pin GPIO che corrispondono ai pulsanti come input

BUTTON_OFF INPUT_SEL
BUTTON_RESET INPUT_SEL
BUTTON_RIGHT INPUT_SEL
BUTTON_LEFT INPUT_SEL
BUTTON_DOWN INPUT_SEL
BUTTON_UP INPUT_SEL




