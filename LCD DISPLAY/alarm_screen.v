/* ============================================================================
 * alarm_screen.v – display for Burglar Alarm System
 *
 * Author: Abhishek
 *
 * Description:
 * Display for the alarm screen on system.
 *
* ============================================================================ */
module alarm_screen (
    input  wire [7:0]  x,
    input  wire [8:0]  y,
    output reg  [15:0] pixel
);

    localparam RED   = 16'hF800; //Background color
    localparam BLACK = 16'h0000; // Text Color
    localparam SCREEN_W = 240; // Screen Constants

    // To Draw Danger symbol (A triangle)
    wire triangle = (y >= SYM_Y && y <= SYM_Y + 50) &&(x >= (SYM_X - (y - SYM_Y)) && x <= (SYM_X + (y - SYM_Y)));
     
     // Exclamation mark stem
    wire excl_stem = (x >= SYM_X - 2 && x <= SYM_X + 2 && y >= SYM_Y + 15 && y <= SYM_Y + 35);

    // Exclamation mark dot
    wire excl_dot = (x >= SYM_X - 2 && x <= SYM_X + 2 && y >= SYM_Y + 40 && y <= SYM_Y + 45);
   
    // To center the text
    localparam CHAR_W = 24;       // 8 * SCALE (SCALE = 3)
    localparam TEXT_W = 5 * CHAR_W; // "ALARM"
    localparam TEXT_X = (SCREEN_W - TEXT_W) / 2;
    localparam TEXT_Y = 190;
    //To print ALARM text
    wire tA,tL,tA2,tR,tM;

    text_ip TA  (.x(x), .y(y), .start_x(TEXT_X + 0*CHAR_W), .start_y(TEXT_Y), .ascii("A"), .pixel_on(tA));
    text_ip TL  (.x(x), .y(y), .start_x(TEXT_X + 1*CHAR_W), .start_y(TEXT_Y), .ascii("L"), .pixel_on(tL));
    text_ip TA2 (.x(x), .y(y), .start_x(TEXT_X + 2*CHAR_W), .start_y(TEXT_Y), .ascii("A"), .pixel_on(tA2));
    text_ip TR  (.x(x), .y(y), .start_x(TEXT_X + 3*CHAR_W), .start_y(TEXT_Y), .ascii("R"), .pixel_on(tR));
    text_ip TM  (.x(x), .y(y), .start_x(TEXT_X + 4*CHAR_W), .start_y(TEXT_Y), .ascii("M"), .pixel_on(tM));

    always @(*) begin
        pixel = RED; // Background
        
        //Danger symbol
        if (triangle)
            pixel = BLACK;

        if (excl_stem || excl_dot)
            pixel = BLACK;
        if (tA || tL || tA2 || tR || tM)
            pixel = BLACK;
    end

endmodule