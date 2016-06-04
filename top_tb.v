
module top_tb();
reg clk,rst;
top dut(clk,rst);

always
begin
								#50 clk = ~clk;
								$write("test1");
end
								
initial
begin
								clk = 1'b0;
								rst = 1'b1;
								repeat(10)@(negedge clk);
								rst = 1'b0;
								repeat(200)@(negedge clk);
								$finish;
end

parameter NOP  = 5'b0_0000;
parameter HALT = 5'b1_0000;
parameter ADD = 5'b0_0001;
parameter ADDI = 5'b1_0001;
parameter SUB = 5'b0_0010;
parameter SUBI = 5'b1_0010;
parameter ASR = 5'b0_0011;
parameter ASRI = 5'b1_0011;
parameter LSL = 5'b0_0100;
parameter LSLI = 5'b1_0100;
parameter LSR = 5'b0_0101;
parameter LSRI = 5'b1_0101;
parameter AND = 5'b0_0110;
parameter ANDI = 5'b1_0110;
parameter OR = 5'b0_0111;
parameter ORI = 5'b1_0111;
parameter SLT = 5'b0_1000;
parameter SLTI = 5'b1_1000;
parameter INV = 5'b0_1001;
parameter MOV = 5'b0_1010;
parameter MOVI = 5'b1_1010;
parameter HD = 5'b0_1011;
parameter HDI = 5'b1_1011;
parameter BEQ = 5'b0_1100;
parameter BNEQ = 5'b0_1101;
parameter JMP = 5'b0_1110;
parameter LD_STR = 5'b1_1111;
parameter LDB = 2'b00;
parameter STB = 2'b01;
parameter LDW = 2'b10;
parameter STW = 2'b11;

always@(rst or dut.id.instruction)
begin
								if(!rst)
								begin
																case(dut.id.instruction[26:22])
																								HALT 	 : $write($time,"operation HALT current instruction addr is %d",dut.pc.addr_out);
																								default : $write("");
																endcase
								end
end

always@(rst or dut.id.instruction_q)
begin
								if(!rst)
								begin
																case(dut.id.instruction_q[26:22])
																								HALT 	 : $write("Next instruction addr is %d\n\n",dut.pc.addr_out);
																								ADD    : $write($time,"operation ADD ");
																								ADDI 	 : $write($time,"operation ADDI ");
																								SUB    : $write($time,"operation SUB ");
																								SUBI 	 : $write($time,"operation SUBI ");
																								ASR    : $write($time,"operation ASR ");
																								ASRI 	 : $write($time,"operation ASRI ");
																								LSL    : $write($time,"operation LSL ");
																								LSLI 	 : $write($time,"operation LSLI ");
																								LSR    : $write($time,"operation LSR ");
																								LSRI 	 : $write($time,"operation LSRI ");
																								AND    : $write($time,"operation AND ");
																								ANDI 	 : $write($time,"operation ANDI ");
																								OR     : $write($time,"operation OR ");
																								ORI    : $write($time,"operation ORI ");
																								SLT    : $write($time,"operation SLT ");
																								SLTI 	 : $write($time,"operation SLTI ");
																								INV    : $write($time,"operation INV ");
																								MOV    : $write($time,"operation MOV ");
																								MOVI 	 : $write($time,"operation MOVI ");
																								HD     : $write($time,"operation HD ");
																								HDI    : $write($time,"operation HDI ");
																								BEQ    : $write($time,"operation BEQ ");
																								BNEQ 	 : $write($time,"operation BNEQ ");
																								JMP    : $write($time,"operation JMP ");
																								LD_STR	:
																								begin
																																case(dut.id.instruction_q[21:20])
																																								LDB: $write($time,"operation LDB ");
																																								LDW: $write($time,"operation LDW ");
																																								STB: $write($time,"operation STB ");
																																								STW: $write($time,"operation STW ");
																																endcase
																								end

																								default: $write("");
																endcase
																case(dut.id.instruction_q[26:22])
																								ADD,ADDI:
																								begin
																																#1;
																																$write("carry_out is %b rd is %d rs1 is %d src2 is %d carry_in is %b\n\n",dut.a.carry,dut.a.result,dut.a.in1,dut.a.in2,dut.a.carry_in);
																								end
																								SLT,SLTI:
																								begin
																																#1;
																																$write("rd is %d rs1 is %d src2 is %d\n\n",dut.a.result,dut.a.in1,dut.a.in2);
																								end
																								SUB,SUBI:
																								begin
																																#1;
																																$write("neg is %b rd is %d rs1 is %d src2 is %d\n\n",dut.a.neg,dut.a.result,dut.a.in1,dut.a.in2);
																								end
																								ASR,LSL,LSR,AND,OR,ASRI,LSLI,LSRI,ANDI,ORI:
																								begin
																																#1;
																																$write("rd is %b rs1 is %b src2 is %b\n\n",dut.a.result,dut.a.in1,dut.a.in2);
																								end
																								HD,HDI:
																								begin
																																#1;
																																$write("rd is %d rs1 is %b src2 is %b\n\n",dut.a.result,dut.a.in1,dut.a.in2);
																								end
																								INV:
																								begin
																																#1;
																																$write("rd is %b rs1 is %b \n\n",dut.a.result,dut.a.in1);
																								end
																								MOV,MOVI:
																								begin
																																#1;
																																$write("rd is %d src2 is %d\n\n",dut.a.result,dut.a.in2);
																								end
																								LD_STR:
																								begin
																																#1;
																																$write("input is is %d ",dut.a.in2);
																								end
																								BEQ,BNEQ:
																								begin
																																#1;
																																$write("rs1 is %d rs2 is %d label is %d current Instruction addr is ",dut.a.in1,dut.a.in2,dut.pc_load_data,dut.pc.addr_out);
																								end
																								JMP:
																								begin
																																#1;
																																$write("current instruction addr is %d label is %d ",dut.pc.addr_out,dut.pc_load_data);
																								end
																								default:
																								begin
																																#1;
																																$write("");
																								end
																endcase

								end
end
always@(rst or dut.id.instruction_q_q)
begin
								if(!rst)
								begin
																case(dut.id.instruction_q_q[26:22])
																								LD_STR:
																								begin
																																#1;
																																$write("output is %d\n\n",dut.write_back_data);
																								end
																								BEQ,BNEQ,JMP:
																								begin
																																#1;
																																$write("Next address is %d\n\n",dut.addr_out);
																								end
																endcase
								end
end

endmodule
