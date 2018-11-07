`include "./tank_ctrl.v"
`include "./tank_ctrl2.v"

module tank_ctrl_tb ();

//Inputs
reg I, S, clk, nReset;

//Outputs
wire B1,B2;

tank_ctrl2 test_module (
    .I(I),          //Sensor Inferior
    .S(S),          //Sensor Superior
    .B1(B1),        //Bomba 1
    .B2(B2),        //Bomba 2
    .clk(clk),      //Clock
    .nReset(nReset)   //Reset
);

initial begin
    clk = 0;
    I = 0;
    S = 0;
    nReset = 0;
    #14 nReset = 1;
    #30 nReset = 0;
    #10 nReset = 1;
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
    I=0; S=0;
    #10 I=1; S=0;
    #10 I=0; S=0;
    #10 I=1; S=0;
    #10 I=0; S=0;
    #10 I=1; S=0;
    #10 I=1; S=1;
    #10 I=1; S=0;
    #10 I=1; S=1;
    #10 I=1; S=0;
    #10 I=0; S=0;
    #10 I=1; S=0;
    #10 I=1; S=1;
    #10 I=0; S=1;
    #20 I=1; S=0;
    #10 I=1; S=1;
    
end

initial begin
  #200 $finish;
end

endmodule