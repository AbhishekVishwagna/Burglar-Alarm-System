/* ============================================================================
 * timer_controller.v – Timer Controller for Burglar Alarm System
 *
 * Author: Abhishek
 *
 * Description:
 * Handles all timer behaviour based on system state.
 * Controls counting, display output, and done signals.
 *
 * Operation:
 * - TRIGGERED  : counts up (alarm active time)
 * - PIN_ENTRY  : counts down from 60 seconds
 * - LOCKOUT    : counts down from 30 seconds
 *
* ============================================================================ */

module timer_controller (
    input  wire        clock,
    input  wire        reset,
    input  wire [2:0]  state_in,

    output reg         trigger_timer_done,
    output reg         pin_timer_done,
    output reg         lockout_done,

    output wire [6:0]  HEX1,
    output wire [6:0]  HEX0
);

//  STATE DEFINITIONS
localparam [2:0]
    IDLE       = 3'b000,
    ARMED      = 3'b001,
    TRIGGERED  = 3'b010,
    PIN_ENTRY  = 3'b011,
    ST_SUCCESS = 3'b100,
    LOCKOUT    = 3'b101;

// TIMER LIMITS
localparam [5:0]
    TRIGGER_LIMIT = 6'd5,
    PIN_LIMIT     = 6'd60,
    LOCKOUT_LIMIT = 6'd30;

// CLOCK
wire tick_1s;
clock_divider_1s u_div (.clock(clock), .reset(reset), .tick_1s(tick_1s));

// STATE CHANGE DETECTION
reg [2:0] prev_state;
always @(posedge clock or posedge reset) begin
    if (reset) prev_state <= IDLE;
    else       prev_state <= state_in;
end
wire state_changed = (state_in != prev_state);

// ALARM_TIMER
reg  [5:0] load_value_r;
reg        load_r;
reg        enable_r;
wire [5:0] timer_value;

alarm_timer u_timer (
    .clock(clock),   .reset(reset),
    .tick_1s(tick_1s), .enable(enable_r),
    .load(load_r),   .load_value(load_value_r),
    .value(timer_value)
);

//Count-up for TRIGGERED display 
reg [5:0] up_count;

// Display value
reg [5:0] disp_value;

// Done-fired latches 
// Prevent re-firing once a pulse has been sent for this state entry.
reg trigger_done_fired;
reg pin_done_fired;
reg lockout_done_fired;

// Has-been-loaded flags
// Set the first time timer_value > 0 after state entry.
// Cleared on state entry. Ensures the load pipeline has propagated
// before the done check is allowed to evaluate timer_value == 0.
reg trigger_loaded;
reg pin_loaded;
reg lockout_loaded;

// Main sequential logic
always @(posedge clock or posedge reset) begin
    if (reset) begin
        load_r             <= 1'b0;
        enable_r           <= 1'b0;
        load_value_r       <= 6'd0;
        trigger_timer_done <= 1'b0;
        pin_timer_done     <= 1'b0;
        lockout_done       <= 1'b0;
        up_count           <= 6'd0;
        disp_value         <= 6'd0;
        trigger_done_fired <= 1'b0;
        pin_done_fired     <= 1'b0;
        lockout_done_fired <= 1'b0;
        trigger_loaded     <= 1'b0;
        pin_loaded         <= 1'b0;
        lockout_loaded     <= 1'b0;
    end else begin

        // Deassert one-cycle outputs by default
        trigger_timer_done <= 1'b0;
        pin_timer_done     <= 1'b0;
        lockout_done       <= 1'b0;
        load_r             <= 1'b0;

        case (state_in)

            //TRIGGERED
            // HEX  : counts up (seconds alarm has been active)
            // Timer: counts down 5 s → trigger_timer_done
            TRIGGERED: begin
                enable_r <= 1'b1;

                if (state_changed) begin
                    load_value_r       <= TRIGGER_LIMIT;
                    load_r             <= 1'b1;
                    up_count           <= 6'd0;
                    trigger_done_fired <= 1'b0;
                    trigger_loaded     <= 1'b0;
                end

                // Set loaded flag once the timer shows a non-zero value
                if (timer_value > 6'd0)
                    trigger_loaded <= 1'b1;

                if (tick_1s && up_count < 6'd63)
                    up_count <= up_count + 6'd1;

                disp_value <= up_count;

                // Three guards — ALL must be true to fire:
                //   !state_changed  : blocks entry cycle (stale-read race)
                //   trigger_loaded  : blocks until load pipeline propagates
                //   !done_fired     : fires exactly once per state entry
                if (!state_changed && trigger_loaded &&
                    timer_value == 6'd0 && !trigger_done_fired) begin
                    trigger_timer_done <= 1'b1;
                    trigger_done_fired <= 1'b1;
                end
            end

            // PIN_ENTRY
            // HEX  : counts down from 60 (seconds remaining to enter PIN)
            // Timer: fires pin_timer_done at 0
            PIN_ENTRY: begin
                enable_r <= 1'b1;

                if (state_changed) begin
                    load_value_r   <= PIN_LIMIT;
                    load_r         <= 1'b1;
                    pin_done_fired <= 1'b0;
                    pin_loaded     <= 1'b0;
                end

                if (timer_value > 6'd0)
                    pin_loaded <= 1'b1;

                disp_value <= timer_value;

                if (!state_changed && pin_loaded &&
                    timer_value == 6'd0 && !pin_done_fired) begin
                    pin_timer_done <= 1'b1;
                    pin_done_fired <= 1'b1;
                end
            end

            // LOCKOUT
            // HEX  : counts down from 30 (seconds until system resets)
            // Timer: fires lockout_done at 0
            LOCKOUT: begin
                enable_r <= 1'b1;

                if (state_changed) begin
                    load_value_r       <= LOCKOUT_LIMIT;
                    load_r             <= 1'b1;
                    lockout_done_fired <= 1'b0;
                    lockout_loaded     <= 1'b0;
                end

                if (timer_value > 6'd0)
                    lockout_loaded <= 1'b1;

                disp_value <= timer_value;

                if (!state_changed && lockout_loaded &&
                    timer_value == 6'd0 && !lockout_done_fired) begin
                    lockout_done       <= 1'b1;
                    lockout_done_fired <= 1'b1;
                end
            end

            //IDLE / ARMED / SUCCESS: display "00", timer idle
            default: begin
                enable_r   <= 1'b0;
                disp_value <= 6'd0;
            end

        endcase
    end
end

// 7-segment display
sevenseg_decimal u_seg (.value(disp_value), .HEX1(HEX1), .HEX0(HEX0));

endmodule
