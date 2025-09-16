// Copyright (c) 2020 FPGAcademy
// Please see license at https://github.com/fpgacademy/DESim

// Protect against undefined nets
`default_nettype none



module Top (CLOCK_10, CLOCK1_50, CLOCK2_50, KEY, SW, LEDR, SEM);
    input  logic         CLOCK_10;   // DE-series 10 MHz clock signal
    input  logic         CLOCK1_50;  // DE-series 50 MHz clock signal
    input  logic         CLOCK2_50;  // DE-series 50 MHz clock signal
    input  logic [ 1: 0] KEY;        // DE-series pushbuttons
    input  logic [ 9: 0] SW;         // DE-series switches
    output logic [ 9: 0] LEDR;       // DE-series LEDs
    output logic [ 7: 0] SEM [3:0];

    logic [7:0] toSem;
    logic [6:0] toSemNorm;

    always_comb begin
        for(int i = 0; i < 7; i++) begin
            toSem[6-i] = toSemNorm[i];
        end
        for(int i = 1; i < 4; i++) begin
            SEM[i] = '1;
        end
    end

    assign SEM[0] = ~toSem;

    assign toSem[7] = 1'b1;
	 
	bin_seg7_con seg7 (SW[3:0], KEY[0], KEY[1], SW[9], toSemNorm);

endmodule

