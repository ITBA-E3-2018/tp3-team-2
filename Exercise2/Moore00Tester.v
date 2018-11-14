//`timescale 1ms / 100us
`timescale 100us / 100us

module Moore00Tester ();

wire clk,out; //VER SI ESTA BIEN!!!!!!!!!!
reg resetn, in;            //VER SI ESTA BIEN!!!!!!!!!!
reg [64:1] sequence;
integer i;
Clock_gen myClock(clk);
Moore00 myMoore (clk,resetn,in,out);

initial in=0;
initial i=0;
initial resetn=1;

initial begin
sequence = 64'b1010001101010111010111101110100110110110111110101001111110111010;

    //ESTE PEDACITO ANDA BIEN
    //#10
    /*
for (i=0;i<64;i=i+1)begin
in <= sequence[64-i];
resetn <= 1;
#10;
*/
//#1 $display("i=%d, Inputs: clk=%d, resetn=%d, in=%d. Outputs: out=%d",i,clk,resetn,in,out);
//end
//PROBAR TMB EL RESET
  //ACA VIENEN LAS PRUEBAS
  #640;
  $finish;
end

always @(posedge(clk)) begin
//i=i+1;
if(i<64) in <= sequence[64-i];

i=i+1;
$display("i=%d, Inputs: clk=%d, resetn=%d, in=%d. Outputs: out=%d",i,clk,resetn,in,out);
end

/*
//Para poder usar gtkwave:
  reg dummy;
  reg[8*64:0] dumpfile_path = "output.vcd";

  initial begin
    dummy = $value$plusargs("VCD_PATH=%s", dumpfile_path);
    $dumpfile(dumpfile_path);
    $dumpvars(0,Moore00Tester);
  end
  */

endmodule