module Mealy00  (Clock, Resetn, w, z);

    input Clock, Resetn, w;
    output z;
    reg [3:1] y, Y;                    //y: Present State. Y: Next State.
    parameter [3:1] A=3'b000,B=3'b001,C=3'b010,D=3'b011,E=3'b100;
    initial y=3'b000;
    initial Y=3'b000;

    //Defines the next state combinational circuit
    always @(w,y)
        case(y)
            A:if(w) begin
                z=0;
                Y=B;
            end
            else begin
                z=0;
                Y=A;
            end
            B:if(w) begin
                z=0;
                Y=C;
            end
            else begin
                z=0;
                Y=A;
            C:if(w) begin
                z=0;
                Y=C;
            end
            else begin
                z=0;
                Y=D;
            end
            D:if(w) begin
                z=1;
                Y=E;
            end
            else begin
                z=0;
                Y=A;
            end
            E:if(w) begin
                z=0;
                Y=C;
            end
            else begin
                z=0;
                Y=A;
            end
            default begin
                z=0;
                Y=3'bxxx;
            end
        endcase

    //Defines the sequential block
    always @(negedge Resetn, posedge Clock) begin
         if(Resetn==0) y<=A;             //If a reset input occured, it goes back to the initial state A.
        else y<=Y;

endmodule