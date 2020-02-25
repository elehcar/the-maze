HEX

3E8FA000 CONSTANT FRAME_BUFFER
00000300 CONSTANT HEIGHT
00000400 CONSTANT WIDTH
0000004C CONSTANT BG_COLOR
FFFFFFFF CONSTANT WHITE
0000FF00 CONSTANT GREEN
00FFFF40 CONSTANT YELLOW
00FFAE00 CONSTANT L_ORANGE
00FFA500 CONSTANT M_ORANGE
00FF4500 CONSTANT D_ORANGE
00C34200 CONSTANT D_RED
00FF2400 CONSTANT RED
00FF0000 CONSTANT L_RED


VARIABLE INDEX_INIT
VARIABLE INDEX
VARIABLE COLOR

: ITER 2DUP ! 4 + ;
: ITER2 2DUP ! 4 WIDTH * + ;

\ ( trova l'indirizzo corrispondente a una riga e una colonna )
\ (n_colonna n_riga -- indirizzo)
: FIND_ADDRESS 4 WIDTH * * SWAP 4 * FRAME_BUFFER + + ;

: INIT FIND_ADDRESS INDEX_INIT ! FIND_ADDRESS BG_COLOR SWAP BEGIN ITER DUP INDEX_INIT @ = UNTIL 2DROP ;

: DESKTOP 0 0 400 300 INIT ;


\ ( n_col_start n_row_start n_col_end n_row_end -- )
: DRAW_ROW FIND_ADDRESS INDEX ! FIND_ADDRESS COLOR @ SWAP BEGIN ITER DUP INDEX @ = UNTIL 2DROP ;
: DRAW_COLUMN FIND_ADDRESS INDEX ! FIND_ADDRESS COLOR @ SWAP BEGIN ITER2 DUP INDEX @ = UNTIL 2DROP ;

\ aggiungere muro all'esterno del labirinto

: BORDER_ROW 100 4F 2ED 4F DRAW_ROW 100 4E 2ED 4E DRAW_ROW 100 23D 2ED 23D DRAW_ROW 100 23E 2ED 23E DRAW_ROW ;

: BORDER_COLUMN FE 4E FE 23F DRAW_COLUMN FF 4E FF 12D DRAW_COLUMN FF 14B FF 23F DRAW_COLUMN
2EE 4E 2EE 23F DRAW_COLUMN 2ED 4E 2ED 12D DRAW_COLUMN 2ED 14B 2ED 23F DRAW_COLUMN ;

: MAZE_A 100 50 2EC 50 DRAW_ROW 100 23C 2EC 23C DRAW_ROW 100 50 100 12D DRAW_COLUMN 100 14B 100 23C DRAW_COLUMN 2EC 50 2EC 12D DRAW_COLUMN 2EC 14B 2EC 23C DRAW_COLUMN ;

: MAZE_B 152 50 152 F4 DRAW_COLUMN 152 146 152 198 DRAW_COLUMN 152 1EA 152 23C DRAW_COLUMN ;

: MAZE_C 1A4 A2 1A4 F4 DRAW_COLUMN 1A4 146 1A4 23C DRAW_COLUMN ;

: MAZE_D 1F6 50 1F6 A2 DRAW_COLUMN 1F6 F4 1F6 1EA DRAW_COLUMN ;

: MAZE_E 248 A2 248 146 DRAW_COLUMN 248 198 248 23C DRAW_COLUMN ;

: MAZE_F 29A 50 29A A2 DRAW_COLUMN 29A F4 29A 1EA DRAW_COLUMN ;

: MAZE_G 1A4 A2 1F6 A2 DRAW_ROW 248 A2 29A A2 DRAW_ROW ;

: MAZE_H 152 146 1A4 146 DRAW_ROW 1F6 146 248 146 DRAW_ROW 29A 1EA 2EC 1EA DRAW_ROW ;

: MAZE WHITE COLOR ! MAZE_A MAZE_B MAZE_C MAZE_D MAZE_E MAZE_F MAZE_G MAZE_H  BORDER_ROW BORDER_COLUMN ;


: RESET YELLOW COLOR ! 30 12D 6D 12D BEGIN 2OVER 2OVER DRAW_ROW ROT 1 + SWAP 1 + ROT SWAP DUP 148 = UNTIL 2DROP 2DROP ;

: LOGO_BG YELLOW COLOR ! 30 54 89 54 BEGIN 2OVER 2OVER DRAW_ROW ROT 1 + SWAP 1 + ROT SWAP DUP 7B = UNTIL 2DROP 2DROP ;

: FIRST_BORDER L_ORANGE COLOR ! 30 53 89 53 DRAW_ROW 30 7B 89 7B DRAW_ROW 2F 53 2F 7C DRAW_COLUMN 89 53 89 7C DRAW_COLUMN ;
: SECOND_BORDER M_ORANGE COLOR ! 2F 52 8A 52 DRAW_ROW 2F 7C 8A 7C DRAW_ROW 2E 52 2E 7D DRAW_COLUMN 8A 52 8A 7D DRAW_COLUMN ;
: THIRD_BORDER D_ORANGE COLOR ! 2E 51 8B 51 DRAW_ROW 2E 7D 8B 7D DRAW_ROW 2D 51 2D 7E DRAW_COLUMN 8B 51 8B 7E DRAW_COLUMN ;
: FOURTH_BORDER D_RED COLOR ! 2D 50 8C 50 DRAW_ROW 2D 7E 8C 7E DRAW_ROW 2C 50 2C 7F DRAW_COLUMN 8C 50 8C 7F DRAW_COLUMN ;
: FIFTH_BORDER RED COLOR ! 2C 4F 8D 4F DRAW_ROW 2C 7F 8D 7F DRAW_ROW 2B 4F 2B 80 DRAW_COLUMN 8D 4F 8D 80 DRAW_COLUMN ;
: SIXTH_BORDER L_RED COLOR ! 2B 4E 8E 4E DRAW_ROW 2B 80 8E 80 DRAW_ROW 2A 4E 2A 81 DRAW_COLUMN 8E 4E 8E 81 DRAW_COLUMN ;
: LOGO LOGO_BG FIRST_BORDER SECOND_BORDER THIRD_BORDER FOURTH_BORDER FIFTH_BORDER SIXTH_BORDER ;










