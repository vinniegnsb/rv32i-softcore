module WB_stage(
	input [1:0] WB_sel,
	input [31:0] next_pc,
	input [31:0] alu_result,
	input [31:0] read_data,

	output reg [31:0] selected_data
	);

	always @(*) begin
		case (WB_sel)
			2'd0 : selected_data = read_data;
			2'd1 : selected_data = alu_result;
			2'd2 : selected_data = next_pc;
			default : selected_data = 32'd0;
		endcase
	end

endmodule // WB_stage