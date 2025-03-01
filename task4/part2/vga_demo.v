 module vga_demo(CLOCK_50, SW, KEY,
				VGA_R, VGA_G, VGA_B,
				VGA_HS, VGA_VS, VGA_BLANK, VGA_SYNC, VGA_CLK);
	
	input CLOCK_50;
	input [17:0] SW;
	input [3:0] KEY;
	output [9:0] VGA_R;
	output [9:0] VGA_G;
	output [9:0] VGA_B;
	output VGA_HS;
	output VGA_VS;
	output VGA_BLANK;
	output VGA_SYNC;
	output VGA_CLK;				

	
	
		wire write;
		wire [2:0] color;
		wire [8:0] col;
		wire [8:0] row;
		

 Task3_fsm inst0(
				.clk(CLOCK_50), //key, 		//KEY[0] used to go to draw_line state 
            . reset(KEY[3]),
           // input  logic  [8:0]	x1,
				//input	 logic  [8:0]	y1,
				//input  logic  [2:0] input_color,				//take user input for color
				//input  logic  [8:0]	x2,
				//input	 logic  [8:0]	y2,
				.x_out(row),
				.y_out(col),
				.write_out(write),					//to give a signal to VGA to enable write pixel
				.color(color)
				);
//
						
						
						
	vga_adapter VGA(
			.resetn(KEY[3]),
			.clock(CLOCK_50),
			//.colour(SW[17:15]),
			.colour(color),
			//.x(SW[14:7]),
			.x(row),
			//.y(SW[6:0]),
			.y(col),
			//.plot(~(KEY[1])),
			.plot(write),		//when plot is high then in the next clk cycle the pixel will change color based on the color input
			/* Signals for the DAC to drive the monitor. */
			.VGA_R(VGA_R),
			.VGA_G(VGA_G),
			.VGA_B(VGA_B),
			.VGA_HS(VGA_HS),
			.VGA_VS(VGA_VS),
			.VGA_BLANK(VGA_BLANK),
			.VGA_SYNC(VGA_SYNC),
			.VGA_CLK(VGA_CLK));
		defparam VGA.RESOLUTION = "160x120";
		defparam VGA.MONOCHROME = "FALSE";
		defparam VGA.BITS_PER_COLOUR_CHANNEL = 1;
		defparam VGA.BACKGROUND_IMAGE = "image.colour.mif";
		
		
		
		
endmodule