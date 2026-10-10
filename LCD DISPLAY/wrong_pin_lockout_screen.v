/* ============================================================================
 * wrong_pin_lockout_screen.v – display for Burglar Alarm System
 *
 * Author: Abhishek
 *
 * Description:
 * Display for the wrong pin screen on system.
 *
* ============================================================================ */
module wrong_pin_lockout_screen (
    input  wire [7:0]  x,
    input  wire [8:0]  y,
    input  wire [23:0] flash_cnt,
    output reg  [15:0] pixel
);

    // Colors are defined for later use
    localparam RED   = 16'hF800;
    localparam BLACK = 16'h0000;

    // To Avoid unused input warning
    wire _unused = |flash_cnt;

    // Screen & font constant
    localparam SCREEN_W = 240;
    localparam CHAR_W   = 24;   // SCALE = 3

    // To display "SYSTEM LOCKED" text
    // LINE 1: "SYSTEM"
    localparam SYS_X = (SCREEN_W - 6*CHAR_W) / 2;
    localparam SYS_Y = 160;

    wire tS,tY,tS2,tT,tE,tM;

    text_ip TS  (.x(x), .y(y), .start_x(SYS_X+0*CHAR_W), .start_y(SYS_Y), .ascii("S"), .pixel_on(tS));
    text_ip TY  (.x(x), .y(y), .start_x(SYS_X+1*CHAR_W), .start_y(SYS_Y), .ascii("Y"), .pixel_on(tY));
    text_ip TS2 (.x(x), .y(y), .start_x(SYS_X+2*CHAR_W), .start_y(SYS_Y), .ascii("S"), .pixel_on(tS2));
    text_ip TT  (.x(x), .y(y), .start_x(SYS_X+3*CHAR_W), .start_y(SYS_Y), .ascii("T"), .pixel_on(tT));
    text_ip TE  (.x(x), .y(y), .start_x(SYS_X+4*CHAR_W), .start_y(SYS_Y), .ascii("E"), .pixel_on(tE));
    text_ip TM  (.x(x), .y(y), .start_x(SYS_X+5*CHAR_W), .start_y(SYS_Y), .ascii("M"), .pixel_on(tM));

    // LINE 2: "LOCKED"
    localparam LOCK_X = (SCREEN_W - 6*CHAR_W) / 2;
    localparam LOCK_Y = 205;

    wire tL,tO,tC,tK,tE2,tD;

    text_ip TL  (.x(x), .y(y), .start_x(LOCK_X+0*CHAR_W), .start_y(LOCK_Y), .ascii("L"), .pixel_on(tL));
    text_ip TO  (.x(x), .y(y), .start_x(LOCK_X+1*CHAR_W), .start_y(LOCK_Y), .ascii("O"), .pixel_on(tO));
    text_ip TC  (.x(x), .y(y), .start_x(LOCK_X+2*CHAR_W), .start_y(LOCK_Y), .ascii("C"), .pixel_on(tC));
    text_ip TK  (.x(x), .y(y), .start_x(LOCK_X+3*CHAR_W), .start_y(LOCK_Y), .ascii("K"), .pixel_on(tK));
    text_ip TE2 (.x(x), .y(y), .start_x(LOCK_X+4*CHAR_W), .start_y(LOCK_Y), .ascii("E"), .pixel_on(tE2));
    text_ip TD  (.x(x), .y(y), .start_x(LOCK_X+5*CHAR_W), .start_y(LOCK_Y), .ascii("D"), .pixel_on(tD));

    // To draw the text in the display

    always @(*) begin
        // Solid background in Red color
        pixel = RED;

        // Text to display
        if (tS||tY||tS2||tT||tE||tM||
            tL||tO||tC||tK||tE2||tD)
            pixel = BLACK;
    end

endmodule