\ Questo file contiene le definizioni per scrivere righe e colonne specificando gli indici iniziali e finali; inoltre definisce le parole per ottenere la grafica del gioco

HEX

3E8FA000 CONSTANT FRAME_BUFFER
00000300 CONSTANT HEIGHT
00000400 CONSTANT WIDTH


VARIABLE INDEX_INIT
VARIABLE INDEX_BLOCK
VARIABLE INDEX
VARIABLE COLOR

\ ( color start_addr -- color addr_next_col)
: ITER_ROW
	\ (color start_addr -- color start_addr color start_addr) 
	2DUP
	\ salviamo il colore nell'indirizzo corrente e poi lo incrementiamo per andare alla colonna successiva sommandogli 4
	\ ( color start_addr color start_addr -- color addr_next_col )
	! 4 + ;

\ ( color start_addr -- color addr_next_row)
: ITER_COL
	\ (color start_addr -- color start_addr color start_addr)  
	2DUP 
	\ salviamo il colore nell'indirizzo corrente e poi lo incrementiamo per andare alla riga successiva sommandogli la larghezza dello schermo moltiplcata per 4
	\ ( color start_addr color start_addr -- color addr_next_row )
	! 4 WIDTH * + ;

\ Parola per trovare l'indirizzo corrispondente all'indice di una riga e di una colonna 
\ (n_colonna n_riga -- indirizzo)
: FIND_ADDRESS 4 WIDTH * * SWAP 4 * FRAME_BUFFER + + ;


\ ( n_col_start n_row n_col_end n_row -- )
: DRAW_ROW 
	\ variabile INDEX utilizzata per memorizzare l'indirizzo di fine ciclo
	\ ( n_col_start n_row n_col_end n_row -- start_addr )
	FIND_ADDRESS INDEX ! FIND_ADDRESS
	\ variabile COLOR utilizzata per disegnare righe con diversi colori
	\ ( start_addr -- color start_addr ) 
	 COLOR @ SWAP 
	BEGIN 
	   \ ( color start_addr -- color addr_next_col )
	   ITER_ROW 
	   \ verifichiamo se addr_next_col è uguale a end_addr
	   DUP INDEX @ = 
	\ se è verificata ripuliamo lo stack
	\ ( color addr_next_col -- )
	UNTIL 
	   2DROP ;

\ ( n_col n_row_start n_col n_row_end -- )
: DRAW_COLUMN
	\ variabile INDEX utilizzata per memorizzare l'indirizzo di fine ciclo
	\ ( n_col n_row_start n_col n_row_end -- start_addr )
	FIND_ADDRESS INDEX ! FIND_ADDRESS 
	\ variabile COLOR utilizzata per disegnare righe con diversi colori
	\ ( start_addr -- color start_addr ) 
	COLOR @ SWAP 
	BEGIN 
	   \ ( color start_addr -- color addr_next_row  )
	   ITER_COL 
	   \ verifichiamo se addr_next_row è uguale a end_addr
	   DUP INDEX @ = 
	\ se è verificata ripuliamo lo stack
	\ ( color addr_next_row  -- )
	UNTIL 
	   2DROP ;


\ Disegniamo il labirinto e il suo bordo per segmenti verticali o orizzontali

: BORDER_ROW 100 4F 2ED 4F DRAW_ROW 100 4E 2ED 4E DRAW_ROW 100 23D 2ED 23D DRAW_ROW 100 23E 2ED 23E DRAW_ROW ;

: BORDER_COLUMN FE 4E FE 23F DRAW_COLUMN FF 4E FF 12D DRAW_COLUMN FF 14B FF 23F DRAW_COLUMN 2EE 4E 2EE 23F DRAW_COLUMN 2ED 4E 2ED 12D DRAW_COLUMN 2ED 14B 2ED 23F DRAW_COLUMN ;

: MAZE_A 100 50 2EC 50 DRAW_ROW 100 23C 2EC 23C DRAW_ROW 100 50 100 12D DRAW_COLUMN 100 14B 100 23C DRAW_COLUMN 2EC 50 2EC 12D DRAW_COLUMN 2EC 14B 2EC 23F DRAW_COLUMN ;

: MAZE_B 152 50 152 F4 DRAW_COLUMN 152 146 152 198 DRAW_COLUMN 152 1EA 152 23C DRAW_COLUMN ;

: MAZE_C 1A4 A2 1A4 F4 DRAW_COLUMN 1A4 146 1A4 23C DRAW_COLUMN ;

: MAZE_D 1F6 50 1F6 A3 DRAW_COLUMN 1F6 F4 1F6 1EA DRAW_COLUMN ;

: MAZE_E 248 A2 248 147 DRAW_COLUMN 248 198 248 23C DRAW_COLUMN ;

: MAZE_F 29A 50 29A A3 DRAW_COLUMN 29A F4 29A 1EA DRAW_COLUMN ;

: MAZE_G 1A4 A2 1F6 A2 DRAW_ROW 248 A2 29A A2 DRAW_ROW ;

: MAZE_H 152 146 1A4 146 DRAW_ROW 1F6 146 248 146 DRAW_ROW 29A 1EA 2EC 1EA DRAW_ROW ;


\ Definiamo una parola che disegni l'intero labirinto 
: MAZE WHITE COLOR ! MAZE_A MAZE_B MAZE_C MAZE_D MAZE_E MAZE_F MAZE_G MAZE_H  BORDER_ROW BORDER_COLUMN ;


\ Definiamo un riquadro esterno al labirinto in cui fare comparire informazioni aggiuntive
\ ( n_col_start n_row n_col_end n_row  n_row_end -- )

: BLOCK 
	\ Utilizziamo due variabili:
	\ INDEX_BLOCK contiene l'indice di fine ciclo
	INDEX_BLOCK !  
	BEGIN 
	   \ ( n_col_start n_row n_col_end n_row -- n_col_start n_row n_col_end n_row )
	   \ disegniamo il blocco riga per riga
	   2OVER 2OVER DRAW_ROW 
	   \ incrementiamo l'indice della riga e ripristiniamo l'ordine dei valori 
	   \ ( n_col_start n_row n_col_end n_row -- n_col_start n_row_new n_col_end n_row_new )
	   ROT 1 + SWAP 1 + ROT SWAP
	   \ verifichiamo se n_row_new è uguale a n_row_end
	   DUP INDEX_BLOCK @ = 
	\ se è verificato ripuliamo lo stack
	\ ( n_col_start n_row_new n_col_end n_row_new -- )
	UNTIL 
	   2DROP 2DROP ;

\ Inizializziamo lo schermo col colore di background
: DESKTOP BG_COLOR COLOR ! 0 0 400 0 300 BLOCK ; 

\ Creiamo il blocco dove scrivere informazioni aggiuntive durante il gioco
: RESET  YELLOW COLOR ! 30 12D 6D 12D 148 BLOCK ;

\ Creiamo il blocco dove inseriremo il nome del gioco
: LOGO_BG YELLOW COLOR ! 30 54 89 54 7B BLOCK ;


\ Definiamo diversi bordi attorno al logo

: FIRST_BORDER L_ORANGE COLOR ! 30 53 89 53 DRAW_ROW 30 7B 89 7B DRAW_ROW 2F 53 2F 7C DRAW_COLUMN 89 53 89 7C DRAW_COLUMN ;

: SECOND_BORDER M_ORANGE COLOR ! 2F 52 8A 52 DRAW_ROW 2F 7C 8A 7C DRAW_ROW 2E 52 2E 7D DRAW_COLUMN 8A 52 8A 7D DRAW_COLUMN ;

: THIRD_BORDER D_ORANGE COLOR ! 2E 51 8B 51 DRAW_ROW 2E 7D 8B 7D DRAW_ROW 2D 51 2D 7E DRAW_COLUMN 8B 51 8B 7E DRAW_COLUMN ;

: FOURTH_BORDER D_RED COLOR ! 2D 50 8C 50 DRAW_ROW 2D 7E 8C 7E DRAW_ROW 2C 50 2C 7F DRAW_COLUMN 8C 50 8C 7F DRAW_COLUMN ;

: FIFTH_BORDER RED COLOR ! 2C 4F 8D 4F DRAW_ROW 2C 7F 8D 7F DRAW_ROW 2B 4F 2B 80 DRAW_COLUMN 8D 4F 8D 80 DRAW_COLUMN ;

: SIXTH_BORDER L_RED COLOR ! 2B 4E 8E 4E DRAW_ROW 2B 80 8E 80 DRAW_ROW 2A 4E 2A 81 DRAW_COLUMN 8E 4E 8E 81 DRAW_COLUMN ;


\ Utilizzamo un'unica parola per il riquadro del logo
: LOGO LOGO_BG FIRST_BORDER SECOND_BORDER THIRD_BORDER FOURTH_BORDER FIFTH_BORDER SIXTH_BORDER ;








