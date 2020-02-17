
3F20001C CONSTANT GPSET0
3F200028 CONSTANT GPCLR0
3F200034 CONSTANT GPLEV0

\ GPIO 18 collegato al led
12 CONSTANT LED_GPIO
17 CONSTANT BUTTON_GPIO

\ ( led_gpio -- gpio_mask)
: GPIO_MASK 1 SWAP LSHIFT ;

\ ( led_gpio -- )
: ON GPIO_MASK GPSET0 ! ;
: OFF GPIO_MASK GPCLR0 ! ;

\ ( microseconds -- )
: DELAY   BEGIN 1 - DUP 0 = UNTIL DROP ;

: ACTIVATE GPIO_MASK GPLEV0 @ AND 0 <> IF ON ELSE OFF THEN ;
\ ( cycles -- )
: LED_ITER >R LED_GPIO BUTTON_GPIO BEGIN 2DUP ACTIVATE 10000 DELAY R> 1 - DUP . CR DUP >R 0 = UNTIL RDROP DROP OFF ;
