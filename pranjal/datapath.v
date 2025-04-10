module datapath(
    input wire clk,
    input wire rst,
    input wire[3:0] data_in,
    input wire[3:0] state,
    output reg[6:0] sum,
    output reg dp_done    // Changed from wire to reg since we're assigning to it
);

parameter S_IDLE = 4'b0000;
parameter S_LOAD_1 = 4'b0001;
parameter S_LOAD_2 = 4'b0010;
parameter S_LOAD_3 = 4'b0011;
parameter S_RUN = 4'b0100;
parameter S_RUN_IS = 4'b0101;
parameter S_DONE = 4'b0110;

reg [3:0] run_ptr, mem_ptr;
reg [3:0] mem[10:0];
reg [6:0] in1, in2;
reg [6:0] temp_sum;

// Use wire for adder outputs
wire [6:0] adder_sum;
wire adder_cout;

ripple_adder_7bit adder(
    .a(in1),
    .b(in2),
    .sum(adder_sum),    // Connect to wire
    .cout(adder_cout)   // Connect to wire
);

initial begin
    run_ptr = 0;
    mem_ptr = 0;
    dp_done = 0;
    temp_sum = 0;
    in1 = 0;
    in2 = 0;
    sum = 0;
end

always @(posedge rst) begin
    run_ptr = 0;
    mem_ptr = 0;
    dp_done = 0;
    temp_sum = 0;
    in1 = 0;
    in2 = 0;
    sum = 0;
end

always @(posedge clk) begin
    case(state)
        S_LOAD_2: begin
            $display("loading in memory at %d, data : %d",mem_ptr,data_in);
           mem[mem_ptr] <= data_in;
           mem_ptr <= mem_ptr + 1;
        end
        S_RUN: begin
           if(run_ptr === 4'b0111) begin
                dp_done <= 1;
                temp_sum <= adder_sum;  // Use adder_sum instead of out
           end  
           else begin
                temp_sum <= adder_sum;  // Use adder_sum instead of out
           end
           #1 $display("running at %d, data : %d,temp_sum : %d",run_ptr,mem[run_ptr],temp_sum);
        end
        S_RUN_IS: begin
            $display("in runis");
            in1 <= temp_sum;            // Fixed order (was assigning to in1 twice)
            in2 <= mem[run_ptr];        // Use the current value from memory
            run_ptr <= run_ptr + 1;
        end
        S_DONE: begin
            $display("out %d", temp_sum);  // Use adder_sum instead of out
            sum <= temp_sum;               // Use adder_sum instead of out
        end
    endcase
end

endmodule