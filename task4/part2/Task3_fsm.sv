// FSM for Task 3 of the Assignment 02

module Task3_fsm(
				input  logic  clk, //key, 		//KEY[0] used to go to draw_line state 
            input  logic         reset,
           // input  logic  [8:0]	x1,
				//input	 logic  [8:0]	y1,
				//input  logic  [2:0] input_color,				//take user input for color
				//input  logic  [8:0]	x2,
				//input	 logic  [8:0]	y2,
				output logic  [8:0]  x_out,
				output logic  [8:0]  y_out,
				output logic write_out,					//to give a signal to VGA to enable write pixel
				output  logic [2:0] color
				);
//


//bresenham algorithm
  
  logic [8:0] x_bresenham, y_bresenham;
  logic complete;
  
  //storing the inputs of the user into x_reg and y_reg so that they cannot be changed during 
  
  logic [8:0] x1_reg, y1_reg;
  
  logic draw;
  logic wr_o;
  
  bresenham bresenham_inst1(
									.clk(clk),
									.reset(reset),			//whenever resets it takes initial points (80,60)
									.draw(draw),
									.x1(x1_reg),
									.y1(y1_reg),
									.x(x_bresenham),
									.y(y_bresenham),
									.complete(complete),
									.wr_o(wr_o)
									);
  //
  
		//shift register 
		
  
	 logic [8:0] shift_value_x, shift_value_y;
   logic shift_register_enable;
	 
	 //shift register to randomly generate input for color and pixel coordinates instead of taking from user
	 
	 shift_register # (.width(8),.default_value(8), .max_value(159), .min_value(0)) shift_register_inst_x (
													.clk(clk),
													.reset(reset),
													.shift_value(shift_value_x),
                          .enable(shift_register_enable)
													);
													
	 shift_register # (.default_value(3), .max_value(119), .min_value(0))shift_register_inst_y (
													.clk(clk),
													.reset(reset),
													.shift_value(shift_value_y),
                          .enable(shift_register_enable)
													);
	 
	 
  
  
  
  //counter for delay 
  
  logic enable_delay, delay_complete, draw_delay_complete;
  logic en_delay_draw;
  logic [8:0] delay_count, draw_delay_count;

  


  

  
  
  counter # (.n(9))count_delay(
							.clk(clk),
							.reset(reset),
							.compare(9'd10),
							.enable(enable_delay),
							.count(delay_count),
              .complete(delay_complete)
							);

  counter # (.n(32))count_delay_draw(
							.clk(clk),
							.reset(reset),
							.compare(32'd50000000),
							.enable(en_delay_draw),
							.count(draw_delay_count),
              .complete(draw_delay_complete)
							);
    
    
							
 

  // states for FSM
    enum logic [1:0] { reset_state, user_input, draw_line } state, next_state;
    logic enable_x ;
    logic enable_y ;

	 logic [8:0] x_count,y_count;
	 
	 
      always @ (*) begin 
     enable_x = (x_count==159 && y_count==119) ? 0 : 1;
     enable_y = (x_count==159 && y_count== 119)?0 : (x_count == 159 && y_count != 119)?1:0;

      end
     
  // row counter 
      counter #(.n(8))counter_x(
                      .clk(clk), 
                      .reset(reset),
                      .compare(9'd159),
                      .enable(enable_x),
                      .count(x_count)
                      );
  // coloum counter 
      counter #(.n(7)) counter_y(
                      .clk(clk), 
                      .reset(reset),
                      .compare(9'd119),
                      .enable(enable_y),
                      .count(y_count)
                      );
							 
							 
    always_ff @( posedge clk, negedge reset ) begin 
    if(!reset)
      en_delay_draw <= 0;
    else if(state == draw_line && complete)
      en_delay_draw <= 1;
    else if( state != draw_line)
      en_delay_draw <= 0;
  end



							 
  // state register 

    always @ (posedge clk or negedge reset) begin
      if(!reset)
        state <= reset_state;
      else
        state <= next_state; 
    end

	 
   //storing the user input for consistent inputs 
  
  
		always @ (posedge clk or negedge reset) begin
			if(!reset) begin
				x1_reg <= 0;
				y1_reg <= 0;
				end
			else if(state == user_input) begin
				x1_reg <= shift_value_x>159? shift_value_x>>1: shift_value_x;
				y1_reg <= shift_value_y>119? shift_value_y>>1: shift_value_y;
				end
			else begin
				x1_reg = x1_reg;
				y1_reg = y1_reg;
				
				end
		end
	 
  // next logic 
    always @ (*) begin
      case(state)

      reset_state:    	    begin
                            if((x_count==159 && y_count==119))
                              next_state <= user_input;
                            else 
                              next_state <= reset_state;
							            	end

      user_input:  		      begin
                            if(delay_complete)        //the shift register takes 10 values to complete input
                              next_state <= draw_line;
                            else 
                              next_state <= user_input;
								            end
		
		  draw_line:		        begin
                            if(draw_delay_complete)
                              next_state = user_input;
                            else
                              next_state = draw_line;
                            end
	 
		
      default:              next_state <= reset_state;
      endcase
    end
	 
	 
	 
		
  //output logic starts 
  
			always @ (*) begin
			
			x_out = 0;
			y_out = 0;
			color = 3'd0;
			draw = 0;
			write_out = 0;
        case(state)

        reset_state:              begin
                                  color = 3'd0;
                                  write_out = 1;
                                  x_out = x_count;			//x and y coming from counters 
                                  y_out = y_count;
          
											            end

        user_input:       			  begin
                                  enable_delay = 1;       //set delay counter on
                                  shift_register_enable =1; //on the register to take input
                                  end
											 
		    draw_line:					      begin
                                  draw = 1;                //set pixel write on
                                  enable_delay = 0;        //set delay counter off
                                  write_out = wr_o;
                                  shift_register_enable = 0;    //off the register so that the input can be consistent
                                  x_out = x_bresenham;			//the output of bresenham x_bresenham and y_bresenham will be transfered to the output
                                  y_out = y_bresenham;
                                  color = shift_value_x[3:0];   //set the LSB 3 bit to color
                                  end
											 
        default:                  begin
                                  color = 3'd0;
                                  write_out = 1;
                                  x_out = 0;
                                  y_out = 0;
                                  end
        endcase

      end

		
endmodule 