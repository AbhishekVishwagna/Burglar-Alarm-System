`timescale 1ns/1ps

module timer_demo_top_tb;

reg CLOCK_50;
reg [3:0] KEY;

wire [6:0] HEX1, HEX0;
wire [9:0] LEDR;
wire [6:0] HEX2, HEX3, HEX4, HEX5;

// DUT
timer_demo_top uut (
    .CLOCK_50(CLOCK_50),
    .KEY(KEY),
    .HEX1(HEX1),
    .HEX0(HEX0),
    .LEDR(LEDR),
    .HEX2(HEX2),
    .HEX3(HEX3),
    .HEX4(HEX4),
    .HEX5(HEX5)
);

// CLOCK 
initial CLOCK_50 = 0;
always #5 CLOCK_50 = ~CLOCK_50;

// TEST SEQUENCE
initial begin

    // initialize keys
    KEY = 4'b1111;

    // RESET
    #20;
    KEY[0] = 0;
    #20;
    KEY[0] = 1;

    // START
    #40;
    KEY[1] = 0; #10; KEY[1] = 1;

    // run
    #1000;

    // PAUSE
    KEY[1] = 0; #10; KEY[1] = 1;

    #500;

    // RESUME
    KEY[1] = 0; #10; KEY[1] = 1;

    #2000;

    $stop;

end

endmodule