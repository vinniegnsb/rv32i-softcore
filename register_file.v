module register_file(
	input clk,
	input [4:0] addr_D,
	input [4:0] addr_A,
	input [4:0] addr_B,
	input [31:0] data_D,			// rd ??
	input reg_write_en,
	output reg [31:0] data_A,		// rs1
	output reg [31:0] data_B,		// rs2

    output reg [31:0] memory_at_D
	);

	// creating an array of all the registers (x0-x31)
	reg [31:0] register_array [31:0];

	// not sure if I need to initialize registers from array

	// x0 is hardwired zero

    // THEREFORE WRITES TO x0 MUST BE IGNORED!!!

	integer i;
	initial begin
		for (i = 0; i < 32; i = i + 1)
			register_array[i] = 0;
	end

    // assign register_array[addr_D] = (data_D != register_array[addr_D]) ? 

	// always @(posedge clk) begin
 //        if ((reg_write_en) && (addr_D > 0) && (register_array[addr_D] != data_D)) begin
 //            $display("T%0d; %0d stored at x%0d\n", $time, data_D, addr_D);
 //            register_array[addr_D] <= data_D;
 //        end
	// 	// read register contents
	// 	data_A <= register_array[addr_A];
	// 	data_B <= register_array[addr_B];
	// end

    always @(*) begin
        data_A = register_array[addr_A];
        data_B = register_array[addr_B];

        memory_at_D = register_array[addr_D];
    end

    always @(posedge clk) begin
        // if ((reg_write_en) && (addr_D > 0) && (register_array[addr_D] != data_D)) begin
        if ((reg_write_en)) begin
            register_array[addr_D] <= data_D;
            $display("T%0d; %0d stored at x%0d\n", $time, data_D, addr_D);
        end
    end

    // always @(negedge clk) begin
    //     if (reg_write_en) begin
    //         register_array[addr_D] <= data_D;
    //         $display("%0b stored at %0d\n", data_D, addr_D);
    //     end
    // end

endmodule // register_file