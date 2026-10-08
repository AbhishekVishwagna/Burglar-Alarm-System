module timer_demo_top (
    input wire CLOCK_50,
    input wire [3:0] KEY,
    output wire [6:0] HEX1,
    output wire [6:0] HEX0,
    output wire [9:0] LEDR,
    output wire [6:0] HEX2,
    output wire [6:0] HEX3,
    output wire [6:0] HEX4,
    output wire [6:0] HEX5
);

    wire reset = ~KEY[0];

    // 1-second tick
    wire tick_1s;
    clock_divider_1s div (
        .clock(CLOCK_50),
        .reset(reset),
        .tick_1s(tick_1s)
    );

    reg [5:0] value;
    reg run;

    // edge detect for KEY1
    reg prev_k1;

    always @(posedge CLOCK_50 or posedge reset) begin
        if (reset) begin
            run <= 0;
            prev_k1 <= 1;
            value <= 6'd30;
        end 
        else begin
            prev_k1 <= KEY[1];

            // toggle start/pause
            if (prev_k1 && ~KEY[1])
                run <= ~run;

            // countdown
            if (run && tick_1s) begin
                if (value > 0)
                    value <= value - 1;
                else
                    run <= 0;
            end
        end
    end

    // display
    sevenseg_decimal disp (
        .value(value),
        .HEX1(HEX1),
        .HEX0(HEX0)
    );

    // turn off unused displays
    assign HEX2 = 7'b1111111;
    assign HEX3 = 7'b1111111;
    assign HEX4 = 7'b1111111;
    assign HEX5 = 7'b1111111;

    // blink generator
    reg blink;

    always @(posedge CLOCK_50 or posedge reset) begin
        if (reset)
            blink <= 0;
        else if (tick_1s)
            blink <= ~blink;
    end

    // LED logic
    assign LEDR = (value == 0) ?
                  (blink ? 10'b1111111111 : 10'b0000000000) :
                  (run ? 10'b1111111111 : 10'b0000000000);

endmodule