module controller(
    input wire clk,
    input wire rst,
    input wire dataValid,
    input wire dp_done,
    output reg[3:0] state
);
parameter S_IDLE = 4'b0000;
parameter S_LOAD_1 = 4'b0001;
parameter S_LOAD_2 = 4'b0010;
parameter S_LOAD_3 = 4'b0011;
parameter S_RUN = 4'b0100;
parameter S_RUN_IS = 4'b0101;
parameter S_DONE = 4'b0110;

reg[3:0] next_state;
reg[3:0] counter;

initial begin
    state <= S_IDLE;
end
// State register
always @(posedge clk or posedge rst) begin
    if (rst) begin
        state <= S_IDLE;
        counter <= 0;
    end else begin
        $display("State: %b,nextState: %b, dataValid: %b Counter: %d", state,next_state,dataValid, counter);
        state <= next_state;
        if (state == S_LOAD_2)
            counter <= counter + 1;
    end
end

// Next state logic
always @(*) begin
    case(state)
        S_IDLE: begin
            next_state = S_LOAD_1;
        end
        S_LOAD_1: begin
            if(counter == 8 && !dataValid)
                next_state = S_RUN;
            else if(dataValid)
                next_state = S_LOAD_2;
            else
                next_state = S_LOAD_1;
        end
        S_LOAD_2: begin
            next_state = S_LOAD_3;
        end
        S_LOAD_3: begin
            if(!dataValid)
                next_state = S_LOAD_1;
            else
                next_state = S_LOAD_3;
        end
        S_RUN: begin
            if(dp_done)
                next_state = S_DONE;
            else
                next_state = S_RUN_IS;
        end
        S_RUN_IS: begin
            next_state = S_RUN;
        end
        S_DONE: begin
            next_state = S_DONE;
        end
        default: next_state = S_IDLE;
    endcase
end


endmodule