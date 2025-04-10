`timescale 1ns/1ps
module top (
    input clk,
    input rst,
    input data_valid,
    input [3:0] data_in,
    output [6:0] result,
    output done,
    output reg [7:0] an,         // Anode signals for 8 displays
    output reg [6:0] a_to_g
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
 seven_segment_display u_seven_segment_display (
    .clk(clk),                // Connect the 100 MHz clock
    .reset(rst),            // Connect the reset signal
    .number1(result),        // Connect the first input number (0-31)
    .number2(0),        // Connect the second input number (0-31)
    .an(an),                  // Connect the anode signals (8 displays)
    .a_to_g(a_to_g)           // Connect the cathode signals (7 segments)
    );


endmodule
