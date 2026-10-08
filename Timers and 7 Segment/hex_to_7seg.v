module hex_to_7seg (
    input  wire [3:0] hex,
    output reg  [6:0] seg
);
    // Standard active-LOW encoding: seg[6:0] = g f e d c b a
    // Used for HEX0 (ones digit) — standard pin order
    always @(*) begin
        case (hex)
            //              gfedcba
            0: seg = 7'b1000000;
            1: seg = 7'b1111001;
            2: seg = 7'b0100100;
            3: seg = 7'b0110000;
            4: seg = 7'b0011001;
            5: seg = 7'b0010010;
            6: seg = 7'b0000010;
            7: seg = 7'b1111000;
            8: seg = 7'b0000000;
            9: seg = 7'b0010000;
            default: seg = 7'b1111111;
        endcase
    end
endmodule