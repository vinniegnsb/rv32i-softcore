`include "register_file.v"
`include "alu.v"
`include "data_select_mux.v"
`include "imm_gen.v"

module control(
	// input [31:0] instr,
	// input branch_eq,
	// input branch_lt,

	// output reg pc_sel,
	// output reg imm_sel,					// 
	// output reg reg_write_en,
	// output reg branch_unsigned_sel,		// branch unsigned comparison select
	// output reg alu_data_A_sel,
	// output reg alu_data_B_sel,
	// output reg [3:0] alu_sel,
	// output reg mem_reg_write,
	// output reg wb_sel


	
	input clk_c,
	input [31:0] instr,
	output reg [31:0] result
	);



	// NEED TO ADD IN RESET SIGNAL IN THE FUTURE


	// control lines
	// reg [31:0] instr;
	reg branch_eq;
	reg branch_lt;

	// reg pc_sel;
	reg imm_sel;
	// reg reg_write_en;
	// reg branch_unsigned_sel;		// branch unsigned comparison select
	// reg alu_data_A_sel;
	// reg alu_data_B_sel;
	// reg [3:0] alu_sel;
	// reg mem_reg_write;
	// reg wb_sel;
	
	// registers and wires
	reg [6:0] opcode;
	reg [2:0] func3;
	reg [6:0] func7;

	// declare all of the registers for the register_file module
	// reg clk_c; // ?
	reg [4:0] addr_D_c;
	reg [4:0] addr_A_c;
	reg [4:0] addr_B_c;
	reg [31:0] data_D_c;
	reg reg_write_en_c;
	wire [31:0] data_A_c;
	wire [31:0] data_B_c;

	// input [3:0] alu_ctrl,
	// input [31:0] data_A,
	// input [31:0] data_B,
	// output reg [31:0] data_out

	wire [31:0] alu_input_A;
	wire [31:0] alu_input_B;
	wire [31:0] alu_out;
	reg [31:0] program_counter;
	wire [31:0] immediate;

	reg [3:0] alu_sel;
	reg alu_data_A_sel;
	reg alu_data_B_sel;

	// initial begin
	// 	// temporary placeholders
	// 	assign program_counter = 32'd0;
	// 	// assign immediate = 32'd0;
	// end

	// // reg file instantiation
	// register_file my_register_file(
	// 	.clk 			(clk_c),
	// 	// .addr_D			(addr_D_c),
	// 	.addr_D			(instr[11:7]),
	// 	// .addr_A			(addr_A_c),
	// 	.addr_A			(instr[19:15]),
	// 	// .addr_B			(addr_B_c),
	// 	.addr_B			(instr[24:20]),
	// 	.data_D			(data_D_c),			// rd
	// 	.reg_write_en	(reg_write_en_c),
	// 	.data_A 		(data_A_c),			// rs1
	// 	.data_B 		(data_B_c)			// rs2
	// 	);

	// // addr_D_c = instr[11:7];
	// // addr_A_c = instr[19:15];
	// // addr_B_c = instr[24:20];

	// alu my_alu(
	// 	.alu_ctrl		(alu_sel),
	// 	.data_A 		(alu_input_A),
	// 	.data_B 		(alu_input_B),
	// 	.data_out 		(alu_out)
	// 	);

	// // selects data_1 if select line is 0
	// data_select_mux alu_input_mux_A(
	// 	.data_select 	(alu_data_A_sel),
	// 	.data_1			(data_A_c),
	// 	.data_2 		(program_counter),
	// 	.data_out 		(alu_input_A)
	// 	);

	// // selects data_1 if select line is 0
	// data_select_mux alu_input_mux_B(
	// 	.data_select 	(alu_data_B_sel),
	// 	.data_1			(data_B_c),
	// 	.data_2 		(immediate),
	// 	.data_out 		(alu_input_B)
	// 	);

	// imm_gen my_imm_gen(
	// 	.sel (imm_sel),
	// 	.data_imm (instr[31:20]),
	// 	.generated_imm (immediate)
	// 	);


	// // PC points to next instruction to then decode
	// // assign opcode = instr[6:0];
	// // assign func3 = instr[14:12];
	// // assign func7 = instr[31:25];

	// always @(*) begin
	// 	opcode = instr[6:0];
	// 	func3 = instr[14:12];
	// 	func7 = instr[31:25];
	// end


	// // decode instructions to decide on control lines
	// // See page 130 for reference on instruction formats!
	// always @(*) begin
	// 	// @(negedge clk_c)
	// 	// 	reg_write_en_c = 1'b0;
	// 	case (opcode)

	// 		// U-TYPE
	// 		// opcode 0110111 -> LUI
	// 		7'b0110111:
	// 			;
	// 		// opcode 0010111 -> AUIPC
	// 		7'b0010111:
	// 			;
	// 		// J-TYPE
	// 		// if bits 6-5 are 11, then it's a jump/branch instruction
	// 		// opcode 1101111 -> JAL
	// 		7'b1101111:
	// 			;

	// 		// B-TYPE
	// 		// opcode 1100111 -> JALR
	// 		7'b1100111:
	// 			;
	// 		// opcode 1100011 -> Branch
	// 		7'b1100011:
	// 			case (func3)
	// 				// func3 000 -> BEQ
	// 				3'b000:
	// 					;
	// 				// func3 001 -> BNE
	// 				3'b001:
	// 					;
	// 				// func3 100 -> BLT
	// 				3'b100:
	// 					;
	// 				// func3 101 -> BGE
	// 				3'b101:
	// 					;
	// 				// func3 110 -> BLTU
	// 				3'b110:
	// 					;
	// 				// func3 111 -> BGEU
	// 				3'b111:
	// 					;
	// 			endcase

	// 		// S-TYPE
	// 		// opcode 0000011 -> load
	// 		7'b0000011:
	// 			case (func3)
	// 				// func3 000 -> LB
	// 				3'b000:
	// 					;
	// 				// func3 001 -> LH
	// 				3'b001:
	// 					;
	// 				// func3 010 -> LW
	// 				3'b010:
	// 					;
	// 				// func3 100 -> LBU
	// 				3'b100:
	// 					;
	// 				// func3 101 -> LHU
	// 				3'b101:
	// 					;
	// 			endcase

	// 		// opcode 0100011 -> store
	// 		7'b0100011:
	// 			case (func3)
	// 				// func3 000 -> SB
	// 				3'b000:
	// 					;
	// 				// func3 001 -> SH
	// 				3'b001:
	// 					;
	// 				// func3 010 -> SW
	// 				3'b010:
	// 					;
	// 			endcase

	// 		// I-TYPE
	// 		// opcode 0010011 -> 
	// 		7'b0010011: begin
	// 			alu_data_A_sel = 1'b0;
	// 			alu_data_B_sel = 1'b1;	// ALU takes generated immediate as an input
	// 			imm_sel = 1'b1;

	// 			reg_write_en_c = 1'b1;
	// 			data_D_c = alu_out;

	// 			$display("Time: %0d", $time);
	// 			$display("Instr: %0b", instr);
	// 			$display("Opcode: %0b", opcode);

	// 			// @(posedge clk_c) begin
	// 			// 	result = data_D_c;

	// 			// 	$display("Result: %0d", result);
	// 			// end

	// 			case (func3)
	// 				// func3 000 -> ADDI
	// 				3'b000:
	// 					alu_sel = 4'd0;
	// 				// func3 010 -> SLTI
	// 				3'b010:
	// 					alu_sel = 4'd5;
	// 				// func3 011 -> SLTIU
	// 				3'b011:
	// 					alu_sel = 4'd6;
	// 				// func3 100 -> XORI
	// 				3'b100:
	// 					alu_sel = 4'd4;
	// 				// func3 110 -> ORI
	// 				3'b110:
	// 					alu_sel = 4'd3;
	// 				// func3 111 -> ANDI
	// 				3'b111:
	// 					alu_sel = 4'd2;
	// 				// func3 001 -> SLLI
	// 				3'b001:
	// 					;
	// 				// func3 101 -> SRLI or SRAI
	// 				3'b101:
	// 					case (func7)
	// 						// func7 0000000 -> SRLI
	// 						7'b0000000:
	// 							;
							
	// 						// func7 0100000 -> SRAI
	// 						7'b0100000:
	// 							;
	// 					endcase
	// 			endcase
	// 		end

	// 		// R-TYPE
	// 		// opcode 0110011
	// 		7'b0110011: begin
	// 			alu_data_A_sel = 1'b0;
	// 			alu_data_B_sel = 1'b0;
	// 			imm_sel = 1'b0;

	// 			reg_write_en_c = 1'b1;
	// 			data_D_c = alu_out;

	// 			$display("Time: %0d", $time);
	// 			$display("Instr: %0b", instr);
	// 			$display("Opcode: %0b", opcode);


	// 			// result = data_D_c;

	// 			// $display("Result: %0d", result);

	// 			case (func3)
	// 				// func3 000 -> ADD or SUB
	// 				3'b000:
	// 					case (func7)
	// 						// func7 0000000 -> ADD
	// 						7'b0000000:
	// 							alu_sel = 4'd0;
	// 						// func7 0100000 -> SUB
	// 						7'b0100000:
	// 							alu_sel = 4'd1;
	// 					endcase
	// 				// func3 001 -> SLL
	// 				3'b001:
	// 					alu_sel <= 4'd7;
	// 				// func3 010 -> SLT
	// 				3'b010:
	// 					alu_sel <= 4'd5;
	// 				// func3 011 -> SLTU
	// 				3'b011:
	// 					alu_sel <= 4'd6;
	// 				// func3 100 -> XOR
	// 				3'b100:
	// 					alu_sel <= 4'd4;
	// 				// func3 101 -> SRL or SRA
	// 				3'b101:
	// 					case (func7)
	// 						// func7 0000000 -> SRL
	// 						7'b0000000:
	// 							alu_sel <= 4'd8;
	// 						// func7 0100000 -> SRA
	// 						7'b0100000:
	// 							alu_sel <= 4'd9;
	// 					endcase
	// 				// func3 110 -> OR
	// 				3'b110:
	// 					alu_sel <= 4'd3;
	// 				// func3 111 -> AND
	// 				3'b111:
	// 					alu_sel <= 4'd2;
	// 			endcase
	// 		end
	// 		// system instructions (not sure on type)
	// 		// opcode 0001111 -> FENCE
	// 		7'b0001111:
	// 			;
	// 		// opcode 1110011 -> ECALL
	// 		7'b1110011:
	// 			;
	// 		// opcode 1110011 -> EBREAK
	// 		7'b1110011:
	// 			;

	// 	endcase
	// end

	// always @(posedge clk_c) begin
	// 	data_D_c <= alu_out;
	// 	result <= data_D_c;
	// end


endmodule // control