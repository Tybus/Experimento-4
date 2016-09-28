`timescale 1ns / 1ps

module TestBench;

	// Inputs
	reg Clock;
	reg Reset;
	reg [2:0] iColor;
	
	// Outputs
	wire [2:0] oRGB;
	wire oHs,oVs;
	wire [18:0] oColorAddress;
	// Instantiate the Unit Under Test (UUT)
	VGA vga (
		.Clock(Clock), 
		.oHs(oHs), 
		.oVs(oVs),
		.Reset(Reset),
		
		//.iColor(iColor),
		.oRGB(oRGB),
		.oColorAddress(oColorAddress)
	);
	
	always
	begin
		#5  Clock =  ! Clock;

	end

	initial begin
		// Initialize Inputs
		Clock = 0;
		Reset = 1;
		#100
		Reset =0;
		// Wait 100 ns for global reset to finish        
		// Add stimulus here

	end
      
endmodule
