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
 adds a and b 
 -------------[ r1,c_1,d_1,e_1,f_1,g_1,h_1 ]-------------
 adds r1 and c_1 
 -------------[ r2,d_2,e_2,f_2,g_2,h_2 ]-------------
 adds r2 and d_2 
 -------------[ r3,e_3,f_3,g_3,h_3 ]-------------
 adds r3 and e_3 
 -------------[ r4,f_4,g_4,h_4 ]-------------
 adds r4 and f_4 
 -------------[ r5,g_5,h_5 ]-------------
 adds r5 and g_5 
 -------------[ r6,h_6 ]-------------
 adds r6 and h_6 
 -------------[ [output] ]-------------
*/

// Register connections between pipeline stages
wire [input_size-1:0] c_out, d_out, e_out, f_out, g_out, h_out;
reg [input_size-1:0] c_1, d_1, e_1, f_1, g_1, h_1;

wire [input_size:0] r1o;                             
reg [input_size:0] r1i;

wire [input_size-1:0] d_out2, e_out2, f_out2, g_out2, h_out2;                              
reg [input_size-1:0] d_2, e_2, f_2, g_2, h_2;

wire [input_size+1:0] r2o;                           
reg [input_size+1:0] r2i;                            

wire [input_size-1:0] e_out3, f_out3, g_out3, h_out3;
reg [input_size-1:0] e_3, f_3, g_3, h_3;

wire [input_size+1:0] r3o;                           
reg [input_size+1:0] r3i;                            

wire [input_size-1:0] f_out4, g_out4, h_out4;
reg [input_size-1:0] f_4, g_4, h_4;

wire [input_size+2:0] r4o;                           
reg [input_size+2:0] r4i;                            

wire [input_size-1:0] g_out5, h_out5;
reg [input_size-1:0] g_5, h_5;

wire [input_size+2:0] r5o;                           
reg [input_size+2:0] r5i;                            

wire [input_size-1:0] h_out6;
reg [input_size-1:0] h_6;

wire [input_size+2:0] r6o;                           
reg [input_size+2:0] r6i;                            

wire [input_size+2:0] r7o;                           
reg [input_size+2:0] r7i;   

// Instantiate pipeline stages
pipeline_stage_1 #(input_size) stage1 (.clk(main_clk),
    .a(a), .b(b), .c(c), .d(d), .e(e), .f(f), .g(g), .h(h),
    .co(c_out), .do(d_out), .eo(e_out), .fo(f_out), .go(g_out), .ho(h_out),
    .r1(r1o)
);

pipeline_stage_2 #(input_size) stage2 (.clk(main_clk),
    .r1(r1i), .c(c_1), .d(d_1), .e(e_1), .f(f_1), .g(g_1), .h(h_1),
    .do(d_out2), .eo(e_out2), .fo(f_out2), .go(g_out2), .ho(h_out2),
    .r2(r2o)
);

pipeline_stage_3 #(input_size) stage3 (.clk(main_clk),
    .r2(r2i), .d(d_2), .e(e_2), .f(f_2), .g(g_2), .h(h_2),
    .eo(e_out3), .fo(f_out3), .go(g_out3), .ho(h_out3),
    .r3(r3o)
);

pipeline_stage_4 #(input_size) stage4 (.clk(main_clk),
    .r3(r3i), .e(e_3), .f(f_3), .g(g_3), .h(h_3),
    .fo(f_out4), .go(g_out4), .ho(h_out4),
    .r4(r4o)
);

pipeline_stage_5 #(input_size) stage5 (.clk(main_clk),
    .r4(r4i), .f(f_4), .g(g_4), .h(h_4),
    .go(g_out5), .ho(h_out5),
    .r5(r5o)
);

pipeline_stage_6 #(input_size) stage6 (.clk(main_clk),
    .r5(r5i), .g(g_5), .h(h_5),
    .ho(h_out6),
    .r6(r6o)
);

pipeline_stage_7 #(input_size) stage7 (.clk(main_clk),
    .r6(r6i), .h(h_6),
    .r7(r7o)
);

always @(posedge main_clk) begin 
    // Register stage outputs at each clock edge
    r1i <= r1o;
    c_1 <= c_out;
    d_1 <= d_out;
    e_1 <= e_out;
    f_1 <= f_out;
    g_1 <= g_out;
    h_1 <= h_out;
    
    r2i <= r2o;
    d_2 <= d_out2;
    e_2 <= e_out2;
    f_2 <= f_out2;
    g_2 <= g_out2;
    h_2 <= h_out2;
    
    r3i <= r3o;
    e_3 <= e_out3;
    f_3 <= f_out3;
    g_3 <= g_out3;
    h_3 <= h_out3;
    
    r4i <= r4o;
    f_4 <= f_out4;
    g_4 <= g_out4;
    h_4 <= h_out4;
    
    r5i <= r5o;
    g_5 <= g_out5;
    h_5 <= h_out5;
    
    r6i <= r6o;
    h_6 <= h_out6;
    
    r7i <= r7o;
    
    // Debug statements
    // $display("a: %d, b: %d, c_1: %d, d_1: %d, e_1: %d, f_1: %d, g_1: %d, h_1: %d", a, b, c_1, d_1, e_1, f_1, g_1, h_1);
    // $display("r1i: %d, r1o: %d", r1i, r1o);
    // $display("r2i: %d, r2o: %d", r2i, r2o);
    // $display("r3i: %d, r3o: %d", r3i, r3o);
    // $display("r4i: %d, r4o: %d", r4i, r4o);
    // $display("r5i: %d, r5o: %d", r5i, r5o);
    // $display("r6i: %d, r6o: %d", r6i, r6o);
    // $display("r7i: %d, r7o: %d", r7i, r7o);
end
assign result = r7i;

endmodule

// a+b max = 30 -> 5 bits
module pipeline_stage_1 #(
    parameter input_size = 4
)(
    input wire clk,
    input wire [input_size-1:0] a, b, c, d, e, f, g, h,
    output wire [input_size-1:0] co, do, eo, fo, go, ho,
    output wire [input_size:0] r1
);
   assign co = c;
   assign do = d;
   assign eo = e;
   assign fo = f;
   assign go = g;
   assign ho = h;
//    assign r1 = a + b;
   wire cout;
    ripple_adder_7bit adder (
        .a(a),
        .b(b),
        .sum(r1),
        .cout(cout)
    );
   always @(posedge clk) begin
       $display("%0t |stage 1 r1 = %d a %d, b %d",$time, r1, a, b);
   end
endmodule

// a+b+c max = 45 -> 6 bits
module pipeline_stage_2 #(
    parameter input_size = 4
)(
    input wire clk,
    input wire [input_size:0] r1,
    input wire [input_size-1:0] c, d, e, f, g, h,
    output wire [input_size-1:0] do, eo, fo, go, ho,
    output wire [input_size+1:0] r2
);
   assign do = d;
   assign eo = e;
   assign fo = f;
   assign go = g;
   assign ho = h;
//    assign r2 = r1 + c;
      wire cout;
    ripple_adder_7bit adder (
        .a(r1),
        .b(c),
        .sum(r2),
        .cout(cout)
    );
   always @(posedge clk) begin
       $display("%0t | stage 2 r2 %d r1 %d c %d",$time, r2, r1, c);
   end
endmodule

// a+b+c+d max = 60 -> 6 bits
module pipeline_stage_3 #(
    parameter input_size = 4
)(
    input wire clk,
    input wire [input_size+1:0] r2,
    input wire [input_size-1:0] d, e, f, g, h,
    output wire [input_size-1:0] eo, fo, go, ho,
    output wire [input_size+1:0] r3
);
   assign eo = e;
   assign fo = f;
   assign go = g;
   assign ho = h;
//    assign r3 = r2 + d;
   wire cout;
    ripple_adder_7bit adder (
        .a(r2),
        .b(d),
        .sum(r3),
        .cout(cout)
    );
   
   always @(posedge clk) begin
       $display("%0t | stage 3 r3 %d r2 %d d %d",$time, r3, r2, d);
   end
endmodule

// a+b+c+d+e max = 75 -> 7 bits
module pipeline_stage_4 #(
    parameter input_size = 4
)(
    input wire clk,
    input wire [input_size+1:0] r3,
    input wire [input_size-1:0] e, f, g, h,
    output wire [input_size-1:0] fo, go, ho,
    output wire [input_size+2:0] r4
);
    assign fo = f;
    assign go = g;
    assign ho = h;
    // assign r4 = r3 + e;
       wire cout;
    ripple_adder_7bit adder (
        .a(r3),
        .b(e),
        .sum(r4),
        .cout(cout)
    );
    
    always @(posedge clk) begin
        $display("%0t | stage 4 r4 %d r3 %d e %d",$time, r4, r3, e);
    end
endmodule

// a+b+c+d+e+f max = 90 -> 7 bits
module pipeline_stage_5 #(
    parameter input_size = 4
)(
    input wire clk,
    input wire [input_size+2:0] r4,
    input wire [input_size-1:0] f, g, h,
    output wire [input_size-1:0] go, ho,
    output wire [input_size+2:0] r5
);
   assign go = g;
   assign ho = h;
//    assign r5 = r4 + f;
       wire cout;
    ripple_adder_7bit adder (
        .a(r4),
        .b(f),
        .sum(r5),
        .cout(cout)
    );
   
   always @(posedge clk) begin
       $display("%0t | stage 5 r5 %d r4 %d f %d",$time, r5, r4, f);
   end
endmodule

// a+b+c+d+e+f+g max = 105 -> 7 bits
module pipeline_stage_6 #(
    parameter input_size = 4
)(
    input wire clk,
    input wire [input_size+2:0] r5,
    input wire [input_size-1:0] g, h,
    output wire [input_size-1:0] ho,
    output wire [input_size+2:0] r6
);
    assign ho = h;
    // assign r6 = r5 + g;
           wire cout;
    ripple_adder_7bit adder (
        .a(r5),
        .b(g),
        .sum(r6),
        .cout(cout)
    );
    
    always @(posedge clk) begin
        $display("%0t | stage 6 r6 %d r5 %d g %d",$time, r6, r5, g);
    end
endmodule

// a+b+c+d+e+f+g+h max = 120 -> 7 bits
module pipeline_stage_7 #(
    parameter input_size = 4
)(
    input wire clk,
    input wire [input_size+2:0] r6,
    input wire [input_size-1:0] h,
    output wire [input_size+2:0] r7
);
    // assign r7 = r6 + h;
           wire cout;
    ripple_adder_7bit adder (
        .a(r6),
        .b(h),
        .sum(r7),
        .cout(cout)
    );
    always @(posedge clk) begin
        $display("%0t | stage r7 %d",$time, r7);
    end    
endmodule