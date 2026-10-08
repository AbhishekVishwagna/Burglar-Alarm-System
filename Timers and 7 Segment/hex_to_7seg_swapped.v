module hex_to_7seg_swapped (
    input  wire [3:0] hex,
    output reg  [6:0] seg
);

    always @(*) begin
        case (hex)
            //              gfedcba
            0: seg = 7'b1000000;
            1: seg = 7'b1111001;
            2: seg = 7'b0100100;
            3: seg = 7'b0101000;  // bits 3,4 swapped
            4: seg = 7'b0011001;
            5: seg = 7'b0001010;  // bits 3,4 swapped
            6: seg = 7'b0000010;
            7: seg = 7'b1111000;
            8: seg = 7'b0000000;
            9: seg = 7'b0001000;  // bits 3,4 swapped
            default: seg = 7'b1111111;
        endcase
    end
endmodule
