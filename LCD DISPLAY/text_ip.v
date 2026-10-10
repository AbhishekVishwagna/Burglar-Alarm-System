module text_ip (
    input  wire [7:0] x,         // Current pixel X coordinate
    input  wire [8:0] y,         // Current pixel Y coordinate
    input  wire [7:0] start_x,   // Character top-left X position
    input  wire [8:0] start_y,   // Character top-left Y position
    input  wire [7:0] ascii,     // ASCII code of character to draw
    output wire       pixel_on   // High when this pixel is part of the character
);
    localparam SCALE  = 3;        // 2x scaling of pixels
    localparam FONT_W = 8;        // Font width in pixels
    localparam FONT_H = 8;        // Font height in pixels

    wire signed [9:0] dx = x - start_x;
    wire signed [9:0] dy = y - start_y;
    wire in_box =
         dx >= 0 && dx < FONT_W * SCALE &&
         dy >= 0 && dy < FONT_H * SCALE;

    wire [2:0] font_col = dx / SCALE;  // Column in font bitmap
    wire [2:0] font_row = dy / SCALE;  // Row in font bitmap
    wire [7:0] font_bits;

    font_ip FONT (
        .ascii (ascii),     // Character to fetch
        .row   (font_row),  // Font row (0–7)
        .bits  (font_bits)  // 8-bit pixel row
    );
    assign pixel_on =
        in_box && font_bits[7 - font_col];

endmodule