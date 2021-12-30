`include "alu.v"
`include "data_select_mux.v"

module EX_stage(
	input [3:0] alu_sel,
	input [31:0] data_A,
	input [31:0] data_B,

	input [31:0] immediate,
	input [31:0] pc,

	input mux_A_sel,
	input mux_B_sel,

	output [31:0] data_out
	);


	wire [31:0] alu_input_A;
	wire [31:0] alu_input_B;

	always @(*) begin
		$display("alu_input_A: %0d\nalu_input_B: %0d", alu_input_A, alu_input_B);
		$display("immediate: %0d", immediate);
		$display("mux_B_sel: %0d", mux_B_sel);
	end

	// assign alu_input_A = mux_A_sel ? data_A : pc;
	assign alu_input_A = mux_A_sel ? pc : data_A;
	// assign alu_input_B = mux_B_sel ? data_B : immediate;
	assign alu_input_B = mux_B_sel ? immediate : data_B;


	alu my_alu(
		.alu_ctrl		(alu_sel),
		.data_A			(alu_input_A),
		.data_B			(alu_input_B),
		.data_out		(data_out)
		);

	// data_select_mux data_A_mux(
	// 	.data_select 	(mux_A_sel),
	// 	.data_1 		(data_A),
	// 	.data_2 		(pc),
	// 	.data_out 		(alu_input_A)
	// 	);

	// data_select_mux data_B_mux(
	// 	.data_select 	(mux_B_sel),
	// 	.data_1 		(data_B),
	// 	.data_2 		(immediate),
	// 	.data_out 		(alu_input_B)
	// 	);

	// branch_comp my_branch_comp();


endmodule // EX_stage