/* ============================================================================
 * wrong_pin_2.v – display for Burglar Alarm System
 *
 * Author: Abhishek
 *
 * Description:
 * Display for the wrong pin screen on system.
 *
* ============================================================================ */
module wrong_pin_2 (
    input  wire [7:0]  x,
    input  wire [8:0]  y,
    output reg  [15:0] pixel
);
    // Colors are defined
    localparam RED   = 16'hF800;
    localparam WHITE = 16'hFFFF;

    // Screen & font constants
    localparam SCREEN_W = 240;
    localparam CHAR_W   = 24; 

    // "X" WRONG SYMBOL
    localparam X_CX = SCREEN_W/2 - 40;
    localparam X_CY = 85;

    wire wrong_diag1 =
        (x - X_CX ==  y - X_CY) &&
        (x >= X_CX-18 && x <= X_CX+18);

    wire wrong_diag2 =
        (x - X_CX == -(y - X_CY)) &&
        (x >= X_CX-18 && x <= X_CX+18);

    // A KEY SYMBOL
    localparam KEY_X = SCREEN_W/2 + 8;
    localparam KEY_Y = 70;

    wire key_head =
        (x >= KEY_X     && x <= KEY_X+14 &&
         y >= KEY_Y     && y <= KEY_Y+14);

    wire key_shaft =
        (x >= KEY_X+14  && x <= KEY_X+44 &&
         y >= KEY_Y+6   && y <= KEY_Y+10);

    wire key_tooth1 =
        (x >= KEY_X+26  && x <= KEY_X+30 &&
         y >= KEY_Y+10  && y <= KEY_Y+18);

    wire key_tooth2 =
        (x >= KEY_X+34  && x <= KEY_X+38 &&
         y >= KEY_Y+10  && y <= KEY_Y+16);

    //To display the text
    // LINE 1: "WRONG PIN"
    localparam LINE1_CHARS = 9;
    localparam LINE1_X = (SCREEN_W - LINE1_CHARS*CHAR_W)/2;
    localparam LINE1_Y = 150;

    wire tW,tR,tO,tN,tG,tP,tI,tN2;

    text_ip TW  (.x(x), .y(y), .start_x(LINE1_X + 0*CHAR_W), .start_y(LINE1_Y), .ascii("W"), .pixel_on(tW));
    text_ip TR  (.x(x), .y(y), .start_x(LINE1_X + 1*CHAR_W), .start_y(LINE1_Y), .ascii("R"), .pixel_on(tR));
    text_ip TO  (.x(x), .y(y), .start_x(LINE1_X + 2*CHAR_W), .start_y(LINE1_Y), .ascii("O"), .pixel_on(tO));
    text_ip TN  (.x(x), .y(y), .start_x(LINE1_X + 3*CHAR_W), .start_y(LINE1_Y), .ascii("N"), .pixel_on(tN));
    text_ip TG  (.x(x), .y(y), .start_x(LINE1_X + 4*CHAR_W), .start_y(LINE1_Y), .ascii("G"), .pixel_on(tG));

    text_ip TP  (.x(x), .y(y), .start_x(LINE1_X + 6*CHAR_W), .start_y(LINE1_Y), .ascii("P"), .pixel_on(tP));
    text_ip TI  (.x(x), .y(y), .start_x(LINE1_X + 7*CHAR_W), .start_y(LINE1_Y), .ascii("I"), .pixel_on(tI));
    text_ip TN2 (.x(x), .y(y), .start_x(LINE1_X + 8*CHAR_W), .start_y(LINE1_Y), .ascii("N"), .pixel_on(tN2));

    // LINE 2: "ATTEMPT"
    localparam LINE2_CHARS = 7;
    localparam LINE2_X = (SCREEN_W - LINE2_CHARS*CHAR_W)/2;
    localparam LINE2_Y = 185;

    wire tA,tT,tT2,tE,tM,tP2,tT3;

    text_ip TA  (.x(x), .y(y), .start_x(LINE2_X + 0*CHAR_W), .start_y(LINE2_Y), .ascii("A"), .pixel_on(tA));
    text_ip TT  (.x(x), .y(y), .start_x(LINE2_X + 1*CHAR_W), .start_y(LINE2_Y), .ascii("T"), .pixel_on(tT));
    text_ip TT2 (.x(x), .y(y), .start_x(LINE2_X + 2*CHAR_W), .start_y(LINE2_Y), .ascii("T"), .pixel_on(tT2));
    text_ip TE  (.x(x), .y(y), .start_x(LINE2_X + 3*CHAR_W), .start_y(LINE2_Y), .ascii("E"), .pixel_on(tE));
    text_ip TM  (.x(x), .y(y), .start_x(LINE2_X + 4*CHAR_W), .start_y(LINE2_Y), .ascii("M"), .pixel_on(tM));
    text_ip TP2 (.x(x), .y(y), .start_x(LINE2_X + 5*CHAR_W), .start_y(LINE2_Y), .ascii("P"), .pixel_on(tP2));
    text_ip TT3 (.x(x), .y(y), .start_x(LINE2_X + 6*CHAR_W), .start_y(LINE2_Y), .ascii("T"), .pixel_on(tT3));

    // LINE 3: "TWO"
    localparam LINE3_CHARS = 3;
    localparam LINE3_X = (SCREEN_W - LINE3_CHARS*CHAR_W)/2;
    localparam LINE3_Y = 220;

    wire tT4,tW2,tO2;

    text_ip TT4 (.x(x), .y(y), .start_x(LINE3_X + 0*CHAR_W), .start_y(LINE3_Y), .ascii("T"), .pixel_on(tT4));
    text_ip TW2 (.x(x), .y(y), .start_x(LINE3_X + 1*CHAR_W), .start_y(LINE3_Y), .ascii("W"), .pixel_on(tW2));
    text_ip TO2 (.x(x), .y(y), .start_x(LINE3_X + 2*CHAR_W), .start_y(LINE3_Y), .ascii("O"), .pixel_on(tO2));

    //To show the text and the symbols in the screen
    always @(*) begin
        pixel = RED;

        if (wrong_diag1 || wrong_diag2 ||
            key_head || key_shaft || key_tooth1 || key_tooth2 || tW||tR||tO||tN||tG||tP||tI||tN2|| tA||tT||tT2||tE||tM||tP2||tT3||
            tT4||tW2||tO2)
            pixel = WHITE;
    end

endmodule