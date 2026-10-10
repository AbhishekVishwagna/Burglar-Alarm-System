module lcd_display (
    input  wire        clock,          // 50 MHz
    input  wire        globalReset,     // active-high
    input  wire [3:0]  KEY,             // push buttons (active-low)

    // LT24 physical interface
    output wire LT24Wr_n,
    output wire LT24Rd_n,
    output wire LT24CS_n,
    output wire LT24RS,
    output wire LT24Reset_n,
    output wire [15:0] LT24Data,
    output wire LT24LCDOn
);

    // LT24 interface
    wire resetApp;

    reg  [7:0]  xAddr;      // 0..239
    reg  [8:0]  yAddr;      // 0..319
    reg  [15:0] pixelData;
    reg         pixelWrite;
    wire        pixelReady;

    LT24Display #(
        .WIDTH(240),
        .HEIGHT(320),
        .CLOCK_FREQ(50000000)
    ) lcd (
        .clock        (clock),
        .globalReset  (globalReset),
        .resetApp     (resetApp),

        .xAddr        (xAddr),
        .yAddr        (yAddr),
        .pixelData    (pixelData),
        .pixelWrite   (pixelWrite),
        .pixelReady   (pixelReady),
        .pixelRawMode (1'b0),

        .cmdData      (8'b0),
        .cmdWrite     (1'b0),
        .cmdDone      (1'b0),
        .cmdReady     (),

        .LT24Wr_n     (LT24Wr_n),
        .LT24Rd_n     (LT24Rd_n),
        .LT24CS_n     (LT24CS_n),
        .LT24RS       (LT24RS),
        .LT24Reset_n  (LT24Reset_n),
        .LT24Data     (LT24Data),
        .LT24LCDOn    (LT24LCDOn)
    );

    // Screen states
    localparam SCREEN_LOCKED   = 2'd0;
    localparam SCREEN_UNLOCKED = 2'd1;
    localparam SCREEN_ALARM    = 2'd2;

    reg [1:0] screen;

    always @(posedge clock or posedge resetApp) begin
        if (resetApp)
            screen <= SCREEN_LOCKED;
        else begin
            if (!KEY[0])      screen <= SCREEN_LOCKED;
            else if (!KEY[1]) screen <= SCREEN_UNLOCKED;
            else if (!KEY[2]) screen <= SCREEN_ALARM;
        end
    end

    // Colors (RGB565)
    localparam RED    = 16'hF800;
    localparam GREEN  = 16'h07E0;
    localparam WHITE  = 16'hFFFF;
    localparam BLACK  = 16'h0000;

    // Alarm blink generator
    reg [24:0] blink_cnt;
    always @(posedge clock or posedge resetApp) begin
        if (resetApp) blink_cnt <= 0;
        else blink_cnt <= blink_cnt + 1;
    end
    wire alarm_on = blink_cnt[24];

    // Padlock placement
    localparam PAD_X_START = 88;
    localparam PAD_Y_START = 128;
    localparam PAD_SIZE    = 64;

    wire in_padlock_area =
        (xAddr >= PAD_X_START) &&
        (xAddr < PAD_X_START + PAD_SIZE) &&
        (yAddr >= PAD_Y_START) &&
        (yAddr < PAD_Y_START + PAD_SIZE);

    wire [11:0] padlock_addr =
        (yAddr - PAD_Y_START) * PAD_SIZE +
        (xAddr - PAD_X_START);

    wire padlock_pixel;

    padlock_rom u_padlock (
        .addr(padlock_addr),
        .pixel_on(padlock_pixel)
    );

    // Pixel generation & scanning
    always @(posedge clock or posedge resetApp) begin
        if (resetApp) begin
            xAddr      <= 0;
            yAddr      <= 0;
            pixelWrite <= 0;
            pixelData  <= BLACK;
        end else begin
            pixelWrite <= 1'b1;

            if (pixelReady) begin
                case (screen)

                    // LOCKED
                    SCREEN_LOCKED: begin
                        pixelData <= RED;
                        if (in_padlock_area && padlock_pixel)
                            pixelData <= WHITE;
                    end

                    //UNLOCKED
                    SCREEN_UNLOCKED: begin
                        pixelData <= GREEN;
                    end

                    //  ALARM
                    SCREEN_ALARM: begin
                        pixelData <= (alarm_on ? RED : BLACK);
                    end

                    default: pixelData <= BLACK;
                endcase

                // next pixel
                if (xAddr == 239) begin
                    xAddr <= 0;
                    if (yAddr == 319)
                        yAddr <= 0;
                    else
                        yAddr <= yAddr + 1;
                end else begin
                    xAddr <= xAddr + 1;
                end
            end
        end
    end

endmodule

// Padlock graphic (procedural, 64×64)

module padlock_rom (
    input  wire [11:0] addr,
    output reg         pixel_on
);
    wire [5:0] x = addr[5:0];
    wire [5:0] y = addr[11:6];

    always @(*) begin
        pixel_on = 1'b0;

        // Lock body
        if (x > 16 && x < 48 && y > 28 && y < 56)
            pixel_on = 1'b1;

        // Shackle
        if ((x > 20 && x < 44 && y > 10 && y < 28) &&
            !((x > 26 && x < 38 && y > 14)))
            pixel_on = 1'b1;
    end
endmodule