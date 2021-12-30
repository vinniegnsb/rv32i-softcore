module wb_select_mux(
	input data_select,
	input [31:0] data_1,
	input [31:0] data_2,
	output [31:0] data_out);

	assign data_out = data_select ? data_2 : data_1;

endmodule // wb_select_mux