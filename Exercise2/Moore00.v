
module Moore00 (Clock, Resetn, w, z);

    input Clock, Resetn, w;
    output z;
    reg [3:1] y, Y; //y: Present State. Y: Next State
    parameter [3:1] A=3'b000,B=3'b001,C=3'b010,D=3'b011,E=3'b100;

    initial y=3'b000;
    initial Y=3'b000;

    //Defines the next state combinational circuit
    always @(w,y)
        case(y)
            A: if(w) Y=B;
                else Y=A;
            B: if(w) Y=C;
                else Y=A;
            C: if(w) Y=C;
                else Y=D;  
            D: if(w) Y=E;
                else Y=A;
            E: if(w) Y=C;
                else Y=A;
            default: Y=3'bxxx;
        endcase

    //Defines the sequential block
    always @(negedge Resetn, posedge Clock) begin
        if(Resetn==0) y<=A;                 //If a reset input occured, it goes back to the initial state A.
        else y<=Y;                          //Else, the new present state is assigned.
        $display("Estado actual y = %b %b %b",y[3], y[2], y[1]); 
    end

    //Defines output
    assign z=(y==E);                        //If present state is E, the output is 1.

endmodule