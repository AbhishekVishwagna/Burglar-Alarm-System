`timescale 1ns/1ps

module audio_tb();
    reg i_Clk;
    reg i_Rst_n;
    reg [2:0] i_State;
    reg i_Btn_Tick;
    wire o_Speaker;

    
    audio uut (
        .i_Clk(i_Clk),
        .i_Rst_n(i_Rst_n),
        .i_State(i_State),
        .i_Btn_Tick(i_Btn_Tick),
        .o_Speaker(o_Speaker)
    );

    
    always #10 i_Clk = ~i_Clk;

    initial begin
        i_Clk = 0;
        i_Rst_n = 0;
        i_State = 3'b000; //DISARMED
        i_Btn_Tick = 0;

        #100;
        i_Rst_n = 1;
        #20;

        //test TRIGGERED state (3'b010)
        $display("Testing TRIGGERED State...");
        i_State = 3'b010;
        #1000000; //run simulation long enough to see speaker toggle

        //test LOCKOUT state (3'b101)
        $display("Testing LOCKOUT State...");
        i_State = 3'b101;
        #1000000;

        //test DISARMED state (No sound)
        $display("Testing DISARMED State...");
        i_State = 3'b000;
        #100000;

        $stop;
    end
endmodule