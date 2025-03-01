//counter for count coordinates 

module counter # (parameter n = 9)
					(
                input clk, 
                input reset,
                input [n-1:0] compare,
                input enable,
                output reg [n-1:0] count,
                output logic complete
);

    always @ (posedge clk or negedge reset) begin
      if(!reset) begin
        count <= 0;
        complete <= 0;
      end
      else if(enable == 1) begin
        if(count == compare)  begin
          count <= 0;
          complete <= 1;
        end
        else begin
          count <= count + 1;
          complete <= 0;
        end
        end
      else begin
        count <= count;
        complete <= 0;
      end
    end

endmodule 