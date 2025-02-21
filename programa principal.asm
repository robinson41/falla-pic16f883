;*******************************************************************************
 LIST	P=16F883
#include "p16f883.inc"
; CONFIG1
; __config 0x28CC
 __CONFIG _CONFIG1, _FOSC_INTRC_NOCLKOUT & _WDTE_OFF & _PWRTE_ON & _MCLRE_OFF & _CP_OFF & _CPD_OFF & _BOREN_OFF & _IESO_OFF & _FCMEN_ON & _LVP_OFF
; CONFIG2
; __config 0x3FFF
 __CONFIG _CONFIG2, _BOR4V_BOR40V & _WRT_OFF
;*******************************************************************************
 #DEFINE	CLK	PORTC,7;
 #DEFINE	DATO	PORTC,6;
 #DEFINE	LED	PORTC,5;
;*******************************************************************************
 CBLOCK  0X20	;INICIO LA CREACION DE REGISTROS DESDE LA POSICION DE MEMORIA
CONT		    ;0X20
CONT1		    ;
CONT2		    ;
CONT3		    ;
CONT4		    ;
CONT5		    ;
CONT6		    ;
CONT7		    ;
CONT8		    ;
CONT9		    ;
CONT10		    ;
UNIDADES	    ;
DECENAS		    ;
CENTENAS	    ;
MIL		    ;
DECEMIL		    ;
COMANDO		    ;
NBIT		    ;
DISPLAY1	    ;
DISPLAY2	    ;
DISPLAY3	    ;
DISPLAY4	    ;
REGISTRO1	    ;
REGISTRO2	    ;
DATO2		    ;
VUNI		    ;
VDEC		    ;
VCENT		    ;
 ENDC		    ;cierra la creacion de registros
;*******************************************************************************
; Reset Vector
;*******************************************************************************
 ORG     0x00       ; processor reset vector
 GOTO    START      ; go to beginning of program
 ORG	 0X04	    ;
 RETFIE		    ;
;*******************************************************************************
; MAIN PROGRAM
;*******************************************************************************
START		    ;
 BANKSEL  PORTA	    ;
 CLRF	  PORTA	    ;
 BANKSEL  ANSEL	    ;
 CLRF	  ANSEL	    ;
 BANKSEL  PORTB	    ;
 CLRF	  PORTB	    ;
 CLRF	  PORTC	    ;
 CLRF	  PORTE	    ;
 BANKSEL  TRISA	    ;
 MOVLW	  0XF0	    ;
 MOVWF	  TRISA	    ;
 ;CLRF	  TRISA	    ;
 CLRF	  TRISB	    ;
 CLRF	  TRISC	    ;
 BANKSEL  TRISE	    ;
 MOVLW	  B'00000100';
 MOVWF	  TRISE	    ;	
 BANKSEL  PORTA	    ;
 CLRF	  PORTA	    ;
 CLRF	  PORTB	    ;
 CLRF	  PORTC	    ;
 CLRF	  PORTE	    ;
;***********RUTINA DE ARRANQUE PARA VERIFICACION VIZUAL DE REINICIO*************
INICIO		    ;
 BSF	 LED	    ;
 CALL    RETARDO2   ;
 BCF	 LED	    ;
 CALL	 RETARDO2   ;
 BSF	 LED	    ;
 CALL    RETARDO2   ;
 BCF	 LED	    ;
 CALL	 RETARDO2   ;
 BSF	 LED	    ;
 CALL    RETARDO2   ;
 BCF	 LED	    ;
 CALL	 RETARDO2   ;
;***************************PROGRAMA PRINCIPAL**********************************
LOOP		    ;
 MOVLW	 D'5'	    ;
 MOVWF	 REGISTRO1  ;
 CALL	 CONVERTIR  ;
 CALL	 ACT_DISPLAY;
 CALL	 ACT_TM1637 ;
 CALL	 RETARDO    ;
 CLRF	 DISPLAY1   ;
 CLRF	 DISPLAY2   ;
 CLRF	 DISPLAY3   ;
 CLRF	 DISPLAY4   ;
 CALL	 ACT_TM1637 ;
 CALL	 RETARDO    ;
 GOTO	 LOOP	    ;
;*******************************************************************************
;*******************codigo adicional para comprobar falla***********************
;******************************************************************************* 
FALLA		;
 BSF	 LED	;
 BSF	 LED	;
 BSF	 LED	;
 BSF	 LED	;
 BSF	 LED	;
 BSF	 LED	;
 BSF	 LED	;
 BSF	 LED	;
 BSF	 LED	;
 BSF	 LED	;
 BSF	 LED	;
 BSF	 LED	;
 BSF	 LED	;
 BSF	 LED	;
 BSF	 LED	;
 BSF	 LED	;
 BSF	 LED	;
 BSF	 LED	;
 BSF	 LED	;
 BSF	 LED	;
 BSF	 LED	;
 BSF	 LED	;
 BSF	 LED	;
 BSF	 LED	;
 BSF	 LED	;
 BSF	 LED	;hasta este punto el programa funciona en apariencia
 ;BSF	 LED	;desde esta linea en adelante inicia la falla y cualquier linea
;de codigo adicional hace que el problema sea mayor, si la linea esta 
;comentariadael programa se reestablece, esto se da en el montaje fisico
;sin embargo puede variar en la simulacion
;*******************************************************************************
;******************************CONVERSOR BCD************************************
;*******************************************************************************
;BORRA TODOS LOS REGISTROS UTILIZADOS EN EL PROCESO DE CONVERSION PARA EVITAR
;FALLOS POR RESIDUALES EN LOS REGISTROS
CONVERTIR	    ;
 CLRF	 UNIDADES   ;BORRA REGISTRO UNIDADES
 CLRF	 DECENAS    ;BORRA REGISTRO DECENAS
 CLRF	 CENTENAS   ;BORRA REGISTRO CENTENAS
 CLRF	 MIL	    ;BORRA REGISTRO MIL
 CLRF	 DECEMIL    ;BORRA REGISTRO DECENAS DE MIL
 CLRF	 VUNI	    ;BORRA REGISTRO DECENAS DE MIL    
 CLRF	 VDEC	    ;BORRA REGISTRO DECENAS DE MIL
 CLRF	 VCENT	    ;BORRA REGISTRO DECENAS DE MIL
 CLRF	 DATO2	    ;
 ;MOVF	 REGISTRO2,W;
 ;MOVWF	 DATO2	    ;
 ;CALL	 BCD2	    ;
 CALL	 BCD1	    ;
 ;CALL	 AJUSTE	    ;
 RETURN		    ;
;*******************************************************************************
;**********************CONVERSION DEL REGISTRO1*********************************
;*******************************************************************************
BCD1		    ;
 MOVF	 REGISTRO1,W;
 SUBLW	 D'0'	    ;
 BTFSC	 STATUS,Z   ;	
 ;GOTO	FIN_BCD1
 RETURN		    ;
 DECF	 REGISTRO1,F;
 INCF	 UNIDADES,F ;
 MOVF	 UNIDADES,W ;
 SUBLW	 D'10'	    ;
 BTFSS	 STATUS,Z   ;
 GOTO	 BCD1	    ;
 CLRF	 UNIDADES   ;
 INCF	 DECENAS,F  ;
 MOVF	 DECENAS,W  ;
 SUBLW	 D'10'	    ;
 BTFSS	 STATUS,Z   ;
 GOTO	 BCD1	    ;
 CLRF	 DECENAS    ;
 INCF	 CENTENAS,F ;
 GOTO	 BCD1	    ;
;FIN_BCD1	    ;
 ;RETURN		    ;
;*******************************************************************************
;******************ACTUALIZAR REGISTROS DE VISUALIZACION************************
;*******************************************************************************
ACT_DISPLAY	    ;actualiza los valores de los registros correspondientes
 CLRF	 DISPLAY1   ;a cada display, primero se hace un borrado de cada uno de 
 CLRF	 DISPLAY2   ;ellos para evitar datos residuales, y despues de esto se
 CLRF	 DISPLAY3   ;cargan los nuevos valores actualizados en cada registro,
 CLRF	 DISPLAY4   ;estos valores se extraen de los registros UNIDADES, DECENAS
 MOVF	 UNIDADES,W ;CENTENAS, donde unidades corresponde al display 4
 MOVWF	 DISPLAY4   ;decenas al display 3 y asi segun coresponda esto teniendo
 MOVF	 DECENAS,W  ;en cuenta la distribucion del TM1637
 MOVWF	 DISPLAY3   ;
 MOVF	 CENTENAS,W ;
 MOVWF	 DISPLAY2   ;
 MOVLW	 D'22'	    ;
 MOVWF	 DISPLAY1   ;
 RETURN		    ;
;*******************************************************************************
;********Rutinas de muestreo en display controlado por TM1637*******************
;La siguiente rutina emula el muestreo de señal generado por la libreria TM1637
;corriendo en un arduino uno, de donde se tomo el muestreo de la señal
;*******************************************************************************
ACT_TM1637	    ;
 CLRF	 COMANDO    ;
 BSF	 CLK	    ;Pone en alto el pin CLK
 BSF	 DATO	    ;Pone en alto el pin de DATOS
 MOVLW	 0X40	    ;configuraciones para escritura en TM1637,ver hoja de datos
 MOVWF	 COMANDO    ;mueve el valor al registro comando para posterior envio
 CALL	 ARRANQUE   ;llama subrutina para inicio de transmicion
 CALL	 ESCRIBIR   ;llama subrutina de transmicion de datos
 CALL	 ACK	    ;tiempo de espera para confirmacion de entrega de datos
 CALL	 PARADA	    ;fin del envio del comando
 MOVLW	 0XC0	    ;configuraciones para escritura en TM1637,ver hoja de datos
 MOVWF	 COMANDO    ;
 CALL	 ARRANQUE   ;
 CALL	 ESCRIBIR   ;
 CALL	 ACK	    ;
 MOVF	 DISPLAY1,W ;mueve el valor presente en el registro y lo carga en W
 CALL	 FUENTE	    ;llama tabla con valores de los segmentos correspondientes
 MOVWF	 COMANDO    ;a la suma de w y la pila para enviar el dato al display 1
 CALL	 ESPACIO    ;
 CALL	 ESCRIBIR   ;subrutina de escritura del dato correspondiente
 CALL	 ACK	    ;
 MOVF	 DISPLAY2,W ;
 CALL	 FUENTE	    ;
 MOVWF	 COMANDO    ;
 CALL	 ESPACIO    ;
 CALL	 ESCRIBIR   ;
 CALL	 ACK	    ;
 MOVF	 DISPLAY3,W ;
 CALL	 FUENTE	    ;
 MOVWF	 COMANDO    ;
 CALL	 ESPACIO    ;
 CALL	 ESCRIBIR   ;
 CALL	 ACK	    ;
 MOVF	 DISPLAY4,W ;
 CALL	 FUENTE	    ;
 MOVWF	 COMANDO    ;
 CALL	 MICRO_108  ;
 CALL	 ESCRIBIR   ;
 CALL	 ACK	    ;
 CALL	 PARADA	    ;
 MOVLW	 0X8D	    ;
 MOVWF	 COMANDO    ;
 CALL	 ARRANQUE   ;
 CALL	 ESCRIBIR   ;
 CALL	 ACK	    ;
 CALL	 ENVIO_FIN  ;llama rutina para finalizar el envio de datos al TM1637
 RETURN		    ;retorna al lugar desde donde ocurrio el llamado
ESCRIBIR	    ;subrutina de definicion de datos a escribir
 CLRF	 NBIT	    ; borra el registro con el valor de la cantidad de bits a 
 MOVLW	 D'8'	    ;enviar, luego se carga 8 como el numero de bits que se 
 MOVWF	 NBIT	    ;escribiran en cada envio
 CALL	 TEXTOS	    ;llama subrutina de escritura
 BCF	 CLK	    ;pone en bajo el CLK antes de retornar al lugar donde fue 
 RETURN		    ;llamado
TEXTOS		    ;subrutina de escritura 
 MOVF	 NBIT,W	    ;Se mueve el valor de registro NBIT a W y se le resta cero
 SUBLW	 D'0'	    ;para de esta forma saber si el envio de los bits definidos
 BTFSC	 STATUS,Z   ;ya a terminado o si se debe continuar enviando, esto se
 RETURN		    ;refleja en el estatus de Z, si el resultado es igual a cero
 DECF	 NBIT	    ;el envio finalizo caso contrario se prosigue con el envio
 RRF	 COMANDO    ;rota los bits del registro derecha, una vez se haga esto
 BTFSS	 STATUS,C   ;se verifica el valor del bit que roto en C, dependiendo
 GOTO	 CERO	    ;el valor de este bit se dirige a la rutina que coresponda
 GOTO	 UNO	    ;para activar el pin DATO durante el tiempo que aplique
CERO		    ;rutina para bit cero
 BCF	 CLK	    ;tanto para el envio de un cero como de un uno por el pin
 CALL	 MICRO_123  ;asignado al DATO se deben cumplir tiempos predeterminados
 BCF	 DATO	    ;con el pin el alto o bajo segun corresponda, a la vez que
 CALL	 MICRO_123  ;pulso de reloj en el CLK se mantiene bajo el mismo 
 BSF	 CLK	    ;sincronismo, al ser esto una copia de la captura que se 
 CALL	 MICRO_66   ;hizo de a biblioteca TM1637.H la forma en que se replico
 GOTO	 TEXTOS	    ;la señal fue usando diversas subrutinas de tiempo,
UNO		    ;con las cuales se emulan los tiempos en que los pines deben
 BCF	 CLK	    ;permanecer en alto o en bajo
 CALL	 MICRO_123  ;
 BSF	 DATO	    ;
 CALL	 MICRO_123  ;
 BSF	 CLK	    ;
 CALL	 MICRO_66   ;
 GOTO	 TEXTOS     ;
ARRANQUE	    ;
 BSF	 CLK	    ;
 BSF	 DATO	    ;
 CALL	 MICRO_81   ;
 BCF	 DATO	    ;
 CALL	 MICRO_108  ;
 BCF	 CLK	    ;
 RETURN		    ;
PARADA		    ;
 BCF	 CLK	    ;
 BCF	 DATO	    ;
 CALL	 MICRO_252  ;
 BSF	 CLK	    ;
 CALL	 MICRO_81   ;
 RETURN		    ;
ACK		    ;
 BCF	 CLK	    ;
 BCF	 DATO	    ;
 CALL	 MICRO_144  ;
 BSF	 CLK	    ;
 CALL	 MICRO_174  ;
 RETURN		    ;
ENVIO_FIN	    ;
 CLRF	 COMANDO    ;
 BCF	 CLK	    ;
 BCF	 DATO	    ;
 CALL	 MICRO_252  ;
 BSF	 CLK	    ;
 CALL	 MICRO_81   ;
 BSF	 DATO	    ;
 RETURN		    ;
ESPACIO		    ;
 BCF	 DATO	    ;
 BCF	 CLK	    ;
 CALL	 MICRO_108  ;	
 RETURN		    ;
;*******************************************************************************
;**************TABLA CON VALORES CORRESPONDIENTES A LOS DISPLAY*****************
;*******************************************************************************
FUENTE
 ADDWF  PCL,1		    ;SUME W AL CONTADOR DE PROGRAMA
 RETLW  B'00111111'	    ;0 POSICION 0
 RETLW  B'00000110'	    ;1 POSICION 1
 RETLW  B'01011011'	    ;2 POSICION 2
 RETLW  B'01001111'	    ;3 POSICION 3
 RETLW  B'01100110'	    ;4 POSICION 4
 RETLW  B'01101101'	    ;5 POSICION 5
 RETLW  B'01111101'	    ;6 POSICION 6
 RETLW  B'00000111'	    ;7 POSICION 7
 RETLW  B'01111111'	    ;8 POSICION 8
 RETLW  B'01100111'	    ;9 POSICION 9
 RETLW  B'10111111'	    ;0. POSICION 10
 RETLW  B'10000110'	    ;1. POSICION 11
 RETLW  B'11011011'	    ;2. POSICION 12
 RETLW  B'11001111'	    ;3. POSICION 13
 RETLW	B'11100110'	    ;4. POSICION 14
 RETLW  B'11101101'	    ;5. POSICION 15
 RETLW  B'11111101'	    ;6. POSICION 16
 RETLW  B'10000111'	    ;7. POSICION 17
 RETLW  B'11111111'	    ;8. POSICION 18
 RETLW  B'11100111'	    ;9. POSICION 19
 RETLW  B'01110110'	    ;H POSICION 20
 RETLW  B'01110100'	    ;h POSICION 21
 RETLW  B'01110011'	    ;P POSICION 22
 RETLW  B'01000000'	    ;- POSICION 23
 RETLW  B'00000000'	    ;NULL POSICION 24
 RETLW  B'00111001'	    ;C POSICION 25
 RETLW  B'00111000'	    ;L POSICION 26
 RETLW  B'01110111'	    ;A POSICION 27
 RETURN
;*******************************************************************************
;********************************RUTINA DE TIEMPO*******************************
;*******************************************************************************
;**************************RUTINAS DE TIEMPO TM1637*****************************
MICRO_123	    ;
 CLRF	CONT2	    ;
 MOVLW  D'39'	    ;39 MIN 3 A	 4MHZ
 MOVWF	CONT2	    ;CARGA EL LITERAL EN EL REGISTRO CONT2
 DECFSZ	CONT2	    ;DESCUENTA 1 AL REGISTRO SI ES CERO SALTA 1 INSTRUCCION
 GOTO	$-1	    ;CONTINUA DESCONTANDO EL REGISTRO EN 1
 RETURN		    ;
;*******************************************************************************
MICRO_66	    ;
 CLRF	CONT3	    ;
 MOVLW	D'16'	    ;16  MIN 1 A 4MHZ
 MOVWF	CONT3	    ;CARGA EL LITERAL EN EL REGISTRO CONT3
 DECFSZ	CONT3	    ;DESCUENTA 1 AL REGISTRO SI ES CERO SALTA 1 INSTRUCCION
 GOTO	$-1	    ;CONTINUA DESCONTANDO EL REGISTRO EN 1
 RETURN		    ;
;*******************************************************************************
MICRO_174	    ;
 CLRF	CONT4	    ;
 MOVLW	D'56'	    ;56 MIN 4A 4 MHZ
 MOVWF	CONT4	    ;CARGA EL LITERAL EN EL REGISTRO CONT4
 DECFSZ	CONT4	    ;DESCUENTA 1 AL REGISTRO SI ES CERO SALTA 1 INSTRUCCION
 GOTO	$-1	    ;CONTINUA DESCONTANDO EL REGISTRO EN 1
 RETURN		    ;
;*******************************************************************************
MICRO_144	    ;
 CLRF	CONT5	    ;
 MOVLW	D'43'	    ;43 MIN 5 A 4 MHZ
 MOVWF	CONT5	    ;CARGA EL LITERAL EN EL REGISTRO CONT5
 DECFSZ	CONT5	    ;DESCUENTA 1 AL REGISTRO SI ES CERO SALTA 1 INSTRUCCION
 GOTO	$-1	    ;CONTINUA DESCONTANDO EL REGISTRO EN 1
 RETURN		    ;
;*******************************************************************************
MICRO_252	    ;
 CLRF	CONT6	    ;
 MOVLW	D'82'	    ;82 A MIN 10 A4 MHZ
 MOVWF	CONT6	    ;CARGA EL LITERAL EN EL REGISTRO CONT6
 DECFSZ	CONT6	    ;DESCUENTA 1 AL REGISTRO SI ES CERO SALTA 1 INSTRUCCION
 GOTO	$-1	    ;CONTINUA DESCONTANDO EL REGISTRO EN 1
 RETURN		    ;
;*******************************************************************************
MICRO_108	    ;
 CLRF	CONT6	    ;
 MOVLW	D'34'	    ;34 MIN 4 A 4 MHZ
 MOVWF	CONT6	    ;CARGA EL LITERAL EN EL REGISTRO CONT6
 DECFSZ	CONT6	    ;DESCUENTA 1 AL REGISTRO SI ES CERO SALTA 1 INSTRUCCION
 GOTO	$-1	    ;CONTINUA DESCONTANDO EL REGISTRO EN 1
 RETURN		    ;
;*******************************************************************************
MICRO_81	    ;
 CLRF	CONT6	    ;
 MOVLW	D'25'	    ;25 MIN 3 A 4 MHZ
 MOVWF	CONT6	    ;CARGA EL LITERAL EN EL REGISTRO CONT6
 DECFSZ	CONT6	    ;DESCUENTA 1 AL REGISTRO SI ES CERO SALTA 1 INSTRUCCION
 GOTO	$-1	    ;CONTINUA DESCONTANDO EL REGISTRO EN 1
 RETURN		    ;
;*******************************************************************************
MICRO_358	    ;
 CLRF	CONT4	    ;
 MOVLW	D'110'	    ;110- MIN 14 A 4 MHZ
 MOVWF	CONT4	    ;CARGA EL LITERAL EN EL REGISTRO CONT4
 DECFSZ	CONT4	    ;DESCUENTA 1 AL REGISTRO SI ES CERO SALTA 1 INSTRUCCION
 GOTO	$-1	    ;CONTINUA DESCONTANDO EL REGISTRO EN 1
 RETURN		    ;
;******************************************************************************* 
;************************TEMPORIZADORES DE PROPOSITO GENERAL********************
;*******************************************************************************
RETARDO		    ;
 MOVLW	D'6'	    ;6 PARA 1 SEGUNDO
 MOVWF	CONT5	    ;CARGA EL LITERAL EN EL REGISTRO CONT2
 MOVLW	D'217'	    ;MUEVE EL LITERAL AL REGISTRO DE TRABAJO 10
 MOVWF	CONT4	    ;CARGA EL LITERAL EN EL REGISTRO CONT1
 MOVLW	D'255'	    ;MUEVE EL LITERAL AL REGISTRO DE TRABAJO
 MOVWF	CONT3	    ;CARGA EL LITERAL EN EL REGISTRO CONT
 DECFSZ	CONT3	    ;DESCUENTA 1 AL REGISTRO SI ES CERO SALTA 1 INSTRUCCION
 GOTO	$-1	    ;CONTINUA DESCONTANDO EL REGISTRO EN 1
 DECFSZ	CONT4	    ;DESCUENTA 1 AL REGISTRO SI ES CERO SALTA 1 INSTRUCCION
 GOTO	$-5	    ;REGRESA A CARGAR EL REGISTRO CONT 
 DECFSZ	CONT5	    ;DESCUENTA 1 AL REGISTRO SI ES CERO SALTA 1 INSTRUCCION
 GOTO	$-9	    ;REGRESA A CARGAR DE NUEVO LOS REGISTROS CONT Y CONT1
 RETURN		    ;RETORNA DONDE FUE LLAMADO
;*******************************************************************************
RETARDO2	    ;
 MOVLW	D'2'	    ;6 PARA 1 SEGUNDO
 MOVWF	CONT5	    ;CARGA EL LITERAL EN EL REGISTRO CONT2
 MOVLW	D'100'	    ;MUEVE EL LITERAL AL REGISTRO DE TRABAJO 10
 MOVWF	CONT4	    ;CARGA EL LITERAL EN EL REGISTRO CONT1
 MOVLW	D'200'	    ;MUEVE EL LITERAL AL REGISTRO DE TRABAJO
 MOVWF	CONT3	    ;CARGA EL LITERAL EN EL REGISTRO CONT
 DECFSZ	CONT3	    ;DESCUENTA 1 AL REGISTRO SI ES CERO SALTA 1 INSTRUCCION
 GOTO	$-1	    ;CONTINUA DESCONTANDO EL REGISTRO EN 1
 DECFSZ	CONT4	    ;DESCUENTA 1 AL REGISTRO SI ES CERO SALTA 1 INSTRUCCION
 GOTO	$-5	    ;REGRESA A CARGAR EL REGISTRO CONT 
 DECFSZ	CONT5	    ;DESCUENTA 1 AL REGISTRO SI ES CERO SALTA 1 INSTRUCCION
 GOTO	$-9	    ;REGRESA A CARGAR DE NUEVO LOS REGISTROS CONT Y CONT1
 RETURN		    ;RETORNA DONDE FUE LLAMADO
;*******************************************************************************
 END		    ;FIN DEL PROGRAMA
