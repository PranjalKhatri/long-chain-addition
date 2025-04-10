`timescale 1ns/1ps
module top (
    input clk,
    input rst,
    input data_valid,
    input [3:0] data_in,
    output [6:0] result,
    output done
);

    wire load, accumulate;
    wire done_wire;
    assign done_wire = done;

    controller u_controller (
        .clk(clk),
        .rst(rst),
        .data_valid(data_valid),
        .done(done_wire),
        .load(load),
        .accumulate(accumulate)
    );

    datapath u_datapath (
        .clk(clk),
        .rst(rst),
        .load(load),
        .accumulate(accumulate),
        .data_in(data_in),
        .result(result),
        .done(done)
    );

endmodule