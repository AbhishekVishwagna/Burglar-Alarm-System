/* ============================================================================
 * audio.v – Audio for Burglar Alarm System
 *
 * Author: Abhishek
 *
 * Description:
 * Handles the audio behaviour on system.
 *
* ============================================================================ */

module audio (
    input  wire i_Clk,      
    input  wire i_Rst_n,
    input  wire [2:0] i_State,
    input  wire i_Btn_Tick,  //short pulse from router
    output reg  o_Speaker    //connect to GPIO pin for buzzer
);

    reg [16:0] r_tone_count;
    reg [24:0] r_siren_timer;
    
    //frequencies: 1kHz and 1.5kHz
    wire [16:0] w_tone_limit = (r_siren_timer[24]) ? 17'd50000 : 17'd33333;

    always @(posedge i_Clk) begin
        if (!i_Rst_n) begin
            o_Speaker <= 1'b0;
            r_tone_count <= 0;
            r_siren_timer <= 0;
        end else begin
            r_siren_timer <= r_siren_timer + 1'b1;
            
            //generate siren for TRIGGERED (3'b010) or LOCKOUT (3'b101)
            if (i_State == 3'b010 || i_State == 3'b101) begin
                if (r_tone_count >= w_tone_limit) begin
                    o_Speaker <= ~o_Speaker;
                    r_tone_count <= 0;
                end else begin
                    r_tone_count <= r_tone_count + 1'b1;
                end
            end else begin
                o_Speaker <= 1'b0;
                r_tone_count <= 0;
            end
        end
    end
endmodule
