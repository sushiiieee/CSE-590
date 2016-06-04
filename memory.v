module memory(clk,rst,we,waddr,raddr,din,dout);
input clk,rst;
input we;
input [9:0]waddr,raddr;
input [15:0]din;
output reg [15:0]dout;
reg [15:0]mem[1023:0];
integer i;

always@(posedge clk or posedge rst)
begin
								if(rst)
								begin
																dout <= 16'd0;
																for(i=0;i<1024;i=i+1'b1)
																								mem[i] <= 16'd0;
								end
								else
								begin
																if(we)
																begin
																								mem[waddr] <= din;
																end
																else
																begin
																								mem[waddr] <= mem[waddr];
																end
																dout <= mem[raddr];
								end
end

endmodule
