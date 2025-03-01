module tb ();

    logic clk, reset;

    		 logic  [2:0]   color;
				 logic          write; 
				 logic  [8:0]   x,y;
			  logic write_out;



         fsm fsm_inst(
				.clk(clk),  
            .reset(reset),
				.color(color),
				.write(write), 
				.x(x),
            .y(y),
				.write_out(write_out)
				);

        initial begin 
          clk=0;

          reset = 0;

          # 10
			 
          reset = 1;

          #5000000 
			 write = 1;
			 
			 #1000000
          $stop();


        end

        always # 10 clk = ~ clk;
    
endmodule