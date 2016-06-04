module alu(operation,in1,in2,carry_in,result,carry,eq,neg);
input [3:0] operation;
input [15:0] in1,in2;
input carry_in;
output  reg [15:0] result;
output reg carry,eq,neg;
reg carry_reg;
reg [15:0]temp_reg,temp_in2;
integer i;
parameter ADD = 4'b0001;
parameter SUB = 4'b0010;
parameter ASR = 4'b0011;
parameter LSL = 4'b0100;
parameter LSR = 4'b0101;
parameter AND = 4'b0110;
parameter OR  = 4'b0111;
parameter SLT = 4'b1000;
parameter INV = 4'b1001;
parameter MOV = 4'b1010;
parameter HD   = 4'b1011;
parameter COMP = 4'b1100;

always @(operation,in1,in2)
begin
		carry  = 1'b0;
		eq = 1'b0;
		neg  = 1'b0;
		case(operation)
				ADD :
				begin
						{carry,result} = in1 + in2 + carry_in;
				end
				SUB:
				begin
						temp_in2 = ~in2;
						{carry_reg,result} =in1 + temp_in2;
						if(carry_reg)
						begin
								result = result + 1'b1;
								neg = 1'b0;
						end
						else
						begin
								result = ~result;
								if(result == 0)
																neg = 1'b0;
								else
																neg = 1'b1;
						end
				end
				SLT:
				begin
						temp_in2 = ~in2;
						{carry_reg,result} =in1 + temp_in2;
						if(carry_reg)
						begin
								result = 16'd0;
						end
						else
						begin
								result = 16'd1;
						end
				end
				ASR:
				begin
						result = {{16{in1[15]}},in1} >> in2;
				end
				LSL:
				begin
						result = in1 << in2;
				end
				LSR:
				begin
						result = in1 >> in2;
				end
				AND:
				begin
						result = in1 & in2;
				end
				OR:
				begin
						result =in1 | in2;
				end
				INV:
				begin
						result = ~(in1);
				end
				MOV:
				begin
						result = in2;
				end
				HD,COMP:
				begin
						temp_reg = in1 ^ in2;
						eq = !(|(temp_reg));
						result  = 15'd0;
						for(i=0;i<16;i=i+1'b1)
								result  = result + temp_reg[i];
				end
						default:
						begin
								result =0;
								carry = 1'b0;
								eq = 1'b0;
								neg  = 1'b0;
						end
				endcase

		end
		endmodule
