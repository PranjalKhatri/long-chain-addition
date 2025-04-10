`timescale 1ns/1ps

module top_module_tb();
    // Testbench signals
    reg clk;
    reg rst;
    reg dataValid;
    reg [3:0] data_in;
    wire [6:0] sum;
    wire done;

    // Instantiate the top module
    top_module uut(
        .clk(clk),
        .rst(rst),
        .dataValid(dataValid),
        .data_in(data_in),
        .sum(sum),
        .done(done)
    );

    // Clock generation (50MHz)
    always #10 clk = ~clk;

    // Test data to load into memory
    reg [3:0] test_data [0:9];
    integer i;

    // Test procedure
    initial begin
        // Initialize signals
        clk = 0;
        rst = 1;
        dataValid = 0;
        data_in = 0;

        // Initialize test data
        test_data[0] = 4'd3;
        test_data[1] = 4'd5;
        test_data[2] = 4'd7;
        test_data[3] = 4'd2;
        test_data[4] = 4'd9;
        test_data[5] = 4'd1;
        test_data[6] = 4'd8;
        test_data[7] = 4'd4;
        test_data[8] = 4'd6;
        test_data[9] = 4'd0;

        // Apply reset
        #20 rst = 0;
        #40;

        // Load data into memory
        for (i = 0; i < 10; i = i + 1) begin
            // Assert dataValid and provide data
            dataValid = 1;
            data_in = test_data[i];
            repeat(2) @(posedge clk);  // Wait one clock cycle

            // De-assert dataValid
            dataValid = 0;
            repeat(2) @(posedge clk);  // Wait one clock cycle
            // #20;  // Wait one clock cycle
        end

        // Wait for computation to complete
        wait(done);
        #40;  // Additional cycles to see final result

        // Display results
        $display("Test completed! Final sum: %d", sum);
        
        // End simulation
        #100 $finish;
    end

    // Monitor signals
    initial begin
        $monitor("Time: %0t, State: %h, Data In: %d, Sum: %d, Done: %b dataValid: %b",
                 $time, uut.state, data_in, sum, done, dataValid);
    end

    // Dump waveforms
    initial begin
        $dumpfile("top_module_tb.vcd");
        $dumpvars(0, top_module_tb);
    end
    
endmodule