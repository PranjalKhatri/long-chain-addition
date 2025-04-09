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
 -------------[ r1,c,d,e,f,g,h ]-------------
 adds r1 and c 
 -------------[ r2,d,e,f,g,h ]-------------
 adds r2 and d 
 -------------[ r3,e,f,g,h ]-------------
 adds r3 and e 
 -------------[ r4,f,g,h ]-------------
 adds r4 and f 
 -------------[ r5,g,h ]-------------
 adds r5 and g 
 -------------[ r6,h ]-------------
 adds r6 and h 
 -------------[ [output] ]-------------
*/

// Wire connections between pipeline stages
wire [input_size-1:0] c_1, d_1, e_1, f_1, g_1, h_1;
wire [input_size:0] r1o;                             
reg [input_size:0] r1i;                              

wire [input_size+1:0] r2o;                           
reg [input_size+1:0] r2i;                            

wire [input_size+1:0] r3o;                           
reg [input_size+1:0] r3i;                            

wire [input_size+2:0] r4o;                           
reg [input_size+2:0] r4i;                            

wire [input_size+2:0] r5o;                           
reg [input_size+2:0] r5i;                            

wire [input_size+2:0] r6o;                           
reg [input_size+2:0] r6i;                            

wire [input_size+2:0] r7o;                           
reg [input_size+2:0] r7i;   


wire [input_size-1:0] d_2, e_2, f_2, g_2, h_2;

wire [input_size-1:0] e_3, f_3, g_3, h_3;

wire [input_size-1:0] f_4, g_4, h_4;

wire [input_size-1:0] g_5, h_5;

wire [input_size-1:0] h_6;


// Instantiate pipeline stages
pipeline_stage_1 #(input_size) stage1 (.clk(main_clk),
    .a(a), .b(b), .c(c), .d(d), .e(e), .f(f), .g(g), .h(h),
    .co(c_1), .do(d_1), .eo(e_1), .fo(f_1), .go(g_1), .ho(h_1),
    .r1(r1o)
);

pipeline_stage_2 #(input_size) stage2 (.clk(main_clk),
    .r1(r1i), .c(c_1), .d(d_1), .e(e_1), .f(f_1), .g(g_1), .h(h_1),
    .do(d_2), .eo(e_2), .fo(f_2), .go(g_2), .ho(h_2),
    .r2(r2o)
);

pipeline_stage_3 #(input_size) stage3 (.clk(main_clk),
    .r2(r2i), .d(d_2), .e(e_2), .f(f_2), .g(g_2), .h(h_2),
    .eo(e_3), .fo(f_3), .go(g_3), .ho(h_3),
    .r3(r3o)
);

pipeline_stage_4 #(input_size) stage4 (.clk(main_clk),
    .r3(r3i), .e(e_3), .f(f_3), .g(g_3), .h(h_3),
    .fo(f_4), .go(g_4), .ho(h_4),
    .r4(r4o)
);

pipeline_stage_5 #(input_size) stage5 (.clk(main_clk),
    .r4(r4i), .f(f_4), .g(g_4), .h(h_4),
    .go(g_5), .ho(h_5),
    .r5(r5o)
);

pipeline_stage_6 #(input_size) stage6 (.clk(main_clk),
    .r5(r5i), .g(g_5), .h(h_5),
    .ho(h_6),
    .r6(r6o)
);

pipeline_stage_7 #(input_size) stage7 (.clk(main_clk),
    .r6(r6i), .h(h_6),
    .r7(r7o)
);
always @(posedge main_clk)begin 
    r1i <= r1o;
    r2i <= r2o;
    r3i <= r3o;
    r4i <= r4o;
    r5i <= r5o;
    r6i <= r6o;
    r7i <= r7o;
end
assign result = r7i;

endmodule

// a+b max = 30 -> 5 bits
module pipeline_stage_1 #(
    parameter input_size = 4
)(
    input wire clk,
    input wire [input_size-1:0] a, b, c, d, e, f, g, h,
    output reg [input_size-1:0] co, do, eo, fo, go, ho,
    output reg [input_size:0] r1
);
always @(posedge clk) begin
    co<= c;
    do<= d;
    eo<= e;
    fo<= f;
    go<= g;
    ho<= h;
    r1<= a + b;
end
endmodule

// a+b+c max = 45 -> 6 bits
module pipeline_stage_2 #(
    parameter input_size = 4
)(
    input wire clk,
    input wire [input_size:0] r1,
    input wire [input_size-1:0] c, d, e, f, g, h,
    output reg [input_size-1:0] do, eo, fo, go, ho,
    output reg [input_size+1:0] r2
);
always @(posedge clk ) begin
    do<= d;
    eo<= e;
    fo<= f;
    go<= g;
    ho<= h;
    r2<= r1 + c;
end
endmodule

// a+b+c+d max = 60 -> 6 bits
module pipeline_stage_3 #(
    parameter input_size = 4
)(
    input wire clk,
    input wire [input_size+1:0] r2,
    input wire [input_size-1:0] d, e, f, g, h,
    output reg [input_size-1:0] eo, fo, go, ho,
    output reg [input_size+1:0] r3
);
always @(posedge clk ) begin
    eo<= e;
    fo<= f;
    go<= g;
    ho<= h;
    r3<= r2 + d;
end
endmodule

// a+b+c+d+e max = 75 -> 7 bits
module pipeline_stage_4 #(
    parameter input_size = 4
)(
    input wire clk,
    input wire [input_size+1:0] r3,
    input wire [input_size-1:0] e, f, g, h,
    output reg [input_size-1:0] fo, go, ho,
    output reg [input_size+2:0] r4
);
always @(posedge clk ) begin
    fo<= f;
    go<= g;
    ho<= h;
    r4<= r3 + e;
end
endmodule

// a+b+c+d+e+f max = 90 -> 7 bits
module pipeline_stage_5 #(
    parameter input_size = 4
)(
    input wire clk,
    input wire [input_size+2:0] r4,
    input wire [input_size-1:0] f, g, h,
    output reg [input_size-1:0] go, ho,
    output reg [input_size+2:0] r5
);
always @(posedge clk ) begin
    go<= g;
    ho<= h;
    r5<= r4 + f;
end
endmodule

// a+b+c+d+e+f+g max = 105 -> 7 bits
module pipeline_stage_6 #(
    parameter input_size = 4
)(
    input wire clk,
    input wire [input_size+2:0] r5,
    input wire [input_size-1:0] g, h,
    output reg [input_size-1:0] ho,
    output reg [input_size+2:0] r6
);
always @(posedge clk ) begin
    ho<= h;
    r6<= r5 + g;
end
endmodule

// a+b+c+d+e+f+g+h max = 120 -> 7 bits
module pipeline_stage_7 #(
    parameter input_size = 4
)(
    input wire clk,
    input wire [input_size+2:0] r6,
    input wire [input_size-1:0] h,
    output reg [input_size+2:0] r7
);
always @(posedge clk ) begin
    r7<= r6 + h;
end    
endmodule