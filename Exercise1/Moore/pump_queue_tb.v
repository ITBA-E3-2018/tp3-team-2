`include "./pump_queue.v"

module pump_queue_tb ();
reg B1, B2, clk, reset;
wire P;

pump_queue test (
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
    #1 reset = 0;
end

always begin
    #5 clk = !clk;
end

initial begin
  $dumpfile("queue.vcd");
  $dumpvars;
end

initial begin
  $display("Clk \tB1 \tB2 \tP");
  $monitor("%b\t%b\t%b\t%b",clk,B1,B2,P);
end

initial begin
  #5 B1 = 1; B2 = 0;
  #10 B1 = 0; B2 = 1;
  #20 B1 = 1; B2 = 1;
  #20 B1 = 1; B2 = 0;
end

initial begin
  #100 $finish;
end

endmodule