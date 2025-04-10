module testbench();

parameter INPUT_SIZE = 4;
parameter CLK_PERIOD = 10; // 10ns clock period (100MHz)

// Inputs
reg main_clk;
reg [INPUT_SIZE-1:0] a, b, c, d, e, f, g, h;
wire [INPUT_SIZE+2:0] result;
initial begin
    main_clk = 0;
    forever #5 main_clk = ~main_clk; // Toggle clock every 5 time unitskkk
end
pipelined #(
    .input_size(4)
) pipelined_inst (
    .main_clk(main_clk),
    .a(a),
    .b(b),
    .c(c),
    .d(d),
    .e(e),
    .f(f),
    .g(g),
    .h(h),
    .result(result)
); 

integer cycle_count;
initial begin
    a = 0;
    b =0;
    c = 0;
    d = 0;
    e = 0;
    f = 0;
    g = 0;
    h = 0;
  cycle_count=0;
end
always @(posedge main_clk ) begin
    cycle_count = cycle_count+1;    

    if(cycle_count == 2)begin
      a<= 1;
      b<= 1;
      c<= 1;
      d<= 1;
      e<= 1;
      f<= 1;
      g<= 1;
      h<= 1;
    end
    if(cycle_count == 3)begin
      a<= 1;
      b<= 2;
      c<= 3;
      d<= 4;
      e<= 5;
      f<= 6;
      g<= 7;
      h<= 8;
    end
    if(cycle_count == 4)begin
      a<= 3;
      b<= 4;
      c<= 5;
      d<= 6;
      e<= 7;
      f<= 8;
      g<= 9;
      h<= 10;
    end
    if(cycle_count >= 13)$finish; // Stop simulation after 20 cycles
    #1 $display("cycle %0d | a=%0d b=%0d c=%0d d=%0d e=%0d f=%0d g=%0d h=%0d | result=%0d", 
          cycle_count, a, b, c, d, e, f, g, h, result);
end
endmodule