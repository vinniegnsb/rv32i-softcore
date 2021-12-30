module imm_gen(
	input sel,
	input [11:0] data_imm,
	output reg [31:0] generated_imm
	);

	// copy last bit from input across 20 remaining bits to sign extend
	always @(*) begin
		// if sel is enabled, pass through value
		if (sel) begin
			generated_imm = $signed(data_imm);
			// generated_imm = {{20{data_imm[11]}}, data_imm[11:0]};
		end
		else
			generated_imm = 32'd0;

		$display("generated_imm: %0d", generated_imm);

	end

endmodule // imm_gen