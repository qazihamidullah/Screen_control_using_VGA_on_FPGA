module tb();

logic [8:0] x1, y1;		//input pixel coordinates 
logic clk, key, reset, write_out,draw;		//write_out is enable for VGA pixel write
logic [8:0] x_out, y_out;		//the outputs pixel coordinates 
logic [2:0] color;		//color from FSM
logic [2:0] input_color;
logic wr_o;

/*
		bresenham inst0(
							.x1(x1),
							.y1(y1),
							.x(x_out),
							.y(y_out),
							.clk(clk),
							.reset(reset),
							.draw(draw),
							.complete(write_out),
							//.color(color)
							.wr_o(wr_o)
							
							);
							*/							
	
							
		Task3_fsm Task3_fsm_inst1(
											.clk(clk),
											.reset(reset),
											.key(key),
											//.draw(draw),
											.x1(x1),
											.y1(y1),
											.input_color(input_color),
											.x_out(x_out),
											.y_out(y_out),
											.write_out(write_out),	//to give a signal to VGA to enable write pixel
											.color(color)
											);
			

	initial begin 
	
	clk = 0;
	reset = 0;
	x1 = 9'd10;
	y1 = 9'd10;
	key = 0;
	input_color = 3'd1;
	draw = 0;
	
	
	#100
	reset =1;
	
	
	
  # 100
	draw = 1;
	
	
	
	#600000
	input_color = 3'd2;
	
	
	# 100
	key =1;
	
	
	# 100;
	key = 0;
	
	
	#500000
	input_color = 3'd3;
	x1 = 9'd105;
	y1 = 9'd9;
	
	
	
	# 100
	key =1;
	
	
	# 100
	key =0;
	
	
	
	#2000
	input_color = 3'd4;

	#1000000
	$stop();
	
	
	end
	
	always 
	#10
	clk = ~clk;
	
	endmodule 