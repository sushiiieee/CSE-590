module instruction_decoder(clk,rst,instruction,
								jump_control,pc_load_data,pc_roll_over, // PC
								reg_raddr1,reg_raddr2,reg_wen,reg_waddr, // Register Bank
								mem_we,mem_waddr,mem_raddr, // memory
								alu_opcode,update_carry,alu_op2_sel/*0 - register 1 - Immediate */,op2_imm, //Alu
								sign_extend,alu_op_mem_sel //1 - mem data 0 - mux1 data
);

input clk,rst;
input [26:0] instruction;
output reg [1:0]jump_control;
output reg [14:0]pc_load_data;
output reg pc_roll_over,reg_wen,mem_we,alu_op2_sel;
output reg [2:0]reg_raddr1,reg_raddr2,reg_waddr;
output reg [9:0]mem_waddr,mem_raddr;
output reg [3:0]alu_opcode;
output [15:0]op2_imm;
output reg	sign_extend,alu_op_mem_sel,update_carry;
reg [15:0]op2_imm;

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
parameter BEQI = 5'b1_1100;
parameter BNEQ = 5'b0_1101;
parameter BNEQI = 5'b1_1101;
parameter JMP = 5'b0_1110;
parameter LD_STR = 5'b1_1111;
parameter LDB = 2'b00;
parameter STB = 2'b01;
parameter LDW = 2'b10;
parameter STW = 2'b11;
parameter REG_SEL = 1'b0;
parameter IMM_SEL = 1'b1;
parameter MEM_SEL = 1'b1;


reg [26:0]instruction_q,instruction_q_q;

always@(posedge clk or posedge rst)
begin
								if(rst)
								begin
																instruction_q <= 28'd0;
																instruction_q_q <= 28'd0;
								end
								else
								begin
																instruction_q <= instruction;
																instruction_q_q <= instruction_q;
								end
end

always@(instruction)
begin
								pc_roll_over = 1'b0;
								reg_raddr1 = 3'd0;
								reg_raddr2 = 3'd0;
								mem_raddr = 0;
								case(instruction[26:22])
																NOP:
																begin
																								pc_roll_over = 1'b0;
																								reg_raddr1 = 3'd0;
																								reg_raddr2 = 3'd0;
																end
																HALT:
																begin
																								pc_roll_over = 1'b1;
																								reg_raddr1 = 3'd0;
																								reg_raddr2 = 3'd0;
																end
																ADD,SUB,ASR,LSL,LSR,AND,OR,SLT,
																								ADDI,SUBI,ASRI,LSLI,LSRI,ANDI,ORI,SLTI:
																begin
																								reg_raddr1 = instruction[18:16];
																								reg_raddr2 = instruction[2:0];
																end
																MOV,MOVI:
																begin
																								reg_raddr2 = instruction[2:0];
																end
																INV:
																begin
																								reg_raddr1 = instruction[18:16];
																end
																BEQ,BNEQ:
																begin
																								reg_raddr1 = instruction[21:19];
																								reg_raddr2 = instruction[18:16];
																end

																LD_STR:
																begin
																								case(instruction[21:20])
																																LDB,LDW:
																																begin
																																								mem_raddr = instruction[9:0];
																																end
																																STB,STW:
																																begin
																																								reg_raddr2 = instruction[19:17];
																																end
																								endcase
																end
																default:
																begin
																								mem_raddr = 0;
																								pc_roll_over = 1'b0;
																								reg_raddr1 = 3'd0;
																								reg_raddr2 = 3'd0;
																end
								endcase
end

always@(instruction_q)
begin
								alu_opcode = 4'b0000;
								op2_imm = 16'd0;
								alu_op2_sel = 1'b0;
								jump_control = 2'd0;
								pc_load_data = 15'd0;
								alu_op_mem_sel = 1'b0;
								update_carry = 1'b0;
								case(instruction_q[26:22])
																ADD,ADDI:
																								update_carry = 1'b1;
																default:
																								update_carry = 1'b0;
								endcase

								case(instruction_q[26:22])
																ADD,SUB,ASR,LSL,LSR,AND,OR,SLT,INV,MOV:
																begin
																								alu_opcode = instruction_q[25:22];
																								alu_op2_sel = 1'b0;//register
																end
																ADDI,SUBI,ASRI,LSLI,LSRI,ANDI,ORI,SLTI,MOVI:
																begin
																								alu_opcode = instruction_q[25:22];
																								alu_op2_sel = 1'b1;//Immediate
																								op2_imm = instruction_q[15:0];
																end
																BEQ:
																begin
																								alu_opcode = instruction_q[25:22];
																								alu_op2_sel = 1'b0;//register
																								jump_control = 2'b10;
																								pc_load_data = instruction_q[14:0];
																end
																//	BEQI:
																//	begin
																//									alu_opcode = instruction_q[25:22];
																//									alu_op2_sel = 1'b1;//Immediate
																//									op2_imm = instruction_q[15:0];
																//									jump_control = 2'b10;
																//									pc_load_data = instruction_q[14:0];
																//	end

																BNEQ:
																begin
																								alu_opcode = 4'b1100;
																								alu_op2_sel = 1'b0;
																								jump_control = 2'b11;
																								pc_load_data = instruction_q[14:0];
																end
																//	BNEQI:
																//	begin
																//									alu_opcode = 4'b1100;
																//									alu_op2_sel = 1'b1;
																//									op2_imm = instruction_q[15:0];
																//									jump_control = 2'b11;
																//									pc_load_data = instruction_q[11:0];
																//	end
																JMP:
																begin
																								jump_control = 2'b01;
																								pc_load_data = instruction_q[14:0];
																end
																LD_STR:
																begin
																								alu_opcode = 4'b1010;
																								if(!instruction_q[20])
																								begin
																																alu_op_mem_sel = 1'b1;
																								end
																								else
																								begin
																																alu_op_mem_sel = 1'b0;
																								end
																end

																default:
																begin
																								alu_opcode = 4'b0000;
																								op2_imm = 16'd0;
																								alu_op2_sel = 1'b0;
																								jump_control = 2'b00;
																								pc_load_data = 15'd0;
																end
								endcase
end

always@(instruction_q_q)
begin
								reg_wen = 1'b0;
								reg_waddr = 3'd0;
								mem_waddr = 0;
								mem_we = 1'b0;
								sign_extend = 1'b0;
								case(instruction_q_q[26:22])
																ADD,ADDI,SUB,SUBI,ASR,ASRI,LSL,LSLI,LSR,LSRI,AND,ANDI,OR,ORI,SLT,SLTI,INV,MOV,MOVI:
																begin
																								reg_wen = 1'b1;
																								reg_waddr = instruction_q_q[21:19];
																end
																LD_STR:
																begin
																								case(instruction_q_q[21:20])
																																LDB:
																																begin
																																								reg_wen = 1'b1;
																																								reg_waddr = instruction_q_q[19:17];
																																								sign_extend = 1'b1;
																																end
																																LDW:
																																begin
																																								reg_wen = 1'b1;
																																								reg_waddr = instruction_q_q[19:17];
																																								sign_extend = 1'b0;
																																end
																																STB:
																																begin
																																								mem_we = 1'b1;
																																								mem_waddr = instruction_q_q[9:0];
																																								sign_extend = 1'b1;
																																end
																																STW:
																																begin
																																								mem_we = 1'b1;
																																								mem_waddr = instruction_q_q[9:0];
																																								sign_extend = 1'b0;
																																end
																								endcase
																end
																default:
																begin
																								mem_waddr = 0;
																								reg_wen = 1'b0;
																								reg_waddr = 3'd0;
																								mem_we = 1'b0;
																								sign_extend = 1'b0;
																end
								endcase
end

endmodule
