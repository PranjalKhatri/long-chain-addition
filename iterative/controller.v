module controller (
    input wire clk,
    input wire rst,
    input wire data_valid,
    input wire ready,      // externally asserted per input
    output reg load,
    ouput reg [2:0] ptr,
    output reg accumulate
);

    reg [3:0] count;
    typedef enum reg [2:0] {IDLE, LOAD_1, LOAD_2, ACCUM, DONE} state_t;
    state_t state, next;

    always @(posedge clk or posedge rst) begin
        if (rst)
            state <= IDLE;
        else
            state <= next;
    end

    always @(*) begin
        load = 0;
        accumulate = 0;
        case (state)
            IDLE: next = (!rst) ? LOAD : IDLE;
            LOAD_1: next = (count == 8) ? ACCUM : LOAD_2;
            LOAD_2: next = (data_valid) ? LOAD_2 : LOAD_1;
            ACCUM: next = (count == 16) ? DONE : ACCUM;
            DONE: next = IDLE;
            default: next = IDLE;
        endcase
    end

    always @(posedge clk or posedge rst) begin
        if (rst)
            count <= 0;
        else begin
            case (state)
                LOAD_1: begin
                    if (data_valid) begin
                        load <= 1;
                        count <= count + 1;
                    end
                LOAD_2: begin
                    load <= 0;
                end
                end
                ACCUM: begin
                    accumulate <= 1;
                    count <= count + 1;
                end
                DONE: count <= 0;
            endcase
        end
    end

endmodule
