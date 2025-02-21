# falla-pic16f883
la idea basica de este programa es convertir un registro de 8 bits en BCD para ser mostrado en un display de 7 segmentos mediante el uso
de un TM1637, esto como base inicial para la creación de un frecuenciometro sencillo, por las pruebas que he podido realizar hasta esta
primera parte todo va bien, se convierte el registro, se envia la informacion al modulo TM1637. Como modo de prueba para comprobar que
se actualicen los datos en el display se realiza un loop de programa sencillo en donde primero se envia el dato del registro y luego
se envian valores de cero a cada display.
como veran para la idea original que es un frecuencimetro un unico registro de 8 bits es insuficiente para tener un rango de medidas 
adecuado, para dicho objetivo la idea es utilizar el TIMER1 como contador para aprovechar los dos registros asociados a este modulo
y tener un registro teorico de 16 bits, por lo que es necesario adicionar mas lineas de codigo, y aqui es donde surge el problema.
Inicialmente lo que hice fue continuar el codigo con las rutinas necesarias llegar al objetivo (este codigo adicional ya no se 
encuentra en el programa del repositorio), sin embargo esto me comenzo a generar un reinicio continuo del pic, di vueltas por muchos
partes pensando en que inicialmente fuera una falla en el codigo adicional, sin embargo el problema continuo, cambie de 
microcontrolador asumiendo que tuviese alguna falla interna, migre el proyecto a otra referencia de PIC, intente en las simulaciones y 
la falla continua, despues de un tiempo probe solamente adicionando lineas de condigo fuera de loop principal tan simples como un BSF, 
y como resultado pude observar que aunque fuera de loop principal despues de agregar una cantidad X de lineas de condigo el 
microcontrolador comienza a presentar fallas primero al actualizar el TM1637 y en cierto punto con un par de lineas de codigo mas 
entra en un reinicio permanente le he estado dando vueltas para intentar identificar el problema sin embargo no he podido identificar 
lo sucedido, he realizado cambios en los fusibles de configuracion, para probar, limpie tanto como me fue posible el codigo pero el 
problema continua. Lo que me lleva a pensar que debe ser algun error de sintaxis o un parametro de configuracion que estoy pasando por 
alto. 
todo el codigo esta en Assembler, que es el unico leguaje de programacion del que poseo conocimientos basicos, la subrutina del TM1637 
es bastante basica y aun debe ser pulida. 
para mi es un sintoma extraño que sigo intentanto resolver pero aun no tengo exito
