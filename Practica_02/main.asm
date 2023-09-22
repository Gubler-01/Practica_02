.ORG 0x00

rjmp INICIO          ; Salto a la etiqueta "INICIO", 2 ciclos del reloj (Contador de programa)

INICIO:

ldi    r16,low(RAMEND)    ; El valor de la parte baja de RAMEND lo guarda en R16, consume 1 ciclo de reloj 
out    SPL, r16      ; Coloca el valor de R16 en la pila baja, consumiendo 1 ciclo de reloj 
ldi    r16,high(RAMEND)  ; El valor de la parte alta de RAMEND lo guarda en R16, consume 1 ciclo de reloj 
out    SPH, r16      ; Coloca el valor R16 en la pila alta, consumiendo 1 ciclo de reloj 

ldi    r16, 0xFF      ; Guarda el valor 255 en R16 (en binario 0b11111111, en hexa 0xFF)
out    DDRB, r16      ; Configura TODO el puerto B como salida (1's son salidas y 0's son entradas)
out    DDRD, r16      ; Configura TODO el puerto D como salida (1's son salidas y 0's son entradas)

ldi r17, 0			; unidades
ldi r18, 0			; decenas
ldi r21, 0			; revisa si ya acabó el turno de las unidades
ldi r22, 0			; r22 es un contador para que muestre 100 veces los números antes de cambiar al siguiente

ciclo:
ldi r19, 15
cpse r22,r19
rjmp pinBajo
rjmp pinAlto

pinBajo:			; va a hacer el ciclo para mostrar los números en los decodificadores BCD de 7 segmentos	
					; r20 va compartir por turnos los valores de las unidades y de las decenas
mov r20, r17			; comparar primero con las unidades
ldi r21, 0
sbi PORTB, 0		; apagar el BCD de las decenas
cbi PORTB, 1		; prender el BCD de las unidades
rjmp nextBCD

nextBCD:
ldi r19, 0
cpse r20, r19
rjmp uno
rjmp cero

cero:
cbi PORTD, 0
sbi PORTD, 1
sbi PORTD, 2
sbi PORTD, 3
sbi PORTD, 4
sbi PORTD, 5
sbi PORTD, 6
rjmp condicion

uno:
ldi r19, 1
cpse r20, r19
rjmp dos
cbi PORTD, 0
cbi PORTD, 1
cbi PORTD, 2
sbi PORTD, 3
cbi PORTD, 4
cbi PORTD, 5
sbi PORTD, 6
rjmp condicion

dos:
ldi r19, 2
cpse r20, r19
rjmp tres
sbi PORTD, 0
cbi PORTD, 1
sbi PORTD, 2
sbi PORTD, 3
sbi PORTD, 4
sbi PORTD, 5
cbi PORTD, 6
rjmp condicion

tres:
ldi r19, 3
cpse r20, r19
rjmp cuatro
sbi PORTD, 0
cbi PORTD, 1
sbi PORTD, 2
sbi PORTD, 3
cbi PORTD, 4
sbi PORTD, 5
sbi PORTD, 6
rjmp condicion

cuatro:
ldi r19, 4
cpse r20, r19
rjmp cinco
sbi PORTD, 0
sbi PORTD, 1
cbi PORTD, 2
sbi PORTD, 3
cbi PORTD, 4
cbi PORTD, 5
sbi PORTD, 6
rjmp condicion

cinco:
ldi r19, 5
cpse r20, r19
rjmp seis
sbi PORTD, 0
sbi PORTD, 1
sbi PORTD, 2
cbi PORTD, 3
cbi PORTD, 4
sbi PORTD, 5
sbi PORTD, 6
rjmp condicion

seis:
ldi r19, 6
cpse r20, r19
rjmp siete
sbi PORTD, 0
sbi PORTD, 1
sbi PORTD, 2
cbi PORTD, 3
sbi PORTD, 4
sbi PORTD, 5
sbi PORTD, 6
rjmp condicion

siete: 
ldi r19, 7
cpse r20, r19
rjmp ocho
cbi PORTD, 0
cbi PORTD, 1
sbi PORTD, 2
sbi PORTD, 3
cbi PORTD, 4
cbi PORTD, 5
sbi PORTD, 6
rjmp condicion

ocho:
ldi r19, 8
cpse r20, r19
rjmp nueve
sbi PORTD, 0
sbi PORTD, 1
sbi PORTD, 2
sbi PORTD, 3
sbi PORTD, 4
sbi PORTD, 5
sbi PORTD, 6
rjmp condicion

nueve:
sbi PORTD, 0
sbi PORTD, 1
sbi PORTD, 2
sbi PORTD, 3
cbi PORTD, 4
sbi PORTD, 5
sbi PORTD, 6
rjmp condicion

condicion:
rcall Retraso05
inc r22
ldi r19, 0
cpse r21, r19		; No ha pasado las decenas
rjmp ciclo
inc r21
mov r20, r18
sbi PORTB, 1	; apagar el BCD de las unidades
cbi PORTB, 0		; prender el BCD de las decenas
inc r22
rjmp nextBCD

pinAlto:
ldi r22, 0			; reiniciamos el contador
inc r17

ldi r19, 10			; para comparar si son igual a diez
cpse r17, r19
rjmp ciclo			; si no hay cambio en las decenas se regresa

ldi r17, 0			; si las unidades tienen el valor de 10, cambiarlo a 0 y sumarle a las decenas
inc r18
cpse r18, r19		; las decenas tienen valor de 10?
rjmp ciclo			; si las decenas no tienen valor de 10

ldi r18, 0			; cambiarlo
rjmp ciclo

rjmp ciclo           ; Salta de nuevo al inicio del ciclo

Retraso05:

ldi R16,1        ;veces que se repetirá el ciclo para hacer 4 millones de instrucciones (la mitad del tiempo)
exter_Reta:
ldi R24,LOW(1596)   ;pone el valor de 63 en binario y pone la parte baja (00111111, valor del segundo octeto)
ldi R25,HIGH(1596)  ;pone el valor de 63 en binario y pone la parte alta (00001111, valor del primer octeto)

retar_ciclo:
adiw R24,1          ;sumar un 1 al registro 24 que es la parte baja (R24: parte baja, R25: parte alta), 2 ciclos de reloj, altera banderas Z,C,N,V,S

brne retar_ciclo    ;puede consumir 1/2 ciclos; sc
                    ;al llegar a 65536 R24 y R25 se vuelve cero y Z=0, pasa a la siguiente linea

dec R16             ;Restar 1 a R16, hay sobreflujo (bandera V) al llegar a 128 ya que el bit de signo y para representar 128 se juntan

brne exter_Reta     ;si Z=0 entonces consume 1 ciclo y pasa a la siguiente linea de código, de lo contrario consume 2 ciclos y se va a la etiqueta "exter_Reta"
ret                 ;retorna a la llamada de la etiqueta (rcall usa ret para regresar desde donde se llamó)

rjmp ciclo