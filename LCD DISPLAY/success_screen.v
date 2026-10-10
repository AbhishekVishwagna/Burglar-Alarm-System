/* ============================================================================
 * success_screen.v – display for Burglar Alarm System
 *
 * Author: Abhishek
 *
 * Description:
 * Display for the success screen on system.
 *
* ============================================================================ */module success_screen (
    input  wire [7:0]  x,
    input  wire [8:0]  y,
    input  wire [23:0] flash_cnt,
    output reg  [15:0] pixel
);
    // Colors are defined
    localparam GREEN = 16'h07E0;
    localparam WHITE = 16'hFFFF;

    // To Prevent unused-signal warnings
    wire _unused_flash = |flash_cnt;

    // Screen & font constants
    localparam SCREEN_W = 240;
    localparam CHAR_W   = 24;

    // A Small Tick symbol is been drawn
    localparam TICK_X = SCREEN_W / 2;
    localparam TICK_Y = 90;

    wire tick_d1 = (x - TICK_X ==  (y - TICK_Y)) && (x >= TICK_X-8 && x <= TICK_X);

    wire tick_d1a = (x - TICK_X ==  (y - TICK_Y) + 1) && (x >= TICK_X-8 && x <= TICK_X);

    wire tick_d2 = (x - TICK_X == -(y - TICK_Y)) && (x >= TICK_X && x <= TICK_X+12);

    wire tick_d2a = (x - TICK_X == -(y - TICK_Y) + 1) && (x >= TICK_X && x <= TICK_X+12);

    //To write "PIN ACCEPTED" in the LCD
    // LINE 1: "PIN"
    localparam PIN_X = (SCREEN_W - 3*CHAR_W) / 2;
    localparam PIN_Y = 160;

    wire tP, tI, tN;

    text_ip TP (.x(x), .y(y), .start_x(PIN_X + 0*CHAR_W), .start_y(PIN_Y), .ascii("P"), .pixel_on(tP));
    text_ip TI (.x(x), .y(y), .start_x(PIN_X + 1*CHAR_W), .start_y(PIN_Y), .ascii("I"), .pixel_on(tI));
    text_ip TN (.x(x), .y(y), .start_x(PIN_X + 2*CHAR_W), .start_y(PIN_Y), .ascii("N"), .pixel_on(tN));

    // LINE 2: "ACCEPTED"
    localparam ACC_X = (SCREEN_W - 8*CHAR_W) / 2;
    localparam ACC_Y = 200;

    wire tA,tC,tC2,tE,tP2,tT,tE2,tD;

    text_ip TA  (.x(x), .y(y), .start_x(ACC_X + 0*CHAR_W), .start_y(ACC_Y), .ascii("A"), .pixel_on(tA));
    text_ip TC  (.x(x), .y(y), .start_x(ACC_X + 1*CHAR_W), .start_y(ACC_Y), .ascii("C"), .pixel_on(tC));
    text_ip TC2 (.x(x), .y(y), .start_x(ACC_X + 2*CHAR_W), .start_y(ACC_Y), .ascii("C"), .pixel_on(tC2));
    text_ip TE  (.x(x), .y(y), .start_x(ACC_X + 3*CHAR_W), .start_y(ACC_Y), .ascii("E"), .pixel_on(tE));
    text_ip TP2 (.x(x), .y(y), .start_x(ACC_X + 4*CHAR_W), .start_y(ACC_Y), .ascii("P"), .pixel_on(tP2));
    text_ip TT  (.x(x), .y(y), .start_x(ACC_X + 5*CHAR_W), .start_y(ACC_Y), .ascii("T"), .pixel_on(tT));
    text_ip TE2 (.x(x), .y(y), .start_x(ACC_X + 6*CHAR_W), .start_y(ACC_Y), .ascii("E"), .pixel_on(tE2));
    text_ip TD  (.x(x), .y(y), .start_x(ACC_X + 7*CHAR_W), .start_y(ACC_Y), .ascii("D"), .pixel_on(tD));

    // To write and drawn the text and the symbol
    always @(*) begin
        // Solid background
        pixel = GREEN;

        // Tick symbol and text in white
        if (tick_d1 || tick_d1a || tick_d2 || tick_d2a || tP||tI||tN|| tA||tC||tC2||tE||tP2||tT||tE2||tD)
            pixel = WHITE;
    end

endmodule
