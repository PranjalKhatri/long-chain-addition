`timescale 1ns / 1ps

module pipelined_tb;
    // Parameters
    parameter INPUT_SIZE = 4;
    parameter CLK_PERIOD = 10; // Clock period in ns
    
    // Inputs
    reg main_clk;
    reg [INPUT_SIZE-1:0] a, b, c, d, e, f, g, h;
    
    // Outputs
    wire [INPUT_SIZE+2:0] result;
    
    // Expected results for verification
    reg [INPUT_SIZE+2:0] expected_result;
    
    // Counter for clock cycles
    integer cycle_count = 0;
    
    // Instantiate the Unit Under Test (UUT)
    pipelined #(INPUT_SIZE) uut (
        .main_clk(main_clk),
        .a(a), .b(b), .c(c), .d(d), .e(e), .f(f), .g(g), .h(h),
        .result(result)
    );
    
    // Clock generation
    initial begin
        main_clk = 0;
        forever #(CLK_PERIOD/2) main_clk = ~main_clk;
    end
    
    // Test case management
    reg [INPUT_SIZE-1:0] test_inputs [0:7][0:2]; // [input_index][test_case]
    reg [INPUT_SIZE+2:0] test_expected [0:2];    // Expected results for each test case
    integer current_test = 0;                    // Current test case
    integer num_tests = 3;                       // Total number of test cases
    
    // Initialize test cases
    initial begin
        // Test case 1: All ones
        test_inputs[0][0] = 4'h1; test_inputs[1][0] = 4'h1; 
        test_inputs[2][0] = 4'h1; test_inputs[3][0] = 4'h1;
        test_inputs[4][0] = 4'h1; test_inputs[5][0] = 4'h1; 
        test_inputs[6][0] = 4'h1; test_inputs[7][0] = 4'h1;
        test_expected[0] = 8;     // 1+1+1+1+1+1+1+1 = 8
        
        // Test case 2: Increasing values
        test_inputs[0][1] = 4'h1; test_inputs[1][1] = 4'h2;
        test_inputs[2][1] = 4'h3; test_inputs[3][1] = 4'h4;
        test_inputs[4][1] = 4'h5; test_inputs[5][1] = 4'h6;
        test_inputs[6][1] = 4'h7; test_inputs[7][1] = 4'h8;
        test_expected[1] = 36;    // 1+2+3+4+5+6+7+8 = 36
        
        // Test case 3: Maximum values
        test_inputs[0][2] = 4'hF; test_inputs[1][2] = 4'hF;
        test_inputs[2][2] = 4'hF; test_inputs[3][2] = 4'hF;
        test_inputs[4][2] = 4'hF; test_inputs[5][2] = 4'hF;
        test_inputs[6][2] = 4'hF; test_inputs[7][2] = 4'hF;
        test_expected[2] = 120;   // 15+15+15+15+15+15+15+15 = 120
    end
    
    // Test sequence
    initial begin
        // Initialize inputs
        a = 0; b = 0; c = 0; d = 0; e = 0; f = 0; g = 0; h = 0;
        
        // Wait for global reset
        #(CLK_PERIOD*2);
        
        // Run through all test cases
        for (current_test = 0; current_test < num_tests; current_test = current_test + 1) begin
            // Load the test inputs
            a = test_inputs[0][current_test];
            b = test_inputs[1][current_test];
            c = test_inputs[2][current_test];
            d = test_inputs[3][current_test];
            e = test_inputs[4][current_test];
            f = test_inputs[5][current_test];
            g = test_inputs[6][current_test];
            h = test_inputs[7][current_test];
            
            // Calculate expected result
            expected_result = test_expected[current_test];
            
            // Wait 7 clock cycles for the pipeline to fill (result will be ready on the 8th cycle)
            cycle_count = 0;
            while (cycle_count < 8) begin
                @(posedge main_clk);
                cycle_count = cycle_count + 1;
            end
            
            // Check result
            if (result !== expected_result) begin
                $display("Test %0d FAILED: Expected %0d, got %0d", 
                         current_test+1, expected_result, result);
            end else begin
                $display("Test %0d PASSED: Result = %0d", 
                         current_test+1, result);
            end
            
            // Wait a few extra cycles between tests
            #(CLK_PERIOD*2);
        end
        
        // Additional test: Continuous operation with changing inputs
        $display("\nStarting continuous operation test...");
        
        // Send test case 1
        a = test_inputs[0][0]; b = test_inputs[1][0];
        c = test_inputs[2][0]; d = test_inputs[3][0];
        e = test_inputs[4][0]; f = test_inputs[5][0];
        g = test_inputs[6][0]; h = test_inputs[7][0];
        @(posedge main_clk);
        
        // Send test case 2
        a = test_inputs[0][1]; b = test_inputs[1][1];
        c = test_inputs[2][1]; d = test_inputs[3][1];
        e = test_inputs[4][1]; f = test_inputs[5][1];
        g = test_inputs[6][1]; h = test_inputs[7][1];
        @(posedge main_clk);
        
        // Send test case 3
        a = test_inputs[0][2]; b = test_inputs[1][2];
        c = test_inputs[2][2]; d = test_inputs[3][2];
        e = test_inputs[4][2]; f = test_inputs[5][2];
        g = test_inputs[6][2]; h = test_inputs[7][2];
        @(posedge main_clk);
        
        // Wait for results to propagate through pipeline
        #(CLK_PERIOD*8);
        
        $display("Continuous operation test complete");
        $display("Note: You should see test results come out in order after 8 clock cycles");
        
        // End simulation
        #(CLK_PERIOD*5);
        $display("All tests completed");
        $finish;
    end
    
    // Monitor pipeline output
    initial begin
        $monitor("Time=%0t, Cycle=%0d, Result=%0d", 
                 $time, cycle_count, result);
    end

endmodule