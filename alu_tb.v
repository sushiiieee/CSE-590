`timescale 1ns/1ns
module alu_tb();
reg [3:0] operation;
reg [15:0] in1,in2;
wire [15:0] rd;
wire carry,eq,neg;
alu a1(operation,in1,in2,rd,carry,eq,neg);

initial
begin
	in1=16'd24;
	in2=16'd26;
	operation =4'b0001;
	#20
	in2 =16'd3;
	operation =4'b0010;
	#20
	operation =4'b0011;
	#20
	operation =4'b0100;
	#20
	operation =4'b0101;
	#20
	operation =4'b0110;
	#20
	operation =4'b0111;
	#20
	operation =4'b1000;
	#20
	operation=4'b1001;
	#20
	operation=4'b1010;
	#20
	operation=4'b1011;
	#20
	operation=4'b1100;
	#100
	$finish;
end
endmodule
