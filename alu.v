module alu(
	input [3:0] alu_ctrl,
	input /*signed*/ [31:0] data_A,
	input /*signed*/ [31:0] data_B,
	output reg [31:0] data_out
	);

	// wire [31:0] intermediate_shift;

	// should change so that all operations default to signed

	always @(*) begin
		case (alu_ctrl)
			// arithmetic operations
			4'd0: data_out = data_A + data_B; 					// add
			4'd1: data_out = data_A - data_B; 					// subtract
			// 4'd2: data_out = data_A * data_B; 				// multiply
			// 4'd3: data_out = data_A / data_B; 				// divide

			// bitwise logical operations
			4'd2: data_out = data_A & data_B; 					// and
			4'd3: data_out = data_A | data_B; 					// or
			4'd4: data_out = data_A ^ data_B; 					// xor
			// 4'b0111: data_out = data_A & data_B; 			// one's complement

			// set less than operators
			4'd5: data_out = $signed(data_A) < $signed(data_B); // set less than
			4'd6: data_out = data_A < data_B; 					// set less than unsigned

			// bit shift operations (see page 18 of RISC spec for details)
			// both R and I type use bits 20:24 as the second value
			// for bit shift operations
			4'd7: data_out = data_A << data_B[4:0]; 			// shift left logical
			4'd8: data_out = data_A >> data_B[4:0]; 			// shift right logical

			// 4'b1001: begin 
			// intermediate_shift = data_A >> data_B[4:0]; 		// shift right arithmetic
			// data_out = {data_B{intermediate_shift[31]}};
			// end

			4'd9: data_out = $signed(data_A >> data_B[4:0]); 	// shift right arithmetic

			default: data_out = 0; 								// set to 0 as place holder
			
		endcase
		$display("data_A: %0d data_B: %0d data_out: %0d", data_A, data_B, data_out);
		$display("alu_ctrl: %0d\n", alu_ctrl);
	end

endmodule