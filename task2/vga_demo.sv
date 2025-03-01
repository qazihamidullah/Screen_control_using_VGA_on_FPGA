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

	
	
		wire write_out;		//VGA enable to fill the pixel
		wire [2:0] color;
		wire [8:0] col;
		wire [8:0] row;
		
		
		fsm fsm_inst1(
						.clk(CLOCK_50),
						.reset(KEY[3]),
						.write(~KEY[2]),		//trigger fsm to go to fill_screen state
						.color(color),
						.y(col),			//WILL write in the pixel
						.x(row),
						.write_out(write_out)//		//enable VGA to fill pixel
						);
						
						
						
	vga_adapter VGA(
			.resetn(KEY[3]),
			.clock(CLOCK_50),
			.colour(color),
			.x(row),
			.y(col),
			.plot(write_out),		//when plot is high then in the next clk cycle the pixel will change color based on the color input
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