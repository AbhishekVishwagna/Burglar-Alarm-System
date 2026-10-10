/* ============================================================================
 * lock_the_system_screen.v – display for Burglar Alarm System
 *
 * Author: Abhishek
 *
 * Description:
 * Display for the lock the system screen on system.
 *
* ============================================================================ */module lock_the_system_screen (
    input  wire [7:0]  x,
    input  wire [8:0]  y,
    output reg  [15:0] pixel
);
    // Colors are defined
    localparam BLUE  = 16'h001F;
    localparam WHITE = 16'hFFFF;
	 localparam BLACK = 16'h0000;

    // To draw an Unlocked PADLOCK in the LCD
    wire pad_right = (x >= 8'd128 && x <= 8'd138 &&
                      y >= 9'd75  && y <= 9'd103);

    wire pad_top   = (x >= 8'd96  && x <= 8'd138 &&
                      y >= 9'd103 && y <= 9'd111);

    wire pad_left  = (x >= 8'd96  && x <= 8'd106 &&
                      y >= 9'd111 && y <= 9'd133);

    wire pad_body  = (x >= 8'd83  && x <= 8'd156 &&
                      y >= 9'd133 && y <= 9'd173);

    wire pad_hole  = (x >= 8'd116 && x <= 8'd122 &&
                      y >= 9'd146 && y <= 9'd162);
   
    // To print "LOCK THE SYSTEM" text in the diplay
    // Text: Line 1 "LOCK THE"

    wire tL, tO, tC, tK;
    wire tT, tH, tE;

    text_ip TL (.x(x), .y(y), .start_x(40),  .start_y(190), .ascii("L"), .pixel_on(tL));
    text_ip TO (.x(x), .y(y), .start_x(60),  .start_y(190), .ascii("O"), .pixel_on(tO));
    text_ip TC (.x(x), .y(y), .start_x(80),  .start_y(190), .ascii("C"), .pixel_on(tC));
    text_ip TK (.x(x), .y(y), .start_x(100), .start_y(190), .ascii("K"), .pixel_on(tK));

    text_ip TT (.x(x), .y(y), .start_x(140), .start_y(190), .ascii("T"), .pixel_on(tT));
    text_ip TH (.x(x), .y(y), .start_x(160), .start_y(190), .ascii("H"), .pixel_on(tH));
    text_ip TE (.x(x), .y(y), .start_x(180), .start_y(190), .ascii("E"), .pixel_on(tE));

    // Text: Line 2 "SYSTEM"
    wire tS, tY, tS2, tT2, tE2, tM;

    text_ip TS  (.x(x), .y(y), .start_x(60),  .start_y(215), .ascii("S"), .pixel_on(tS));
    text_ip TY  (.x(x), .y(y), .start_x(80),  .start_y(215), .ascii("Y"), .pixel_on(tY));
    text_ip TS2 (.x(x), .y(y), .start_x(100), .start_y(215), .ascii("S"), .pixel_on(tS2));
    text_ip TT2 (.x(x), .y(y), .start_x(120), .start_y(215), .ascii("T"), .pixel_on(tT2));
    text_ip TE2 (.x(x), .y(y), .start_x(140), .start_y(215), .ascii("E"), .pixel_on(tE2));
    text_ip TM  (.x(x), .y(y), .start_x(160), .start_y(215), .ascii("M"), .pixel_on(tM));


    // To draw the text and the unlocked PADLOCK in the LCD
    always @(*) begin
        pixel = BLUE;   // default background

        // Padlock white areas
        if (pad_right || pad_top || pad_left || pad_body)
            pixel = BLACK;

        // Text white
        if (tL || tO || tC || tK || tT || tH || tE || tS || tY || tS2 || tT2 || tE2 || tM)
            pixel = BLACK;

        if (pad_hole)
            pixel = BLUE;
    end

endmodule
