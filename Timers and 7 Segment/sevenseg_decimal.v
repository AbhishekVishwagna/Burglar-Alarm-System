module sevenseg_decimal (
    input  wire [5:0] value,
    output wire [6:0] HEX1,
    output wire [6:0] HEX0
);

    // Synthesisable BCD conversion — avoids divide/modulo by 10
    reg [3:0] tens;
    reg [3:0] ones;

    always @(*) begin
        if      (value >= 60) begin tens = 4'd6; ones = value - 6'd60; end
        else if (value >= 50) begin tens = 4'd5; ones = value - 6'd50; end
        else if (value >= 40) begin tens = 4'd4; ones = value - 6'd40; end
        else if (value >= 30) begin tens = 4'd3; ones = value - 6'd30; end
        else if (value >= 20) begin tens = 4'd2; ones = value - 6'd20; end
        else if (value >= 10) begin tens = 4'd1; ones = value - 6'd10; end
        else                  begin tens = 4'd0; ones = value[3:0];    end
    end

    // HEX1 (tens): d and e pins are physically swapped on this board
    hex_to_7seg_swapped d1 (.hex(tens), .seg(HEX1));

    // HEX0 (ones): standard pin order
    hex_to_7seg         d0 (.hex(ones), .seg(HEX0));

endmodule
