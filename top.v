module top(clk,rst);
input clk,rst;
wire [26:0] instruction;
wire [1:0] jump_control;
wire [14:0] pc_load_data;
wire pc_roll_over,reg_wen,mem_we,alu_op2_sel;
wire [2:0] reg_raddr1,reg_addr2,reg_waddr;
wire [9:0] mem_waddr,mem_raddr;
wire [3:0] alu_opcode;
wire [15:0] op2_imm;
wire eq_flag;
wire [15:0] addr_out;
wire [15:0] result;
reg  [15:0] result_reg;
wire [15:0]mem_rdata;
wire [15:0]rdata1,rdata2;
wire [15:0]op2;
wire [15:0]write_back_data,op2_stage1_data; 
wire sign_extend,alu_op_mem_sel;
wire update_carry;
reg carry_reg;
assign op2_stage1_data = (alu_op2_sel) ? op2_imm : rdata2;
assign op2 = (alu_op_mem_sel) ? mem_rdata : op2_stage1_data;
assign write_back_data = (sign_extend) ? {{8{result_reg[7]}},result_reg[7:0]} : result_reg;

instruction_decoder id(clk,rst,instruction,jump_control,pc_load_data,pc_roll_over,reg_raddr1,reg_addr2,reg_wen,reg_waddr,mem_we,mem_waddr,mem_raddr,alu_opcode,update_carry,alu_op2_sel,op2_imm,sign_extend,alu_op_mem_sel);
program_counter pc(clk,rst,jump_control,eq_flag,pc_load_data,pc_roll_over,addr_out);
memory mem(clk,rst,mem_we,mem_waddr,mem_raddr,write_back_data,mem_rdata);
register_bank rb(clk,rst,reg_raddr1,reg_addr2,reg_wen,reg_waddr,write_back_data,rdata1,rdata2);
prom pr(addr_out,instruction);
alu a(alu_opcode,rdata1,op2,carry_reg,result,carry,eq_flag,neg);

always@(posedge clk or posedge rst)
begin
								if(rst)
								begin
																result_reg <= 16'd0;
																carry_reg <= 1'b0;
								end
								else
								begin
																result_reg <= result;
																if(update_carry)
																begin
																								carry_reg <= carry;
																end
																else
																begin
																								carry_reg <= carry_reg;
																end
								end
end
endmodule
