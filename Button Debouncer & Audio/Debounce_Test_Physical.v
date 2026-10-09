// for testing physical board button pressing

module Debounce_Test_Physical (
    input  wire CLOCK_50, 
    input  wire [0:0] KEY, 
    output wire [0:0] LED  
);

    Button_Debouncing #(
        .c_COUNT_LIMIT(500000) 
    ) my_debouncer (
        .i_Clk(CLOCK_50),
        .i_Rst(1'b0),      
        .i_data(KEY[0]),
        .o_data(LED[0])
    );

endmodule