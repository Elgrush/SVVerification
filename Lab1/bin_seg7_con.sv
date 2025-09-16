module bin_seg7_con (
    input [3:0] in,
    input BI,
    input RBI,
    input LT,
    output logic [6:0] out
);
    
always_comb begin
    case (in)
        4'h0: out = 7'b1111110;
        4'h1: out = 7'b0110000;
        4'h2: out = 7'b1101101;
        4'h3: out = 7'b1111001;
        4'h4: out = 7'b0110011;
        4'h5: out = 7'b1011011;
        4'h6: out = 7'b1011111;
        4'h7: out = 7'b1110000;
        4'h8: out = 7'b1111111;
        4'h9: out = 7'b1111011;
        4'hA: out = 7'b1110111;
        4'hB: out = 7'b0011111;
        4'hC: out = 7'b1001110;
        4'hD: out = 7'b0111101;
        4'hE: out = 7'b1001111;
        default: out = 7'b0;
    endcase
    if(!RBI && (in == 4'h0)) out = '0;
    if(!LT)  out = '1;
    if(!BI)  out = '0;
end

endmodule

