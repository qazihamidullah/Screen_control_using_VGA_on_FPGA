// FSM for Task 2 of the Assignment 02

module fsm(
				input  logic          clk,  
            input  logic          reset,
            input  logic          write,
				output logic  [2:0]   color,
				output logic          write_out, 
				output logic  [8:0]   x,y
				);
//

  // states for FSM
    enum logic { reset_state, fill_screen_state } state, next_state;
    logic enable_x ;
    logic enable_y ;
	 logic tester, tester_reg;

    always_ff @( posedge clk or negedge reset) begin 
      if(~reset)
        tester_reg  <=  0;
        else
        tester_reg  <=  tester;
    end

      always @ (*) begin 								//tester = 1 for fill screen state
        case (state)
          reset_state: begin
            enable_x = (x==159 && y==119) ? 0 : 1;
			      enable_y = (x==159 && y== 119)?0 : (x == 159)?1:0;
          end
          fill_screen_state: begin
            
            enable_x = (x==159 && y==119) ? 0 : 1;
			      enable_y = (x==159 && y== 119)?0 : (x == 159)?1:0;
            if (tester_reg) begin 
              enable_x  = 1;
              enable_y  = 1;
            end
            
          end
          default: begin enable_x = 1; enable_y = 1; end
        endcase
			
	
      end
     
  // row counter 
      counter counter_x(
                      .clk(clk), 
                      .reset(reset),
                      .compare(9'd159),
                      .enable(enable_x),
                      .count(x)
                      );
  // coloum counter 
      counter counter_y(
                      .clk(clk), 
                      .reset(reset),
                      .compare(9'd119),
                      .enable(enable_y),
                      .count(y)
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

      reset_state:    begin
                      if(write == 1)
                        next_state <= fill_screen_state;
                      else 
                        next_state <= reset_state;
      end

      fill_screen_state: 
                          next_state <= fill_screen_state;
                        

      default:        next_state <= reset_state;
      endcase
    end
  // output logic 
			always @ (*) begin
			tester = 0;
        case(state)

        reset_state:              begin
                                  color = 3'd0;
                                  write_out = 1;
          	 tester = 1;
        end

        fill_screen_state:        begin
                                  color = (y[2:0]);
                                  write_out = 1;
											 tester = 0;

        end
        default:                  begin
                                  color = 3'd0;
                                  write_out = 1;
											 tester = 0;
        end
        endcase

      end

		
endmodule 