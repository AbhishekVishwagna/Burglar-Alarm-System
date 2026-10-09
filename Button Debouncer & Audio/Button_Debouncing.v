/* ============================================================================
 * Button_Debouncing.v – Button debouncing logic for Burglar Alarm System
 *
 * Author: Abhishek
 *
 * Description:
 * Handles the button debouncing behaviour on system for all the buttons used.
 *
* ============================================================================ */

module Button_Debouncing (
    

    input  wire i_Clk,
    input  wire i_Rst, 
    input  wire i_data,
    output wire o_data
);
	parameter c_COUNT_LIMIT = 500000; //10ms at 50MHz
    reg [18:0] r_counter;
    reg r_filtered_data;

    always @(posedge i_Clk) begin
        if (i_Rst) begin
            
            r_counter <= 19'd0;
            r_filtered_data <= 1'b0;
        end else begin
            
            if (i_data != r_filtered_data && r_counter < c_COUNT_LIMIT) begin
                r_counter <= r_counter + 19'd1;
            end else if (r_counter == c_COUNT_LIMIT) begin
                r_filtered_data <= i_data;
                r_counter <= 19'd0;
            end else begin
                r_counter <= 19'd0;
            end
        end
    end

    assign o_data = r_filtered_data;

endmodule