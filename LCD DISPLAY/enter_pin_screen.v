/* ============================================================================
 * enter_pin_screen.v – display for Burglar Alarm System
 *
 * Author: Abhishek
 *
 * Description:
 * Display for the enter pin screen on system.
 *
* ============================================================================ */module enter_pin_screen (
    input  wire [7:0]  x,
    input  wire [8:0]  y,
    output reg  [15:0] pixel
);
    // Colors are defined
    localparam BLUE  = 16'h001F;
    localparam BLACK = 16'h0000;

    localparam SCREEN_W = 240;
    localparam CHAR_W   = 24;   // SCALE = 3 (from text_ip)


    // Text positions (centered)
    localparam ENTER_W = 5 * CHAR_W;
    localparam ENTER_X = (SCREEN_W - ENTER_W) / 2;
    localparam ENTER_Y = 150;

    // PIN (3 chars)
    localparam PIN_W = 3 * CHAR_W;
    localparam PIN_X = (SCREEN_W - PIN_W) / 2;
    localparam PIN_Y = 190;

    // To dispaly the Text "ENTER PIN"

    wire tE, tN, tT, tE2, tR;

    text_ip TE  (.x(x), .y(y), .start_x(ENTER_X + 0*CHAR_W), .start_y(ENTER_Y), .ascii("E"), .pixel_on(tE));
    text_ip TN  (.x(x), .y(y), .start_x(ENTER_X + 1*CHAR_W), .start_y(ENTER_Y), .ascii("N"), .pixel_on(tN));
    text_ip TT  (.x(x), .y(y), .start_x(ENTER_X + 2*CHAR_W), .start_y(ENTER_Y), .ascii("T"), .pixel_on(tT));
    text_ip TE2 (.x(x), .y(y), .start_x(ENTER_X + 3*CHAR_W), .start_y(ENTER_Y), .ascii("E"), .pixel_on(tE2));
    text_ip TR  (.x(x), .y(y), .start_x(ENTER_X + 4*CHAR_W), .start_y(ENTER_Y), .ascii("R"), .pixel_on(tR));

    wire tP, tI, tN2;

    text_ip TP  (.x(x), .y(y), .start_x(PIN_X + 0*CHAR_W), .start_y(PIN_Y), .ascii("P"), .pixel_on(tP));
    text_ip TI  (.x(x), .y(y), .start_x(PIN_X + 1*CHAR_W), .start_y(PIN_Y), .ascii("I"), .pixel_on(tI));
    text_ip TN2 (.x(x), .y(y), .start_x(PIN_X + 2*CHAR_W), .start_y(PIN_Y), .ascii("N"), .pixel_on(tN2));

    // KEY SYMBOL (clear & bold)

    localparam KEY_X = SCREEN_W / 2 - 30;
    localparam KEY_Y = 230;

    // Key head (circle-like block)
    wire key_head = (x >= KEY_X && x <= KEY_X + 14 && y >= KEY_Y && y <= KEY_Y + 14);

    // Key shaft (thick)
    wire key_shaft = (x >= KEY_X + 14 && x <= KEY_X + 44 && y >= KEY_Y + 6 && y <= KEY_Y + 10);

    // Key tooth 1
    wire key_tooth1 = (x >= KEY_X + 26 && x <= KEY_X + 30 && y >= KEY_Y + 10 && y <= KEY_Y + 18);

    // Key tooth 2
    wire key_tooth2 = (x >= KEY_X + 34 && x <= KEY_X + 38 && y >= KEY_Y + 10 && y <= KEY_Y + 16);

    // To print text and the symbol
    always @(*) begin
        // Background
        pixel = BLUE;

        // Text
        if (tE || tN || tT || tE2 || tR || tP || tI || tN2)
            pixel = BLACK;

        // Key symbol
        if (key_head || key_shaft || key_tooth1 || key_tooth2)
            pixel = BLACK;
    end

endmodule