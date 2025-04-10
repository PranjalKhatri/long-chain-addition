`timescale 1ns/1ps
module controller (
    input wire clk,
    input wire rst,
    input wire data_valid,
    input wire done,      // externally asserted per input
    output reg load,
    // ouput reg [2:0] ptr,
    output reg accumulate
);

    reg [3:0] count;
    parameter IDLE = 3'd0,
        LOAD_1 = 3'd1,
        LOAD_2 = 3'd2,
        ACCUM = 3'd3,
        DONE  = 3'd4;
    reg [2:0] state, next;

    always @(posedge clk or posedge rst) begin
        if (rst)begin
            state <= IDLE;
            load = 0;
            accumulate = 0;
        end
        else
            state <= next;
    end

    always @(posedge clk) begin
        $display("CLK = %d, RST = %d, DATA_VALID = %d, LOAD = %d, STATE = %d, COUNT = %d, DONE = %d", $time, rst, data_valid, load, state, count, done);
        // load = 0;
        // accumulate = 0;
        case (state)
            IDLE: next = (!rst) ? LOAD_1 : IDLE;
            LOAD_1: next = (count >= 8) ? ACCUM : (data_valid) ? LOAD_2 : LOAD_1;
            LOAD_2: next = (data_valid) ? LOAD_2 : LOAD_1;
            ACCUM: next = (done) ? DONE : ACCUM;
            DONE: next = IDLE;
            default: next = IDLE;
        endcase
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            count <= 0;
            load <= 0;
            accumulate <= 0;
        end
        else begin
            case (state)
                LOAD_1: begin
                    if (data_valid) begin
                        load <= 1;
                        count <= count + 1;
                    end
                end
                LOAD_2: begin
                    load <= 0;
                end
                ACCUM: begin
                    accumulate <= 1;
                    load <= 0;
                    // count <= count + 1;
                end
                DONE: count <= 0;
            endcase
        end
    end

endmodule
