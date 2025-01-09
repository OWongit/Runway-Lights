module landingLights (clk, reset, w, out);
	input logic clk, reset;
	input logic [1:0] w;
	output logic [2:0] out;

	// State variables
	enum logic [2:0]  { in1 = 3'b010, out2 = 3'b101, left = 3'b100, right = 3'b001 } ps, ns;
	
	// Next State logic
	always_comb begin
		case (ps)
			out2: 	ns = in1;
			in1: 		begin
							case(w)
								2'b00: ns = out2; //calm
								2'b01: ns = left; //right to left
								2'b10: ns = right; //left to right
								default: ns = in1;
							endcase
						end
			left: 	begin
							case(w)
								2'b00: ns = in1; //calm
								2'b01: ns = right; //right to left
								2'b10: ns = in1; //left to right
								default: ns = left;
							endcase
						end
			right: 	begin
							case(w)
								2'b00: ns = in1; //calm
								2'b01: ns = in1; //right to left
								2'b10: ns = left; //left to right
								default: ns = right;
							endcase
						end
	endcase
end

	// Output logic
	assign out = ps;
	
	// DFFs
	always_ff @(posedge clk) begin
		if (reset)
			ps <= in1;
		else
			ps <= ns;
		end

endmodule