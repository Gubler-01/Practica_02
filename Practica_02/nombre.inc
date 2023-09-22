.include "m328pdef.inc"
.def dig1 = r22
.def dig2 = r23

CHKCF:
brcc l1
sbi PORTB, 2
rcall delay
l1:
ret

CHKZF:
brne l2
sbi PORTD, 3
rcall delay
l2:
ret

DISPLAY:
rcall DISPLAY1
rcall DISPLAY2
rcall DELAY
ret

DISPLAY1:
ldi dig1, 0x0F
ldi YL, LOW(2*seg1)
ldi YH, HIGH(2*seg1)
mov Z, Y

and dig1, res 
add ZL, dig1
lpm dig1, Z

out PORTB, dig1
andi dig1, 0x40
out PORTD, dig1
ret

DISPLAY2:
ldi dig2, 0xF0
ldi ZL, LOW(2*seg2)
ldi ZH, HIGH(2*seg2)

and dig2, res
swap dig2
add ZL,dig2 
lpm dig2, Z

out PORTC, dig2
or dig2, dig1
andi dig2, 0xC0
out PORTD, dig2
ret

DELAY:
subi r18, 1
sbic r19, 0
sbci r20, 0
brcc DELAY
ret

SETPORT: //obtienen salidas o entradas de los puertos B, C y D
ldi r25, 0x3F	//DDRB
out DDRB, r25
ldi r25, 0x3F	//DDRC
out DDRC, r25
ldi r25, 0xCC	//DDRD
out DDRD, r25
ret