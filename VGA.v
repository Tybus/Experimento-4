`timescale 1ns / 1ps
module VGA 
(
input wire Clock, Reset2,
//input wire [2:0] iColor,
output wire oHs,oVs,
output wire [2:0] oRGB,
output reg [18:0] oColorAddress
);
	wire Clock2;
	wire enableFila;
	wire ResetCol;
	wire ResetFila;
	wire [15:0] numColumna;
	wire [8:0] numFila;
	
	ClockDiv2 clocker
	(
		.Clock(Clock),
		.Reset(Reset2),
		.Clock2(Clock2)
	);
	
	UPCOUNTER_POSEDGE #(.SIZE(16)) columnas  
	(
		.Clock(Clock2),
		.Reset(ResetCol),
		.Initial(16'b0),
		.Enable(1'b1),
		.Q(numColumna)
	);
	
	UPCOUNTER_POSEDGE #(.SIZE(9)) filas 
	(
		.Clock(Clock2),
		.Reset(ResetFila),
		.Initial(9'b0),
		.Enable(enableFila),
		.Q(numFila)
	);
	
	Reseter reseteador
	(
		.Clock(Clock),
		.Reset(Reset2),
		.newReset(Reset)
	);
	
	assign FinFila = (numFila == 521)? 1'b1 : 1'b0;
	assign FinColumna = (numColumna == 800)? 1'b1 : 1'b0;
	
	assign oHs = (numColumna >= 656 && numColumna < 752)? 1'b0 : 1'b1;
	assign oVs = (numFila >= 490 && numFila < 492)? 1'b0 : 1'b1;
	
	assign ResetCol = (FinColumna == 1 || Reset == 1)? 1'b1 : 1'b0;
	assign ResetFila = (FinFila == 1 || Reset == 1)? 1'b1 : 1'b0;
	
	assign enableFila = (FinColumna == 1)? 1'b1 : 1'b0;
	
	assign oRGB = (numColumna < 640 && numFila < 480)? 3'd2 : 0;
	
	/*always @(*) //Dinamica de contadores
	begin
		if(Reset) //Inciio
		begin
			ResetCol <=1;
			ResetFila <=1;
			oColorAddress<=0;
			oVs <=1;
			oHs <=1;
			enableFila <=0;
			oRGB <= 3'd0;
		end
		
		else
		begin
		
		
		
		if(numColumna > 16'd639 & numColumna <=16'd8639 & numFila == 9'd479) 
		begin // TFP VS
			enableFila <=0;
			ResetCol <= 0;
			ResetFila <= 0;
			oVs <=1;
			oHs <=1;
			oColorAddress <=0;
			oRGB <= 3'd0;
		end
		
		else if(numColumna > 16'd8639 & numColumna<= 16'd10239 & numFila == 9'd479)
		begin // TPW VS
			enableFila <=0;
			ResetCol <= 0;
			ResetFila <= 0;
			oVs <=0;
			oHs <=1;
			oColorAddress<=0;
			oRGB <= 3'd0;
		end
		
		else if(numColumna > 16'd10239 & numColumna < 35839 & numFila == 9'd479)
		begin //TBP VS
			enableFila <=0;
			ResetCol <= 0;
			ResetFila <= 0;
			oVs <=1;
			oHs <=1;
			oColorAddress<=0;
			oRGB <= 3'd0;
		end
		
		else if(numColumna == 35839 & numFila == 9'd479)
		begin //Reset after VS
			enableFila <=1;
			ResetCol <= 1;
			ResetFila <= 1;
			oVs <=1;
			oHs <=1;
			oColorAddress<=0;
			oRGB <= 3'd0;
		end
		
		else if(numColumna >16'd639 & numColumna <= 16'd655)
		begin //TFP HS
			enableFila <=0;
			ResetCol <=0;
			ResetFila <=0;
			oHs<=1;
			oVs<=1;
			oColorAddress<=0;
			oRGB <= 3'd0;
		end
		
		else if(numColumna > 16'd655 & numColumna<=16'd751)
		begin //TPW HS
			enableFila <=0;
			ResetCol <=0;
			ResetFila <=0;
			oHs<=0;
			oVs<=1;
			oColorAddress<=0;
			oRGB <= 3'd0;
		end
		
		else if(numColumna> 16'd751 & numColumna < 16'd799)
		begin //TBP HS
			enableFila <=0;
			ResetCol <=0;
			ResetFila <=0;
			oHs<=1;
			oVs<=1;
			oColorAddress<=0;
			oRGB <= 3'd0;
		end
		
		else if( numColumna == 16'd799) //Reset after HS
		begin
			enableFila <=1;
			ResetCol <=1;
			ResetFila <=0;
			oHs<=1;
			oVs<=1;
			oColorAddress<=0;
			oRGB <= 3'd0;
		end
		
		else
		begin // Disp Time
			enableFila <=0;
			ResetCol <=0;
			ResetFila <=0;
			oHs<=1;
			oVs<=1;
			oColorAddress<=639*numFila + numColumna;
			oRGB <= 3'd2;
		end
		
		
		
		end
	
		
	
	end*/
	

endmodule
