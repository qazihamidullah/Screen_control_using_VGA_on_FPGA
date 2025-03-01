//counter for count coordinates 

module counter(
                input clk, 
                input reset,
                input [8:0] compare,
                input enable,
                output reg [8:0] count
);

    always @ (posedge clk or negedge reset) begin
      if(!reset)
        count <= 0;
      else if(enable == 1) begin
        if(count == compare)
          count <= 0;
        else 
          count <= count + 1;
        end
      else 
        count <= count;
    end

endmodule 