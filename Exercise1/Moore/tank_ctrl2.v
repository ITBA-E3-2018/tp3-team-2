module tank_ctrl2 (
    I,          //Sensor Inferior
    S,          //Sensor Superior
    B1,         //Bomba 1
    B2,         //Bomba 2
    clk,        //Clock
    nReset       //Reset
    );

//Definición I/O
input I, S, clk, nReset;
output B1, B2;

//Definición de Datos
    //Input Data Type
wire I, S, clk, nReset;
    //Output DataType
wire B1, B2;

//Internal Variables
reg [1:0] curr_state;
wire [1:0] next_state;
reg use_pump;
wire T;

//Internal Constants
parameter FULL  =   2'b11;      //En este caso apago las 2 bombas
parameter HALF  =   2'b01;      //En este caso prendo la ultima en no activarse
parameter EMPTY =   2'b00;      //En este caso prendo ambas bombas
parameter HOW   =   2'b10;      //En este caso dejo las dos apagadas por seguridad

//Code
assign next_state = fsm_tank(curr_state, I, S);

//Function Code
function [1:0] fsm_tank;
    input [1:0] curr_state;
    input I;
    input S;
    case (curr_state)
        FULL: if(I == 1'b0 && S == 1'b0) begin
                fsm_tank = EMPTY;
                end
                else if (I == 1'b1 && S == 1'b0) begin
                fsm_tank = HALF;
                end
                else if (I == 1'b1 && S == 1'b1) begin
                fsm_tank = FULL;
                end
                else if (I == 1'b0 && S == 1'b1) begin
                fsm_tank = HOW;
                end
        HALF: if(I == 1'b0 && S == 1'b0) begin
                fsm_tank = EMPTY;
                end
                else if (I == 1'b1 && S == 1'b0) begin
                fsm_tank = HALF;
                end
                else if (I == 1'b1 && S == 1'b1) begin
                fsm_tank = FULL;
                end
                else if (I == 1'b0 && S == 1'b1) begin
                fsm_tank = HOW;
                end
        EMPTY: if(I == 1'b0 && S == 1'b0) begin
                fsm_tank = EMPTY;
                end
                else if (I == 1'b1 && S == 1'b0) begin
                fsm_tank = HALF;
                end
                else if (I == 1'b1 && S == 1'b1) begin
                fsm_tank = FULL;
                end
                else if (I == 1'b0 && S == 1'b1) begin
                fsm_tank = HOW;
                end
        HOW: if(I == 1'b0 && S == 1'b0) begin
                fsm_tank = EMPTY;
                end
                else if (I == 1'b1 && S == 1'b0) begin
                fsm_tank = HALF;
                end
                else if (I == 1'b1 && S == 1'b1) begin
                fsm_tank = FULL;
                end
                else if (I == 1'b0 && S == 1'b1) begin
                fsm_tank = HOW;
                end
      default: fsm_tank = FULL;
    endcase
endfunction

//Sequential Logic
always @(posedge clk or nReset)
begin: FSM_SEQ
    if(nReset == 1'b0) begin
        curr_state <= #1 EMPTY;
    end else begin
        curr_state <= #1 next_state;
    end
end

//Relevant internal wires to output
wire nY0, nY1, nUP, a,b,c,d;

//Output Logic (asynchronous to clock)
not(nY0, curr_state[0]);
not(nY1, curr_state[1]);
not(nUP, use_pump);

or #(1) (a, nY0, nUP);
or #(1) (b, nY0, use_pump);

and #(1) (c, !curr_state[1], a);
and #(1) (d, !curr_state[1], b);

and #(1) (B1, nReset, c);
and #(1) (B2, nReset, d);

and #(1) (T,curr_state[0],!curr_state[1]);
always @(negedge T or nReset)
begin
    if (nReset == 1'b0) begin
        use_pump <= #1 1'b0;
    end else begin
    use_pump <= #1 !use_pump;
    end
end


endmodule
