// FSM for Task 3 of the Assignment 02

module Task3_fsm(
				input  logic  clk, key, 		//KEY[0] used to go to draw_line state 
            input  logic         reset,
            input  logic  [8:0]	x1,
				input	 logic  [8:0]	y1,
				input  logic  [2:0] input_color,				//take user input for color
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
  logic draw_bresenham;
  
  //storing the inputs of the user into x_reg and y_reg so that they cannot be changed during 
  
  logic [8:0] x1_reg, y1_reg;
  
  //logic draw;
  logic wr_o;
  
  bresenham bresenham_inst1(
									.clk(clk),
									.reset(reset),
									.draw(draw_bresenham),			//when draw is 1 bresenham will work
									.x1(x1_reg),
									.y1(y1_reg),
									.x(x_bresenham),
									.y(y_bresenham),
									.complete(complete),		// when it reaches the inputted coordinates complete will be on
									.wr_o(wr_o)					// when complete is on wr_o will be off 
									);
  //
  
  
 

  // states for FSM
    enum logic [1:0] { reset_state, user_input, draw_line } state, next_state;
    logic enable_x ;
    logic enable_y ;

	 logic [8:0] x_count,y_count;
	 
	 
	 //for reset 
	 
      always @ (*) begin 
     enable_x = (x_count==159 && y_count==119) ? 0 : 1;
     enable_y = (x_count==159 && y_count== 119)?0 : (x_count == 159 && y_count != 119)?1:0;

      end
     
  // row counter 
      counter counter_x(
                      .clk(clk), 
                      .reset(reset),
                      .compare(9'd159),
                      .enable(enable_x),
                      .count(x_count)
                      );
  // coloum counter 
      counter counter_y(
                      .clk(clk), 
                      .reset(reset),
                      .compare(9'd119),
                      .enable(enable_y),
                      .count(y_count)
                      );
							 
							 
							 
  // state register 

    always @ (posedge clk or negedge reset) begin
      if(!reset)
        state <= reset_state;
      else
        state <= next_state; 
    end

	 
	 
  // next logic 
    always @ (*) begin
      case(state)

      reset_state:    	begin
									if((x_count==159 && y_count==119))
										next_state = user_input;
									else 
										next_state = reset_state;
								end

      user_input:  		 begin
                          if(key == 1) 
                            next_state = draw_line;
                          else begin
									          next_state = user_input;
                            
									 end

								 end
		
		draw_line:		begin
								if(complete)
									next_state = user_input;
								else
									next_state = draw_line;
    end
		
      default:        next_state = reset_state;
      endcase
    end
	 
	 
	 
  
  
  
		always @ (posedge clk or negedge reset) begin
			if(!reset) begin
				x1_reg <= 0;
				y1_reg <= 0;
				end
			else if(state == user_input) begin
				if(x1>159 && y1 > 119) begin
					x1_reg <= 159;
					y1_reg <= 119;
					end
				else if(x1 > 159)
					x1_reg <= 159;
				else if(y1 > 119)
					y1_reg <= 119;
				else begin
					x1_reg <= x1;
					y1_reg <= y1;
					end
					end
			else begin
				x1_reg <= x1_reg;
				y1_reg <= y1_reg;
				
				end
			
		end		//always end
		
  //output logic starts 
  
			always @ (*) begin
			
			x_out = 0;
			y_out = 0;
			color = 3'd0;
			//draw = 0;
			draw_bresenham = 0;
        case(state)

        reset_state:              begin
                                  color = 3'd0;
                                  write_out = 1;
											 x_out = x_count;			//x and y coming from counters 
											 y_out = y_count;
          
											 end

        user_input:       			 begin
                                  write_out = 0;
											 x_out = 0;				//x_out and y_out should be 0 during taking input from user
											 y_out = 0; 
											 end
											 
		  draw_line:					 begin
											 //draw = 1;
											 write_out = wr_o;
											 x_out = x_bresenham;			//the output of bresenham x_bresenham and y_bresenham will be transfered to the output
											 y_out = y_bresenham;
											 color = input_color;
											 draw_bresenham = 1;
											 end
											 
        default:                  begin
                                  color = 3'd0;
                                  write_out = 0;
											 x_out = 0;
											 y_out = 0;
											 draw_bresenham = 0;
        end
        endcase

      end

		
endmodule 