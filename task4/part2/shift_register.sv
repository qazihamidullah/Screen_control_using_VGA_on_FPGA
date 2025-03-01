//Linear feedback shift register Task 4 part B

module shift_register#(
  parameter width         = 7,
  parameter default_value = 5,
  parameter max_value     = 119,
  parameter min_value     = 0
  
        ) (
							input logic clk, reset, enable,
							output logic [width-1:0] shift_value
							);		
							
      logic value0, value1, value;
          assign value0 = (shift_value[1] ^ shift_value[5]);
					assign value1 = (shift_value[3] ^ shift_value[2]);
					
					assign value = value0 ^ value1;
			always @ (posedge clk or negedge reset) begin

				if(!reset)
					shift_value <= default_value;
				else if(enable) 
            begin
					    // shift_value[8] <= shift_value[7];
					    // shift_value[7] <= shift_value[6];
              // shift_value[6] <= shift_value[5];
              // shift_value[5] <= shift_value[4];
              // shift_value[4] <= shift_value[3];
              // shift_value[3] <= shift_value[2];
              // shift_value[2] <= shift_value[1];
              // shift_value[1] <= shift_value[0];
              // shift_value[0] <= value;
              shift_value[width-1:1]       <=  shift_value[width-2:0];
              shift_value[0]                <= value;
            end 
        end
									
endmodule 