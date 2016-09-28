`timescale 1ns / 1ps
//------------------------------------------------
module UPCOUNTER_POSEDGE # (parameter SIZE=16)
(
input wire Clock, Reset,
input wire [SIZE-1:0] Initial,
input wire Enable,
output reg [SIZE-1:0] Q
);


  always @(posedge Clock )
  begin
      if (Reset)
        Q = Initial;
      else
		begin
		if (Enable)
			Q = Q + 1;
			
		end			
  end

endmodule
//----------------------------------------------------
module FFD_POSEDGE_SYNCRONOUS_RESET # ( parameter SIZE=8 )
(
	input wire				Clock,
	input wire				Reset,
	input wire				Enable,
	input wire [SIZE-1:0]	D,
	output reg [SIZE-1:0]	Q
);
	

always @ (posedge Clock) 
begin
	if ( Reset )
		Q <= 0;
	else
	begin	
		if (Enable) 
			Q <= D; 
	end	
 
end//always

endmodule


//----------------------------------------------------------------------

module RAM_SINGLE_READ_PORT # ( parameter DATA_WIDTH= 16, parameter
ADDR_WIDTH=8, parameter MEM_SIZE=8 )
(
	input wire Clock,
	input wire iWriteEnable,
	input wire[ADDR_WIDTH-1:0] iReadAddress,
	input wire[ADDR_WIDTH-1:0] iWriteAddress,
	input wire[DATA_WIDTH-1:0] iDataIn,
	output reg [DATA_WIDTH-1:0] oDataOut
);

reg [DATA_WIDTH-1:0] Ram [MEM_SIZE:0];

always @(posedge Clock)
	begin
	if (iWriteEnable)
		Ram[iWriteAddress] <= iDataIn;
	oDataOut <= Ram[iReadAddress];
	end
endmodule
