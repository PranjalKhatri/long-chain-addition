`timescale 1ns/1ps

module tb_top;

    reg clk = 0;
    reg rst;
    reg data_valid;
    reg [3:0] data_in;
    wire [6:0] result;
    wire done;

    top uut (
        .clk(clk),
        .rst(rst),
        .data_valid(data_valid),
        .data_in(data_in),
        .result(result),
        .done(done)
    );

    // Clock generation
    always #5 clk = ~clk;

    reg [3:0] input_array [0:7];
    integer i;

    // always@(posedge clk) begin
    //     if(data_valid)
    //         $display("CLK = %d, RST = %d, DATA_VALID = %d, DATA_IN = %d", $time, rst, data_valid, data_in);
    //     // else 
    //         // $display("CLK = %d, RST = %d, DONE = %d", $time, rst, data_valid, done);
    // end

    initial begin
        // Setup 8 inputs (sum should be visible in result)
        input_array[0] = 4'd3;
        input_array[1] = 4'd4;
        input_array[2] = 4'd5;
        input_array[3] = 4'd6;
        input_array[4] = 4'd7;
        input_array[5] = 4'd8;
        input_array[6] = 4'd9;
        input_array[7] = 4'd10;

        // Initialize
        rst = 1; data_valid = 0; data_in = 0;
        #15 rst = 0;

        // Feed 8 inputs
        for (i = 0; i < 8; i = i + 1) begin
            @(negedge clk);
            data_in = input_array[i];
            data_valid = 1;
            repeat(2) @(negedge clk);
            @(negedge clk);
            data_valid = 0;
            repeat(2) @(negedge clk); // simulate data_valid spacing
        end

        repeat (10) @(posedge clk); // give time for FSM to accumulate
        // Wait for result
        wait (done);
        $display("SUM = %d", result);

        #20 $finish;
    end

endmodule
