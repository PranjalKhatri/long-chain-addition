module top_module(
    input wire clk,
    input wire rst,
    input wire dataValid,
    input wire[3:0] data_in,
    output wire[6:0] sum,
    output wire done
);

    // Internal signals
    wire[3:0] state;
    wire dp_done;
    assign done = dp_done;
    // Instantiate controller
    controller ctrl(
        .clk(clk),
        .rst(rst),
        .dataValid(dataValid),
        .dp_done(dp_done),
        .state(state)
    );

    // Instantiate datapath
    datapath dp(
        .clk(clk),
        .rst(rst),
        .data_in(data_in),
        .state(state),
        .sum(sum),
        .dp_done(dp_done)
    );

endmodule