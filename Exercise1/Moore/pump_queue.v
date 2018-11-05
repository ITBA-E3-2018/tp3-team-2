module pump_queue (
    B1,     //Last Activated Pump was B1
    B2,     //Last Activated Pump was B2
    next_pump,     //Armed Pump
    clk     //Clock
);

//Definición I/O
input B1, B2, clk;
output next_pump;

parameter s_LP1 = 1b'0;
parameter s_LP2 = 1b'1;

parameter arm_B1 = 1b'0;
parameter arm_B2 = 1b'1;

//Definición de Datos
wire B1, B2, clk;

reg last_pump;
reg next_pump;

initial begin
    last_pump <= s_LP2;
end

always @(posedge clk) begin
    if(B1 and !B2) begin
        last_pump <= s_LP1;
        next_pump <= arm_B2;
    end
    else if (!B1 and B2) begin
        last_pump <= s_LP2;
        next_pump <= arm_B1;
    end
end


endmodule