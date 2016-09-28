`timescale 1ns / 1ps
module VGA 
(
input wire Clock, Reset,
//input wire [2:0] iColor,
output reg oHs,oVs
//output wire [2:0] oRGB,
//output wire [18:0] oColorAddress
);
	reg enableFila;
	reg ResetCol;
	reg ResetFila;
	wire [9:0] numColumna;
	wire [8:0] numFila;
	//assign oRGB = iColor;
	UPCOUNTER_POSEDGE #(.SIZE(10)) columnas  
	(
		.Clock(Clock),
		.Reset(ResetCol),
		.Initial(10'b0),
		.Enable(1'b1),
		.Q(numColumna)
	);
	
	UPCOUNTER_POSEDGE #(.SIZE(9)) filas 
	(
		.Clock(Clock),
		.Reset(ResetFila),
		.Initial(9'b0),
		.Enable(enableFila),
		.Q(numFila)
	);
		
	always @(*) //Dinamica de contadores
	begin
		if(Reset)
		begin
			ResetCol <=1;
			ResetFila<=1;
		end
		
		else
		begin
		
		if(numColumna == 10'd10 & numFila == 9'd10)
		begin
			enableFila <=1;
			ResetCol <= 1;
			ResetFila <= 1;
			oVs <=0;
			oHs <=1;
		end

		else if(numColumna ==10'd10)
		begin
			enableFila <=1;
			ResetCol <=1;
			ResetFila <=0;
			oHs<=0;
			oVs<=1;

			
		end
		
		else
		begin
			enableFila <=0;
			ResetCol <=0;
			ResetFila <=0;
			oHs<=1;
			oVs<=1;
		end
		
		end
	end
	

endmodule
