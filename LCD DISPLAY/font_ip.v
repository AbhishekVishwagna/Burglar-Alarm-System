module font_ip (
    input  wire [7:0] ascii,   // 8bit ASCII code A to Z
    input  wire [2:0] row,     // Row number within 8x8 Character
    output reg  [7:0] bits     // 8 pixels (MSB = left)
);
	// Output changes immediately when ASCII or row changes
always @(*) begin
    bits = 8'b00000000;

    case (ascii)	// Start which character to draw.

        // Aplhabets from A to Z in capital; Pixel values is given to bits to draw letters
        "A": case (row)
            0: bits = 8'b00111100;
            1: bits = 8'b01000010;
            2: bits = 8'b01000010;
            3: bits = 8'b01111110;
            4: bits = 8'b01000010;
            5: bits = 8'b01000010;
        endcase

        "B": case (row)
            0: bits = 8'b01111100;
            1,2: bits = 8'b01000010;
            3: bits = 8'b01111100;
            4,5: bits = 8'b01000010;
            6: bits = 8'b01111100;
        endcase

        "C": case (row)
            0,6: bits = 8'b00111100;
            1,2,3,4,5: bits = 8'b01000000;
        endcase

        "D": case (row)
            0,6: bits = 8'b01111100;
            1,2,3,4,5: bits = 8'b01000010;
        endcase

        "E": case (row)
            0,3,6: bits = 8'b01111110;
            1,2,4,5: bits = 8'b01000000;
        endcase

        "F": case (row)
            0,3: bits = 8'b01111110;
            1,2,4,5,6: bits = 8'b01000000;
        endcase

        "G": case (row)
            0: bits = 8'b00111100;
            1,2: bits = 8'b01000000;
            3: bits = 8'b01001110;
            4,5: bits = 8'b01000010;
            6: bits = 8'b00111100;
        endcase

        "H": case (row)
            0,1,2,4,5,6: bits = 8'b01000010;
            3: bits = 8'b01111110;
        endcase

        "I": case (row)
            0,6: bits = 8'b00111100;
            1,2,3,4,5: bits = 8'b00010000;
        endcase

        "J": case (row)
            0: bits = 8'b00011110;
            1,2,3: bits = 8'b00000100;
            4,5: bits = 8'b01000100;
            6: bits = 8'b00111000;
        endcase

        "K": case (row)
            0,1,2: bits = 8'b01000100;
            3:     bits = 8'b01111000;
            4,5,6: bits = 8'b01000100;
        endcase

        "L": case (row)
            0,1,2,3,4,5: bits = 8'b01000000;
            6: bits = 8'b01111110;
        endcase

        "M": case (row)
            0: bits = 8'b01000010;
            1: bits = 8'b01100110;
            2: bits = 8'b01011010;
            3,4,5,6: bits = 8'b01000010;
        endcase

        "N": case (row)
            0,1,6: bits = 8'b01000010;
            2,3: bits = 8'b01100010;
            4,5: bits = 8'b01011010;
        endcase

        "O": case (row)
            0,6: bits = 8'b00111100;
            1,2,3,4,5: bits = 8'b01000010;
        endcase
		  
        "P": case (row)
            0,3: bits = 8'b01111100;
            1,2: bits = 8'b01000010;
            4,5,6: bits = 8'b01000000;
        endcase

        "Q": case (row)
            0,5: bits = 8'b00111100;
            1,2,3,4: bits = 8'b01000010;
            6: bits = 8'b00111110;
        endcase

        "R": case (row)
            0,3: bits = 8'b01111100;
            1,2: bits = 8'b01000010;
            4,5,6: bits = 8'b01000100;
        endcase

        "S": case (row)
            0,3,6: bits = 8'b00111100;
            1,2: bits = 8'b01000000;
            4,5: bits = 8'b00000010;
        endcase

        "T": case (row)
            0: bits = 8'b01111110;
            1,2,3,4,5,6: bits = 8'b00010000;
        endcase

        "U": case (row)
            0,1,2,3,4,5: bits = 8'b01000010;
            6: bits = 8'b00111100;
        endcase

        "V": case (row)
            0,1,2,3,4: bits = 8'b01000010;
            5: bits = 8'b00100100;
            6: bits = 8'b00011000;
        endcase

        "W": case (row)
            0,1,6: bits = 8'b01000010;
            2,3: bits = 8'b01011010;
            4: bits = 8'b01100110;
        endcase
        "X": case (row)
            0,6: bits = 8'b01000010;
            1,5: bits = 8'b00100100;
            2,4: bits = 8'b00011000;
            3: bits = 8'b00011000;
        endcase

        "Y": case (row)
            0,1: bits = 8'b01000010;
            2,3,4,5,6: bits = 8'b00010000;
        endcase

        "Z": case (row)
            0,6: bits = 8'b01111110;
            1,2,3,4,5: bits = 8'b00000100;
        endcase

    endcase
end

endmodule
