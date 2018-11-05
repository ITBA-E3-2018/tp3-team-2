`include "./pump_ctrl.v"

module pump_ctrl_tb ();
reg B1, B2, clk, reset;
wire P;

pump_ctrl test_module (
    .B1(B1),
    .B2(B2),
    .use_pump(P),
    .clk(clk),
    .reset(reset)
);

initial begin
    clk = 0;
    B1 = 0;
    B2 = 0;
    reset = 1;
    #6 reset = 0;
    #41 reset = 1;
    #10 reset = 0;
end

always begin
    #5 clk = !clk;
end

initial begin
  $dumpfile("pump.vcd");
  $dumpvars;
end

initial begin
  $display("Clk \tB1 \tB2 \tP");
  $monitor("%b\t%b\t%b\t%b",clk,B1,B2,P);
end

initial begin
  #4 B1 = 1; B2 = 0;
  #10 B1 = 0; B2 = 1;
  #2 B1 = 1; B2 = 0;
  #8 B1 = 0; B2 = 1;
  #20 B1 = 1; B2 = 1;
  #20 B1 = 1; B2 = 0;
  #20 B1 = 0; B2 = 0;
  #10 B1 = 1; B2 = 1;
  #10 B1 = 1; B2 = 0;
  #10 B1 = 0; B2 = 1;
end

initial begin
  #200 $finish;
end

endmodule