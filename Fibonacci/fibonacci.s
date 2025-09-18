        ; Programa: Serie de Fibonacci en ARM Cortex-M3
        ; mcu: stm32f103c8
        ; calcula la serie hasta fn, con n entre 0 y 47
        ; resultados guardados en sram desde la dirección 0x20000000

        area    fibonacci_variables, data, readwrite
        align
n       dcd     9               ; número de términos (n = 9 en el ejemplo)
                                ; cambiar este valor para otro n
                                
dir_sram    equ     0x20000000  ; dirección inicial de sram para almacenar resultados

        area    l_fib, code, readonly
        entry
        export  __main

__main
        ;--- inicialización ---
        ldr     r0, =n          ; r0 = dirección de la variable n
        ldr     r1, [r0]        ; r1 = n (posición final: calcula f0 ... fn)
        ldr     r2, =dir_sram   ; r2 = puntero en ram donde se guardarán resultados

        cmp     r1, #0
        blt     _end            ; si n < 0, terminar
        cmp     r1, #47
        bgt     _end            ; si n > 47, terminar

        ; guardar f0 = 0
        mov     r3, #0          ; r3 = f0
        str     r3, [r2], #4    ; guarda en memoria y avanza puntero

        cmp     r1, #0
        beq     _end            ; si n == 0, termina

        ; guardar f1 = 1
        mov     r4, #1          ; r4 = f1
        str     r4, [r2], #4    ; guarda en memoria y avanza puntero

        cmp     r1, #1
        beq     _end            ; si n == 1, termina

        mov     r5, #2          ; r5 = índice actual (i = 2)

fib_loop
        cmp     r5, r1
        bgt     _end            ; si i > n, terminar

        add     r6, r3, r4      ; r6 = f(i) = f(i-2) + f(i-1)
        str     r6, [r2], #4    ; guardar en sram, avanzar puntero

        mov     r3, r4          ; f(i-2) = f(i-1)
        mov     r4, r6          ; f(i-1) = f(i)

        add     r5, r5, #1      ; i++
        b       fib_loop

_end
        b       _end            ; loop infinito (fin del programa)

        end