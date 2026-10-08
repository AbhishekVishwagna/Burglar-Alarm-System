`timescale 1ns/1ps

module timer_controller_tb;

reg clock;
reg reset;
reg [2:0] state_in;

wire trigger_timer_done;
wire pin_timer_done;
wire lockout_done;

wire [6:0] HEX1;
wire [6:0] HEX0;

// DUT
timer_controller uut (
    .clock(clock),
    .reset(reset),
    .state_in(state_in),
    .trigger_timer_done(trigger_timer_done),
    .pin_timer_done(pin_timer_done),
    .lockout_done(lockout_done),
    .HEX1(HEX1),
    .HEX0(HEX0)
);

// clock
initial clock = 0;
always #10 clock = ~clock;

// test sequence
initial begin

    // RESET
    reset = 1;
    state_in = 3'b000;
    #50;
    reset = 0;

    // TRIGGERED
    $display("TRIGGERED STATE");
    state_in = 3'b010;
    #2000;

    // PIN ENTRY
    $display("PIN ENTRY STATE");
    state_in = 3'b011;
    #4000;

    // LOCKOUT
    $display("LOCKOUT STATE");
    state_in = 3'b101;
    #3000;

    $display("Simulation done");
    $stop;

end

endmodule