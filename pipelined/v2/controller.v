module pipelined #(
    parameter input_size = 4
)(
    input wire main_clk,
    input wire [input_size-1:0] a, b, c, d, e, f, g, h,
    output wire [input_size+2:0] result
);
/*
=== [] represents buffer for registers
 -------------[ a,b,c,d,e,f,g,h ]-------------
    r1 <- a+b, r2 <- c+d, r3 <- e+f, r4 <- g+h
 -------------[ [r1],[r2],[r3],[r4] ]-------------
    r5 <- r1+r2, r6 <- r3+r4
    -------------[ [r5],[r6] ]-------------
    r7 <- r5+r6
 -------------[ [output] ]-------------
*/

// Register connections between pipeline stages
wire [input_size:0] r1,r2,r3,r4;
reg [input_size:0] r1i,r2i,r3i,r4i;

wire [input_size+2:0] r5,r6;
reg [input_size+2:0] r5i,r6i;

pipeline_stage_1 #(
    .input_size(input_size)
) stage_1 (
    .clk(main_clk),
    .a(a),
    .b(b),
    .c(c),
    .d(d),
    .e(e),
    .f(f),
    .g(g),
    .h(h),
    .r1(r1),
    .r2(r2),
    .r3(r3),
    .r4(r4)
);

pipeline_stage_2 #(
    .input_size(input_size)
) stage_2 (
    .clk(main_clk),
    .r1(r1i),
    .r2(r2i),
    .r3(r3i),
    .r4(r4i),
    .r5(r5),
    .r6(r6)
);

pipeline_stage_3 #(
    .input_size(input_size)
) stage_3 (
    .clk(main_clk),
    .r5(r5i),
    .r6(r6i),
    .r7(result)
);

always @(posedge main_clk ) begin
    r1i <= r1;
    r2i <= r2;
    r3i <= r3;
    r4i <= r4;
    r5i <= r5;
    r6i <= r6;
end


endmodule

// a+b max = 30 -> 5 bits
module pipeline_stage_1 #(
    parameter input_size = 4
)(
    input wire clk,
    input wire [input_size-1:0] a, b, c, d, e, f, g, h,
    output wire [input_size:0] r1,r2,r3,r4
);
//    assign r1 = a + b;
   wire cout1,cout2,cout3,cout4;
    ripple_adder_7bit adder (
        .a(a),
        .b(b),
        .sum(r1),
        .cout(cout1)
    );
    ripple_adder_7bit adder1 (
        .a(c),
        .b(d),
        .sum(r2),
        .cout(cout2)
    );
    ripple_adder_7bit adder2 (
        .a(e),
        .b(f),
        .sum(r3),
        .cout(cout3)
    );
    ripple_adder_7bit adder3 (
        .a(g),
        .b(h),
        .sum(r4),
        .cout(cout4)
    );
   always @(posedge clk) begin
       $display("%0t |stage 1 r1 = %d r2 = %d r3 = %d r4 = %d",$time, r1, r2, r3, r4);
   end
endmodule

// a+b+c max = 45 -> 6 bits
module pipeline_stage_2 #(
    parameter input_size = 4
)(
    input wire clk,
    input wire [input_size:0] r1,r2,r3,r4,
    output wire [input_size+2:0] r5,r6
);
    wire cout,c2;
    ripple_adder_7bit adder (
        .a(r1),
        .b(r2),
        .sum(r5),
        .cout(cout)
    );
    ripple_adder_7bit adder1 (
        .a(r3),
        .b(r4),
        .sum(r6),
        .cout(c2)
    );
   always @(posedge clk) begin
       $display("%0t | stage 2 r5 = %d r6 = %d",$time, r5, r6);
   end
endmodule

// a+b+c+d max = 60 -> 6 bits
module pipeline_stage_3 #(
    parameter input_size = 4
)(
    input wire clk,
    input wire [input_size+2:0] r5,r6,
    output wire [input_size+2:0] r7
);
    wire cout;
    ripple_adder_7bit adder (
        .a(r5),
        .b(r6),
        .sum(r7),
        .cout(cout)
    );
   always @(posedge clk) begin
       $display("%0t | stage 3 r7 = %d",$time, r7);
   end
endmodule
