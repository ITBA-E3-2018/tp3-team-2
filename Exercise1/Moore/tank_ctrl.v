module tank_ctrl (
    I,          //Sensor Inferior
    S,          //Sensor Superior
    B1,         //Bomba 1
    B2,         //Bomba 2
    clk,        //Clock
    reset       //Reset
    );

//Definición I/O
input I, S, clk, reset;
output B1, B2;

//Definición de Datos
    //Input Data Type
wire I, S, clk, reset;
    //Output DataType
reg B1, B2;

//Internal Variables
reg [1:0] curr_state;
wire [1:0] next_state;
reg use_pump;
wire T;

//Internal Constants
parameter FULL  =   2'b11;      //En este caso apago las 2 bombas
parameter HALF  =   2'b01;      //En este caso prendo la ultima en no activarse
parameter EMTPY =   2'b00;      //En este caso prendo ambas bombas
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
                fsm_tank = EMTPY;
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
                fsm_tank = EMTPY;
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
        EMTPY: if(I == 1'b0 && S == 1'b0) begin
                fsm_tank = EMTPY;
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
                fsm_tank = EMTPY;
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
always @(posedge clk or reset)
begin: FSM_SEQ
    if(reset == 1'b1) begin
        curr_state <= #1 FULL;
    end else begin
        curr_state <= #1 next_state;
    end
end

//Output Logic (asynchronous to clock)
always @(*)
begin: OUTPUT_LOGIC
    if (reset == 1'b1) begin
        B1 <= #1 1'b0;
        B2 <= #1 1'b0;
        use_pump <= #1 1'b1;
    end else begin
        case (curr_state)
            FULL: begin 
                B1 <= #1 1'b0;
                B2 <= #1 1'b0;
                end
            EMTPY: begin
                B1 <= #1 1'b1;
                B2 <= #1 1'b1;
                end
            HALF: begin
                B1 <= #1 !use_pump;
                B2 <= #1 use_pump;
                end
            HOW: begin
                B1 <= #1 1'b0;
                B2 <= #1 1'b0;
                end
            default: begin
                B1 <= #1 1'b0;
                B2 <= #1 1'b0;
                end
        endcase
    end
end

and(T,curr_state[0],!curr_state[1]);
always @(negedge T or reset)
begin
    if (reset == 1'b1) begin
        use_pump <= #1 1'b1;
    end
    use_pump <= #1 !use_pump;
end


endmodule
