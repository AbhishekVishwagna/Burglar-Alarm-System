/* ============================================================================
 * lockout_screen.v – display for Burglar Alarm System
 *
 * Author: Abhishek
 *
 * Description:
 * Display for the alarm screen on system.
 *
* ============================================================================ */module lockout_screen (
    input  wire [7:0]  x,       // Current pixel X coordinate
    input  wire [8:0]  y,       // Current pixel Y coordinate
    output reg  [15:0] pixel    // RGB565 pixel colour output
);
    // Three different colors are defined
    localparam GREEN = 16'h07E0;
    localparam WHITE = 16'hFFFF; 
    localparam BLACK = 16'h0000; 
    
    localparam SCREEN_W = 240; // Screen Constants

    // A PADLOCK is drawn (small and centered)

    localparam PAD_W = 36;
    localparam PAD_H = 40;

    localparam PAD_X = (SCREEN_W/2) - (PAD_W/2);
    localparam PAD_Y = 95;

    wire body = (x >= PAD_X      && x <= PAD_X + PAD_W && y >= PAD_Y + 18 && y <= PAD_Y + PAD_H);

    wire shackle_top = (x >= PAD_X + 6 && x <= PAD_X + PAD_W - 6 && y >= PAD_Y && y <= PAD_Y + 5);

    wire shackle_left = (x >= PAD_X + 6 && x <= PAD_X + 10 && y >= PAD_Y && y <= PAD_Y + 18);

    wire shackle_right = (x >= PAD_X + PAD_W - 10 && x <= PAD_X + PAD_W - 6 && y >= PAD_Y && y <= PAD_Y + 18);

    wire keyhole = (x >= PAD_X + (PAD_W/2) - 2 && x <= PAD_X + (PAD_W/2) + 2 && y >= PAD_Y + 26 && y <= PAD_Y + 32);

    // LOCKED TEXT

    localparam CHAR_W = 24;
    localparam TEXT_W = 6 * CHAR_W;
    localparam TEXT_X = (SCREEN_W - TEXT_W) / 2;
    localparam TEXT_Y = 180;

    wire tL, tO, tC, tK, tE, tD;

    text_ip TL (.x(x), .y(y), .start_x(TEXT_X + 0*CHAR_W), .start_y(TEXT_Y), .ascii("L"), .pixel_on(tL));
    text_ip TO (.x(x), .y(y), .start_x(TEXT_X + 1*CHAR_W), .start_y(TEXT_Y), .ascii("O"), .pixel_on(tO));
    text_ip TC (.x(x), .y(y), .start_x(TEXT_X + 2*CHAR_W), .start_y(TEXT_Y), .ascii("C"), .pixel_on(tC));
    text_ip TK (.x(x), .y(y), .start_x(TEXT_X + 3*CHAR_W), .start_y(TEXT_Y), .ascii("K"), .pixel_on(tK));
    text_ip TE (.x(x), .y(y), .start_x(TEXT_X + 4*CHAR_W), .start_y(TEXT_Y), .ascii("E"), .pixel_on(tE));
    text_ip TD (.x(x), .y(y), .start_x(TEXT_X + 5*CHAR_W), .start_y(TEXT_Y), .ascii("D"), .pixel_on(tD));

    // Drawing in the LCD 

    always @(*) begin
        // Background
        pixel = GREEN;

        // Padlock
        if (body || shackle_top || shackle_left || shackle_right)
            pixel = BLACK;

        // Keyhole
        if (keyhole)
            pixel = WHITE;

        // Text
        if (tL || tO || tC || tK || tE || tD)
            pixel = BLACK;
    end

endmodule