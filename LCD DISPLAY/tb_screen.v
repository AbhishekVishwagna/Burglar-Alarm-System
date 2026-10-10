`timescale 1ns / 1ps
// To the test the Screens pixel by pixel. (Not to test system behaviuor)
module tb_screen;

    reg  [7:0]  x;          // X pixel coordinate (0–239)
    reg  [8:0]  y;          // Y pixel coordinate (0–319)
    reg  [23:0] flash_cnt;  // Timing input (used by some screens)
    wire [15:0] pixel;      // Pixel colour output

    // DUT (Device Under Test) Change the module to test other screens
    alarm_screen DUT (
        .x(x),
        .y(y),
        .pixel(pixel)
    );

    // Pixel scan
    initial begin
        // Initialise signals
        x = 0;
        y = 0;
        flash_cnt = 0;

        // Simulate full LCD scan (240 × 320)
        for (y = 0; y < 320; y = y + 1) begin
            for (x = 0; x < 240; x = x + 1) begin
                #10;    // allow combinational logic to settle
            end
        end

        $display("Screen test completed.");
        $stop;
    end
    //used only if screen has flash_cnt
    always #5 flash_cnt = flash_cnt + 1;

endmodule