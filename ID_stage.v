`include "register_file.v"

module ID_stage(
	input clk,

	input [31:0] instr,
	input [31:0] data_D,

	output [31:0] data_A,
	output [31:0] data_B,
	// output [31:0] immediate,
	output reg [31:0] immediate,

	output reg [3:0] alu_sel,

	output reg alu_data_A_sel,
	output reg alu_data_B_sel,

	output [31:0] reg_data_D_reading
	);


	reg [6:0] opcode;
	reg [2:0] func3;
	reg [6:0] func7;

	reg reg_write_en;

	// reg alu_data_A_sel;
	// reg alu_data_B_sel;

	register_file my_register_file(
		.clk 			(clk),
		.addr_D			(instr[11:7]),
		.addr_A			(instr[19:15]),
		.addr_B			(instr[24:20]),
		.data_D			(data_D),			// rd
		.reg_write_en	(reg_write_en),
		.data_A 		(data_A),			// rs1
		.data_B 		(data_B),			// rs2)

		.memory_at_D	(reg_data_D_reading)
		);

	// imm_gen my_imm_gen(
	// 	.sel			()
	// 	.data_imm
	// 	.generated_imm
	// 	);

	// don't necessarily need a dedicated immediate generator module


	// decoder logic

	// PC points to next instruction to then decode
	// assign opcode = instr[6:0];
	// assign func3 = instr[14:12];
	// assign func7 = instr[31:25];

	always @(*) begin
		opcode = instr[6:0];
		func3 = instr[14:12];
		func7 = instr[31:25];

		$display("Time: %0d", $time);
		$display("Instr: %0b", instr);
		$display("Opcode: %0b", opcode);
	end


	// decode instructions to decide on control lines
	// See page 130 for reference on instruction formats!
	always @(*) begin
		// @(negedge clk_c)
		// 	reg_write_en_c = 1'b0;
		case (opcode)

			// U-TYPE
			// opcode 0110111 -> LUI
			7'b0110111:
				;
			// opcode 0010111 -> AUIPC
			7'b0010111:
				;
			// J-TYPE
			// if bits 6-5 are 11, then it's a jump/branch instruction
			// opcode 1101111 -> JAL
			7'b1101111:
				;

			// B-TYPE
			// opcode 1100111 -> JALR
			7'b1100111:
				;
			// opcode 1100011 -> Branch
			7'b1100011:
				case (func3)
					// func3 000 -> BEQ
					3'b000:
						;
					// func3 001 -> BNE
					3'b001:
						;
					// func3 100 -> BLT
					3'b100:
						;
					// func3 101 -> BGE
					3'b101:
						;
					// func3 110 -> BLTU
					3'b110:
						;
					// func3 111 -> BGEU
					3'b111:
						;
				endcase

			// S-TYPE
			// opcode 0000011 -> load
			7'b0000011:
				case (func3)
					// func3 000 -> LB
					3'b000:
						;
					// func3 001 -> LH
					3'b001:
						;
					// func3 010 -> LW
					3'b010:
						;
					// func3 100 -> LBU
					3'b100:
						;
					// func3 101 -> LHU
					3'b101:
						;
				endcase

			// opcode 0100011 -> store
			7'b0100011:
				case (func3)
					// func3 000 -> SB
					3'b000:
						;
					// func3 001 -> SH
					3'b001:
						;
					// func3 010 -> SW
					3'b010:
						;
				endcase

			// I-TYPE
			// opcode 0010011 -> 
			7'b0010011: begin
				$display("\nentered!\n");
				alu_data_A_sel = 1'b0;

				alu_data_B_sel = 1'b1;	// ALU takes generated immediate as an input
				// imm_sel = 1'b1;

				reg_write_en = 1'b1;
				// data_D_c = alu_out;

				$display("Time: %0d", $time);
				$display("Instr: %0b", instr);
				$display("Opcode: %0b", opcode);

				// @(posedge clk_c) begin
				// 	result = data_D_c;

				// 	$display("Result: %0d", result);
				// end

				case (func3)
					// func3 000 -> ADDI
					3'b000: begin
						alu_sel = 4'd0;
						immediate = $signed({{20{instr[31]}}, instr[31:20]});
					end	
					// func3 010 -> SLTI
					3'b010: begin
						alu_sel = 4'd5;
						immediate = $signed({{20{instr[31]}}, instr[31:20]});
					end
					// func3 011 -> SLTIU
					3'b011: begin
						alu_sel = 4'd6;
						immediate = $signed({{20{instr[31]}}, instr[31:20]});
					end
					// func3 100 -> XORI
					3'b100: begin
						alu_sel = 4'd4;
						immediate = $signed({{20{instr[31]}}, instr[31:20]});
					end
					// func3 110 -> ORI
					3'b110: begin
						alu_sel = 4'd3;
						immediate = $signed({{20{instr[31]}}, instr[31:20]});
					end
					// func3 111 -> ANDI
					3'b111: begin
						alu_sel = 4'd2;
						immediate = $signed({{20{instr[31]}}, instr[31:20]});
					end
					// func3 001 -> SLLI
					3'b001: begin
						alu_sel = 4'd7;
						immediate = $signed({{27{instr[24]}}, instr[24:20]});
					end
					// func3 101 -> SRLI or SRAI
					3'b101:
						case (func7) // this is techincally the immediate field [31:25] (not func7)
							// func7 0000000 -> SRLI
							7'b0000000: begin
								alu_sel = 4'd8;
								immediate = $signed({{27{instr[24]}}, instr[24:20]});
							end
							// func7 0100000 -> SRAI
							7'b0100000: begin
								alu_sel = 4'd9;
								immediate = $signed({{27{instr[24]}}, instr[24:20]});
							end
						endcase
				endcase
			end

			// R-TYPE
			// opcode 0110011
			7'b0110011: begin
				alu_data_A_sel = 1'b0;
				alu_data_B_sel = 1'b0;
				// imm_sel = 1'b0;

				reg_write_en = 1'b1;
				// data_D_c = alu_out;

				$display("Time: %0d", $time);
				$display("Instr: %0b", instr);
				$display("Opcode: %0b", opcode);


				// result = data_D_c;

				// $display("Result: %0d", result);

				case (func3)
					// func3 000 -> ADD or SUB
					3'b000:
						case (func7)
							// func7 0000000 -> ADD
							7'b0000000:
								alu_sel = 4'd0;
							// func7 0100000 -> SUB
							7'b0100000:
								alu_sel = 4'd1;
						endcase
					// func3 001 -> SLL
					3'b001:
						alu_sel <= 4'd7;
					// func3 010 -> SLT
					3'b010:
						alu_sel <= 4'd5;
					// func3 011 -> SLTU
					3'b011:
						alu_sel <= 4'd6;
					// func3 100 -> XOR
					3'b100:
						alu_sel <= 4'd4;
					// func3 101 -> SRL or SRA
					3'b101:
						case (func7)
							// func7 0000000 -> SRL
							7'b0000000:
								alu_sel <= 4'd8;
							// func7 0100000 -> SRA
							7'b0100000:
								alu_sel <= 4'd9;
						endcase
					// func3 110 -> OR
					3'b110:
						alu_sel <= 4'd3;
					// func3 111 -> AND
					3'b111:
						alu_sel <= 4'd2;
				endcase
			end
			// system instructions (not sure on type)
			// opcode 0001111 -> FENCE
			7'b0001111:
				;
			// opcode 1110011 -> ECALL
			7'b1110011:
				;
			// opcode 1110011 -> EBREAK
			7'b1110011:
				;
			
			default: // no valid opcode passed
				;
		endcase
	end

endmodule // ID_stage