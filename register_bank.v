module register_bank(clk,rst,raddr1,raddr2,wen,waddr,wdata,rdata1,rdata2);
input clk,rst;
input wen;
input [2:0]raddr1,raddr2,waddr;
input [15:0]wdata;
output reg [15:0]rdata1,rdata2;

reg [15:0]reg_bank[7:0];
integer i;

always@(posedge clk or posedge rst)
begin
								if(rst)
								begin
																rdata1 <= 16'd0;
																rdata2 <= 16'd0;
																for(i=0;i<8;i=i+1'b1)
																begin
																								reg_bank[i] <= 16'd0;
																end
								end
								else
								begin
																rdata1 <= reg_bank[raddr1];
																rdata2 <= reg_bank[raddr2];
																if(wen)
																								reg_bank[waddr] <= wdata;
																else
																								reg_bank[waddr] <= reg_bank[waddr];
								end
end

endmodule
