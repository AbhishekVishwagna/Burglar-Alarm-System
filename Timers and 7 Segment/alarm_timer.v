/* ============================================================================
 * alarm_timer.v – Alarm timer for Burglar Alarm System
 *
 * Author: Abhishek
 *
 * Description:
 * Handles all timer behaviour based on system state.
 * Controls counting, display output, and done signals.
 *
* ============================================================================ */

module alarm_timer (
    input  wire clock,
    input  wire reset,
    input  wire tick_1s,

    input  wire enable,
    input  wire load,
    input  wire [5:0] load_value,

    output reg [5:0] value
);

    always @(posedge clock or posedge reset) begin
        if (reset)
            value <= 6'd0;
        else if (load)
            value <= load_value;
        else if (enable && tick_1s && value > 0)
            value <= value - 1;
    end

endmodule