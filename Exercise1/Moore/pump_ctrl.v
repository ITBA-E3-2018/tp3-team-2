module pump_ctrl (
    B1,      //Last Activated Pump was B1
    B2,      //Last Activated Pump was B2
    use_pump,   //Armed Pump
    clk,        //Clock
    reset       //Reset
);

//Definición I/O
input B1, B2, clk, reset;
output use_pump;

//Definición de Datos
    //Input Data Type
wire B1, B2, clk, reset;
    //Output Data Type
reg use_pump;

//Internal Constants
parameter s_LP1 = 1'b0;
parameter s_LP2 = 1'b1;

//Internal Variables
reg curr_state;
wire next_state;

//Code
assign next_state = fsm_function(curr_state,B1,B2);

//Function Code
function fsm_function;
    input curr_state;
    input B1;
    input B2;
    case (curr_state)
        s_LP1: if(B1 == 1'b0 && B2 == 1'b1) begin
                fsm_function = s_LP2;
                end
                else begin
                fsm_function = s_LP1;
                end
        s_LP2: if(B1 == 1'b1 && B2 == 1'b0) begin
                fsm_function = s_LP1;
                end
                else begin
                fsm_function = s_LP2;
                end
      default: fsm_function = s_LP1;
    endcase
endfunction

//Sequential Logic (synchronous to clock)
always @(posedge clk or reset)
begin: FSM_SEQ
    if(reset == 1'b1) begin
        curr_state <= #1 s_LP1;
    end else begin
        curr_state <= #1 next_state;
    end
end

//Output Logic (not synchronous to clock)
always @(*)
begin: OUTPUT_LOGIC
    if (reset == 1'b1) begin
        use_pump <= #1 1'b0;
    end else begin
        case (curr_state)
            s_LP1: use_pump <= #1 1'b1;
            s_LP2: use_pump <= #1 1'b0;
            default: use_pump <= #1 1'b0;
        endcase
    end
end

//Module End
endmodule