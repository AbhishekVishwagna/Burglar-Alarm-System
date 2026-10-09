`timescale 1ns/1ps

module Button_Debouncing_tb();
    reg i_Clk;
    reg i_Rst;
    reg i_data;
    wire o_data;

    //overriding parameter to a smaller value for faster simulation
    Button_Debouncing #(
        .c_COUNT_LIMIT(10) 
    ) uut (
        .i_Clk(i_Clk),
        .i_Rst(i_Rst),
        .i_data(i_data),
        .o_data(o_data)
    );

    
    always #10 i_Clk = ~i_Clk;

    initial begin
        
        i_Clk = 0;
        i_Rst = 1;
        i_data = 0;

        
        #100;
        i_Rst = 0;
        #20;

        //simulate Noise (Rapid toggling)
        i_data = 1; #40;
        i_data = 0; #40;
        i_data = 1; #40;
        i_data = 0; #40;

        //simulate stable button press (Longer than c_COUNT_LIMIT)
        i_data = 1; 
        #500; //o_data should go high after count limit

        //testing stable release
        i_data = 0;
        #500;

        $stop;
    end
endmodule