
module clock_divider_1s (
    input  wire clock,
    input  wire reset,
    output reg  tick_1s
);

    localparam COUNT_MAX = 50_000_000 - 1;
    reg [25:0] count;

    always @(posedge clock or posedge reset) begin
        if (reset) begin
            count   <= 0;
            tick_1s <= 0;
        end else if (count == COUNT_MAX) begin
            count   <= 0;
            tick_1s <= 1;
        end else begin
            count   <= count + 1;
            tick_1s <= 0;
        end
    end
endmodule
