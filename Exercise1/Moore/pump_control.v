module pump_ctrl (
    I,          //Sensor Inferior
    S,          //Sensor Superior
    B1,         //Bomba 1
    B2,         //Bomba 2
    clk,        //Clock
    AP          //Armed Pump: Input from sub-FSM
    );

//Definición I/O
input I, S, clk, AP;
output B1, B2;

//Definición de las variables para los estados
parameter FULL      2b'11;
parameter HALF      2b'01;
parameter EMTPY     2b'00;
parameter HOW       2b'10;




endmodule
