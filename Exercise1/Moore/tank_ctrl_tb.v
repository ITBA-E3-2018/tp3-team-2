`include "./tank_ctrl.v"

module tank_ctrl_tb ();

//Inputs
reg I, S, clk, reset;

//Outputs
wire B1,B2;

tank_ctrl test_module (
    .I(I),          //Sensor Inferior
    .S(S),          //Sensor Superior
    .B1(B1),        //Bomba 1
    .B2(B2),        //Bomba 2
    .clk(clk),      //Clock
    .reset(reset)   //Reset
);

initial begin
    clk = 0;
    I = 0;
    S = 0;
    reset = 1;
    #1 reset = 0;
end

always begin
    #5 clk = !clk;
end

initial begin
  $dumpfile("tank.vcd");
  $dumpvars;
end

initial begin
  $display("Clk \tI \tS \tB1 \tB2");
  $monitor("%b\t%b\t%b\t%b\t%b",clk,I,S,B1,B2);
end

initial begin
  
end

initial begin
  #200 $finish;
end

endmodule