`timescale 1ns / 1ps

// This test bench is to test the font and text IPs.
// font_ip is instatiated in text_ip.

module tb_text_ip;

    reg  [7:0] x;
    reg  [8:0] y;
    reg  [7:0] start_x;
    reg  [8:0] start_y;
    reg  [7:0] ascii;
    wire       pixel_on;
	

    text_ip DUT (
        .x(x),
        .y(y),
        .start_x(start_x),
        .start_y(start_y),
        .ascii(ascii),
        .pixel_on(pixel_on)
    );

    initial begin
        start_x = 50;
        start_y = 40;
        ascii   = "A";

        // Outside character
        x = 10; y = 10;
        #10;

        // Inside character
        x = 55; y = 45;
        #10;

        // Change character
        ascii = "B";
        #10;
		  
		  // Give ascii a number
		  ascii = 3;
		  #10;
		  
		  // Again a character
		  ascii = "R";
		  #10;

        x = 60; y = 52;
        #10;

        $stop;
    end

endmodule