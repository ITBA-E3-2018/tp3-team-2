`include "./pump_ctrl.v"
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
reg [1:0] next_state;
wire next_pump;

//Internal Constants
parameter FULL  =   2'b11;      //En este caso apago las 2 bombas
parameter HALF  =   2'b01;      //En este caso prendo la ultima en no activarse
parameter EMTPY =   2'b00;      //En este caso prendo ambas bombas
parameter HOW   =   2'b10;      //En este caso dejo las dos apagadas por seguridad

//Code
assign next_state = fsm_function(curr_state, B1, B2);

//Function Code
function [1:0] fsm_function;
    input [1:0] curr_state;
    input B1;
    input B2;
    case (curr_state)
        FULL: if(I == 1'b0 && S == 1'b0) begin
                fsm_function = EMTPY;
                end
                else if (I == 1'b1 && S == 1'b0) begin
                fsm_function = HALF;
                end
                else if (I == 1'b1 && S == 1'b1) begin
                fsm_function = FULL;
                end
                else if (I == 1'b0 && S == 1'b1) begin
                fsm_function = HOW;
                end
        HALF: if(I == 1'b0 && S == 1'b0) begin
                fsm_function = EMTPY;
                end
                else if (I == 1'b1 && S == 1'b0) begin
                fsm_function = HALF;
                end
                else if (I == 1'b1 && S == 1'b1) begin
                fsm_function = FULL;
                end
                else if (I == 1'b0 && S == 1'b1) begin
                fsm_function = HOW;
                end
        EMTPY: if(I == 1'b0 && S == 1'b0) begin
                fsm_function = EMTPY;
                end
                else if (I == 1'b1 && S == 1'b0) begin
                fsm_function = HALF;
                end
                else if (I == 1'b1 && S == 1'b1) begin
                fsm_function = FULL;
                end
                else if (I == 1'b0 && S == 1'b1) begin
                fsm_function = HOW;
                end
        HOW: if(I == 1'b0 && S == 1'b0) begin
                fsm_function = EMTPY;
                end
                else if (I == 1'b1 && S == 1'b0) begin
                fsm_function = HALF;
                end
                else if (I == 1'b1 && S == 1'b1) begin
                fsm_function = FULL;
                end
                else if (I == 1'b0 && S == 1'b1) begin
                fsm_function = HOW;
                end
      default: fsm_function = FULL;
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
pump_ctrl pump(
    .B1(B1),
    .B2(B2),
    .use_pump(),
    .clk(clk),
    .reset(reset)
);

always @(*)
begin: OUTPUT_LOGIC
    if (reset == 1'b1) begin
        B1 <= #1 1'b0;
        B2 <= #1 1'b0;
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
                B1 <= #1 !pump.use_pump;
                B2 <= #1 pump.use_pump;
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



endmodule
