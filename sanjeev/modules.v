module full_adder (
    input  a,
    input  b,
    input  cin,
    output sum,
    output cout
);
    assign sum  = a ^ b ^ cin;
    assign cout = (a & b) | (b & cin) | (a & cin);
endmodule

module ripple_adder_7bit (
    input  [6:0] a,
    input  [6:0] b,
    output [6:0] sum,
    output       cout
);
    wire [6:0] carry;

    full_adder fa0 (a[0], b[0], 1'b0,     sum[0], carry[0]);
    full_adder fa1 (a[1], b[1], carry[0], sum[1], carry[1]);
    full_adder fa2 (a[2], b[2], carry[1], sum[2], carry[2]);
    full_adder fa3 (a[3], b[3], carry[2], sum[3], carry[3]);
    full_adder fa4 (a[4], b[4], carry[3], sum[4], carry[4]);
    full_adder fa5 (a[5], b[5], carry[4], sum[5], carry[5]);
    full_adder fa6 (a[6], b[6], carry[5], sum[6], cout);

endmodule
