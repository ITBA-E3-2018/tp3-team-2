
`timescale 100us / 100us

module Mealy00Tester ();

wire clk,out; 
reg resetn, in;            
reg [64:1] sequence;
integer i;
Clock_gen myClock(clk);
Mealy00 myMealy (clk,resetn,in,out);

initial in=0;
initial i=0;
initial resetn=1;


initial begin
sequence = 64'b1010001101010111010111101110100110110110111110101001111110111010;
  #640;
  $finish;
end

always @(posedge(clk)) begin

if(i<64) in <= sequence[64-i];
i=i+1;
$display("i=%d, Inputs: clk=%d, resetn=%d, in=%d. Outputs: out=%d",i,clk,resetn,in,out);
end

//To use gtkwave:
  reg dummy;
  reg[8*64:0] dumpfile_path = "mealy.vcd";

  initial begin
    dummy = $value$plusargs("VCD_PATH=%s", dumpfile_path);
    $dumpfile(dumpfile_path);
    $dumpvars(0,Mealy00Tester);
  end
  
endmodule