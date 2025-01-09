module simple (clk, reset, w, out);
	input logic clk, reset, w[1:0];
	output logic out[2:0];

	// State variables
	enum logic [1:0] { calm = 2'b00, RtoL = 2b'01, LtoR = 2b'10} ps, ns;

	// Next State logic
	always_comb begin
		case (ps)
			calm: 	if (w == RtoL) ns = RtoL;
						if (w == LtoR) ns = LtoR;
						else ns = calm;
			RtoL: 	if (w == calm) ns = calm;
						if (w == LtoR) ns = LtoR;
						else ns = RtoL;
			LtoR: if (w == calm) ns = calm;
					if (w == RtoL) ns = RtoL;
						else ns = LtoR;
		endcase
	end

	// Output logic - could also be another always_comb block.
	assign out = (ps == got_two);

	// DFFs
	always_ff @(posedge clk) begin
		if (reset)
			ps <= none;
		else
			ps <= ns;
		end

endmodule

//testbench
	module simple_testbench();
	logic clk, reset, w;
	logic out;

	simple dut (clk, reset, w, out);

	// Set up a simulated clock.
	parameter CLOCK_PERIOD=100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk; // Forever toggle the clock
	end

	// Set up the inputs to the design. Each line is a clock cycle.
	initial begin
									@(posedge clk);
		reset <= 1; 			@(posedge clk); // Always reset FSMs at start
		reset <= 0; w <= 0;  @(posedge clk);
									@(posedge clk);
									@(posedge clk);
									@(posedge clk);
						w <= 1;  @(posedge clk);
						w <= 0;  @(posedge clk);
						w <= 1;  @(posedge clk);
									@(posedge clk);
									@(posedge clk);
									@(posedge clk);
						w <= 0;  @(posedge clk);
									@(posedge clk);
		$stop; // End the simulation.
	end
endmodule