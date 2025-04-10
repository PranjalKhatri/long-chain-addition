`timescale 1ns/1ps
module datapath (
    input clk,
    input rst,
    input load,                 // signal to load input into reg bank
    // input [2:0] ptr,            // pointer to load into reg bank
    input accumulate,           // signal to run addition
    input [3:0] data_in,        // incoming 4-bit input
    output reg [6:0] result,
    output reg done
);

    reg [3:0] regs [0:7];       // Register bank for inputs
    reg [2:0] write_ptr;        // Pointer to write into reg bank
    reg [3:0] add_ptr;          // Pointer to read for summation
    reg [6:0] temp_sum;
    reg accumulating;
    // Ripple adder instantiation
    wire [6:0] adder_out;
    wire cout;
    reg [6:0] in_2;
    ripple_adder_7bit adder (
        .a(temp_sum),
        .b(in_2),
        .sum(adder_out),
        .cout(cout)
    );

    // always@(negedge load) begin
    //     $display("LOAD SIGNAL : %d", load);
    //     write_ptr <= write_ptr + 1;
    // end

    always @(posedge clk or posedge rst) begin
                $display("ACCUMULATE: SUM = %d, ADD_PTR = %d, VAL = %d,load= %b", temp_sum, add_ptr, regs[add_ptr],load);
        if (rst) begin
            write_ptr <= 0;
            add_ptr <= 0;
            temp_sum <= 0;
            result <= 0;
            in_2 <= 0;
            done <= 0;
            accumulating <= 0;
        end else begin
            if (load) begin
                $display("LOAD: WRITE_PTR = %d, VAL = %d", write_ptr, data_in);
                regs[write_ptr] <= data_in;
            end
            else if (accumulate) begin
                $display("ACCUMULATE: SUM = %d, ADD_PTR = %d, VAL = %d", temp_sum, add_ptr, regs[add_ptr]);
                // accumulating <= !accumulating;
                // if(accumulating) begin 
                //     add_ptr <= add_ptr + 1; 
                // end
                // else temp_sum <= adder_out;

                temp_sum <= adder_out;
                add_ptr <= add_ptr + 1;

                if (add_ptr == 3'd7) begin
                    result <= adder_out;
                    done <= 1;
                    temp_sum <= 0;
                end
                else begin
                    temp_sum <= adder_out;
                    in_2 <= regs[add_ptr];
                    add_ptr <= add_ptr + 1;
                end
            end
        end
    end

endmodule
