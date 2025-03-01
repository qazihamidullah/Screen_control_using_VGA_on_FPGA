//module register to save the input from user 

module bresenham(
					input clk, reset,
					input draw,
					input  logic [8:0] x1,
					input  logic [8:0] y1,
					output logic [8:0] x,
					output logic [8:0] y,
					output logic       complete,
					output logic 		 wr_o
					);

  logic signed [8:0] dx, dy, error, sx, sy;
  logic signed [9:0] e2;
  logic [8:0] dy_abs,dx_abs;

		
		
		assign dx_abs = x1 - x;
      assign dy_abs = y1 - y;
		
		assign dx = dx_abs[8]? -dx_abs:dx_abs;
		assign dy = dy_abs[8]? -dy_abs:dy_abs;
		
		

      assign sx = (x < x1) ? 1 : -1;
      assign sy = (y < y1) ? 1 : -1;
		
		assign e2 = error<<1;
		
		always_ff @( posedge clk or negedge reset ) begin : blockName
      if(!reset) begin
            error <= 0;
      end
      else begin
        if(!draw)
          error <= dx - dy;
        else begin
          if(e2>-dy && e2< dx)
             error <= error -dy +dx;
          else if(e2 > -dy)
             error <= error -dy;
          else if(e2<dx)
             error <= error + dx; 
             
        end
    end
    end

		
		always @ (posedge clk or negedge reset) begin
    if (!reset ) begin
      x <=  'd80;
      y <=  'd60;
      wr_o  <=  'd0;
      complete <= 'd0;
    end
    else begin
    ///
      if(!draw) begin
        x <= x;
        y <= y;
       
        complete <= 0; 
        wr_o <= 0;
      end
      else if(x==x1 && y==y1) begin
        complete <= 1;
		  x <= x;
		  y <= y;
        wr_o <= 1;
      end
      else begin
      wr_o <= 1;
      if(e2 > -dy) begin
          x <= x + sx;
                end
      
        if(e2 < dx) begin
          y <= y + sy; end
      
      end
    ///
    end
    end	//always end
		
							
endmodule 