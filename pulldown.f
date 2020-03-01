\ In questo file settiamo i resistori interni dei pin GPIO connessi ai pulsanti in modo da avere un comportamento pull-down

HEX

3F200094 CONSTANT GPPUD
3F200098 CONSTANT GPCLK0

\ Definiamo una parola per inserire un ritardo dei microsecondi specificati attraverso un ciclo
\ ( microseconds -- )
: DELAY BEGIN 1 - DUP 0 = UNTIL DROP ;

\ Settiamo il segnale di controllo del registro GPPUD a 01, corrispondente al Pull-Down
01 GPPUD !
\ Aspettiamo 150 cicli
150 DELAY
\ Settiamo a 1 i bit corrispondenti ai GPIO di cui vogliamo abilitare il resistore Pull-Down interno
BC10000 GPCLK0 !
\ Aspettiamo 150 cicli in modo che il segnale di controllo abbia effetto sui pin
150 DELAY
\ Ripristiamo i registri: rimuoviamo il segnale di controllo e il clock
0 GPPUD !
0 GPCLK0 !

