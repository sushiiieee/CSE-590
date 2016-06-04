module program_counter_tb();
reg clk,rst;
reg [1:0] jump_control;
reg eq_flag;
reg [11:0] load_data;
reg roll_over;
wire [11:0]addr_out;
program_counter a0(clk,rst,jump_control,eq_flag,load_data,roll_over,addr_out);
always 
								#10 clk=~clk;
initial
begin
								clk=1'b1;
								rst=1'b1;
								jump_control=2'b00;
								load_data=12'd45;
								eq_flag=0;
								roll_over=1'b0;

								#20
								rst=1'b0;
								#60
								jump_control=2'b01;
								#60
								jump_control=2'b10;
								load_data=12'b100;
								eq_flag=1'b1;
								#60
								jump_control=2'b11;
								eq_flag=1'b0;
								load_data=12'd45;
								#60
								jump_control=2'b00;
								#100;
								$finish;
end
endmodule




								

