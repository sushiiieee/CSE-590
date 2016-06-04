module program_counter(clk,rst,jump_control,eq_flag,load_data,roll_over,addr_out);
input clk,rst;
input [1:0]jump_control;
input eq_flag;
input signed [14:0]load_data;
input roll_over;
output reg signed [15:0]addr_out;
reg signed [15:0]temp_addr;

always@(posedge clk or posedge rst)
begin
								if(rst)
								begin
																addr_out <= 12'd0;
								end
								else
								begin
																if(roll_over)
																begin
																								addr_out <= 12'd0;
																end
																else
																begin
																								case(jump_control)
																																2'b00: addr_out <= addr_out + 1'b1; //No Jump
																																2'b01: addr_out <= {addr_out[15:13],load_data[11:0],1'b0}; //Unconditional Jump
																																2'b10:
																																								begin
																																																temp_addr = $signed({load_data,$signed(1'b0)});
																																																temp_addr = temp_addr + addr_out;
																																																addr_out <= (eq_flag) ? temp_addr : addr_out + 1'b1; //BEQ
																																								end
																																2'b11: 
																																								begin
																																																temp_addr = $signed({load_data,$signed(1'b0)});
																																																temp_addr = temp_addr + addr_out;
																																																addr_out <= !(eq_flag) ? temp_addr : addr_out + 1'b1; //BNEQ
																																								end
																								endcase
																end
								end
end

endmodule
