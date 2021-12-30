module branch_comp(
	input [31:0] data_A,
	input [31:0] data_B,
	input unsigned_comp, // control line
	output branch_eq,
	output branch_lt
	);

	reg placeholder;

	// test equal
	assign branch_eq = (data_A == data_B);

	// test less than
	assign branch_lt = data_A < data_B;

endmodule // branch_comp