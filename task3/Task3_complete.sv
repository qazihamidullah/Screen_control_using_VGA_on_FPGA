//top file


// VGA Demo file 
module Task3_complete(CLOCK_50, SW, KEY,
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

	
	//LOGIC Variables 
	logic [8:0] x_out;
	logic [8:0] y_out;
	logic 		write_out;
	logic [2:0] color_out;

		//instantiation 
		
		Task3_fsm Task3_fsm_inst1(
											.clk(CLOCK_50),
											.key(!KEY[1]),			// To start drawing. When Keyo is 1 state changes to draw line state
											.reset(KEY[3]),		// Asynchronous reset
											.x1(SW[17:10]),					// input x coordinate
											.y1(SW[9:3]),					// input y coordinate
											.input_color(SW[2:0]),		//input color to be choosen
											.x_out(x_out),				// x coordinate from bresenhams output
											.y_out(y_out),				// y coordinate
											.write_out(write_out),			//to draw VGA write enable
											.color(color_out)					//output color
											);

	vga_adapter VGA(
			.resetn(KEY[3]),
			.clock(CLOCK_50),
			.colour(color_out),
			.x(x_out),
			.y(y_out),
			.plot(write_out),
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