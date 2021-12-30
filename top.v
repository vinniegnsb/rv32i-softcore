`include "ID_stage.v"
`include "EX_stage.v"
`include "WB_stage.v"
// `include "control.v"

module top(
	input clk,
	input reset,

	input [31:0] instr
	);

	// wires and regs

	wire [31:0] writeback_data;
	wire [31:0] ID_to_EX_data_A;
	wire [31:0] ID_to_EX_data_B;
	wire [31:0] ID_to_EX_immediate;
	wire [3:0] ID_to_EX_alu_sel;
	wire ID_to_EX_mux_A_sel;
	wire ID_to_EX_mux_B_sel;

	wire [31:0] alu_result;

	reg [31:0] pc = 0;
	reg [31:0] data = 0;

	// instantiations
	// control my_control(
	// 	);


	ID_stage my_ID_stage(
		.clk 			(clk),
		.instr 			(instr),
		.data_D 		(writeback_data),

		.data_A			(ID_to_EX_data_A),
		.data_B 		(ID_to_EX_data_B),
		.immediate 		(ID_to_EX_immediate),
		.alu_sel		(ID_to_EX_alu_sel),
		.alu_data_A_sel (ID_to_EX_mux_A_sel),
		.alu_data_B_sel (ID_to_EX_mux_B_sel)
		);

	EX_stage my_EX_stage(
		.alu_sel 		(ID_to_EX_alu_sel),
		.data_A 		(ID_to_EX_data_A),
		.data_B 		(ID_to_EX_data_B),
		.immediate 		(ID_to_EX_immediate),
		.pc 			(pc),
		.mux_A_sel 		(ID_to_EX_mux_A_sel),
		.mux_B_sel 		(ID_to_EX_mux_B_sel),
		.data_out 		(alu_result)
		);

	WB_stage my_WB_stage(
		.WB_sel			(2'b1),
		.next_pc		(pc),
		.alu_result		(alu_result),
		.read_data		(data),

		.selected_data	(writeback_data)
		);


endmodule // top