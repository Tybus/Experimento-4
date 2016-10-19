
`timescale 1ns / 1ps
`include "Defintions.v"


module MiniAlu
(
 input wire Clock,
 input wire Reset,
 output wire [2:0] oRGB,
 output wire oHsync,
 output wire oVsync,
 output wire [7:0] oLed
);

wire [15:0]  wIP,wIP_temp;
reg         rWriteEnable,rBranchTaken, rVGAWritEnable;
wire [27:0] wInstruction;
wire [3:0]  wOperation;
reg [15:0]   rResult;
wire [7:0]  wSourceAddr0,wSourceAddr1,wDestination;
wire [15:0] wSourceData0,wSourceData1,wIPInitialValue,wImmediateValue;
wire [2:0] wColor;
wire [13:0] wColorAddress;
wire oVGA_R, oVGA_G, oVGA_B;
wire rVGAWriteEnableAtrasado;
 


ROM InstructionRom 
(
	.iAddress(     wIP          ),
	.oInstruction( wInstruction )
);

RAM_DUAL_READ_PORT DataRam
(
	.Clock(         Clock        ),
	.iWriteEnable(  rWriteEnable ),
	.iReadAddress0( wInstruction[7:0] ),
	.iReadAddress1( wInstruction[15:8] ),
	.iWriteAddress( wDestination ),
	.iDataIn(       rResult      ),
	.oDataOut0(     wSourceData0 ),
	.oDataOut1(     wSourceData1 )
);

FFD_POSEDGE_SYNCRONOUS_RESET # ( 1 ) FF_WE_VIDEO 
(
	.Clock(Clock),
	.Reset(Reset),
	.Enable(1'b1),
	.D(rVGAWritEnable),
	.Q(rVGAWriteEnableAtrasado)
);

//Memoria de Video
RAM_SINGLE_READ_PORT # (3,14,100*100) VideoMemory
(
	.Clock( Clock ),
	.iWriteEnable( rVGAWriteEnableAtrasado ),
	.iReadAddress( wColorAddress ),
	.iWriteAddress( {wSourceData1[5:0], wSourceData0}	),
	.iDataIn( wColor ),
	.oDataOut( {oVGA_R,oVGA_G,oVGA_B} )
);

VGA Controller
(
	.Clock(Clock),
	.Reset2(Reset),
	.iColor({oVGA_R,oVGA_G,oVGA_B}),
	.oHs(oHsync),
	.oVs(oVsync),
	.oRGB(oRGB),
	.oColorAddress(wColorAddress)
);

assign wIPInitialValue = (Reset) ? 8'b0 : wDestination;
UPCOUNTER_POSEDGE IP
(
.Clock(   Clock                ), 
.Reset(   Reset | rBranchTaken ),
.Initial( wIPInitialValue + 1  ),
.Enable(  1'b1                 ),
.Q(       wIP_temp             )
);
assign wIP = (rBranchTaken) ? wIPInitialValue : wIP_temp;

FFD_POSEDGE_SYNCRONOUS_RESET # ( 8 ) FFD1 
(
	.Clock(Clock),
	.Reset(Reset),
	.Enable(1'b1),
	.D(wInstruction[27:24]),
	.Q(wOperation)
);

FFD_POSEDGE_SYNCRONOUS_RESET # ( 3 ) FFCOLOR 
(
	.Clock(Clock),
	.Reset(Reset),
	.Enable(1'b1),
	.D(wInstruction[23:21]),
	.Q(wColor)
);

FFD_POSEDGE_SYNCRONOUS_RESET # ( 8 ) FFD2
(
	.Clock(Clock),
	.Reset(Reset),
	.Enable(1'b1),
	.D(wInstruction[7:0]),
	.Q(wSourceAddr0)
);

FFD_POSEDGE_SYNCRONOUS_RESET # ( 8 ) FFD3
(
	.Clock(Clock),
	.Reset(Reset),
	.Enable(1'b1),
	.D(wInstruction[15:8]),
	.Q(wSourceAddr1)
);

FFD_POSEDGE_SYNCRONOUS_RESET # ( 8 ) FFD4
(
	.Clock(Clock),
	.Reset(Reset),
	.Enable(1'b1),
	.D(wInstruction[23:16]),
	.Q(wDestination)
);


reg rFFLedEN;
FFD_POSEDGE_SYNCRONOUS_RESET # ( 8 ) FF_LEDS
(
	.Clock(Clock),
	.Reset(Reset),
	.Enable( rFFLedEN ),
	.D( wSourceData1 ),
	.Q( oLed    )
);

assign wImmediateValue = {wSourceAddr1,wSourceAddr0};



always @ ( * )
begin
	case (wOperation)
	//-------------------------------------
	`NOP:
	begin
		rFFLedEN     <= 1'b0;
		rBranchTaken <= 1'b0;
		rWriteEnable <= 1'b0;
		rResult      <= 0;
		rVGAWritEnable <= 1'b0;
	end
	//-------------------------------------
	`ADD:
	begin
		rFFLedEN     <= 1'b0;
		rBranchTaken <= 1'b0;
		rWriteEnable <= 1'b1;
		rResult      <= wSourceData1 + wSourceData0;
		rVGAWritEnable <= 1'b0;
	end
	//-------------------------------------
	`STO:
	begin
		rFFLedEN     <= 1'b0;
		rWriteEnable <= 1'b1;
		rBranchTaken <= 1'b0;
		rResult      <= wImmediateValue;
		rVGAWritEnable <= 1'b0;
	end
	//-------------------------------------
	`BLE:
	begin
		rFFLedEN     <= 1'b0;
		rWriteEnable <= 1'b0;
		rResult      <= 0;
		rVGAWritEnable <= 1'b0;
		if (wSourceData1 <= wSourceData0 )
			rBranchTaken <= 1'b1;
		else
			rBranchTaken <= 1'b0;
		
	end
	//-------------------------------------	
	`JMP:
	begin
		rFFLedEN     <= 1'b0;
		rWriteEnable <= 1'b0;
		rResult      <= 0;
		rBranchTaken <= 1'b1;
		rVGAWritEnable <= 1'b0;
	end
	//-------------------------------------	
	`LED:
	begin
		rFFLedEN     <= 1'b1;
		rWriteEnable <= 1'b0;
		rResult      <= 0;
		rBranchTaken <= 1'b0;
		rVGAWritEnable <= 1'b0;
	end
	//-------------------------------------
	`VGA:
	begin
		rFFLedEN     <= 1'b0;
		rWriteEnable <= 1'b0;
		rResult      <= 0;
		rBranchTaken <= 1'b0;
		rVGAWritEnable <= 1'b1;
	end
	//-------------------------------------
	default:
	begin
		rFFLedEN     <= 1'b1;
		rWriteEnable <= 1'b0;
		rResult      <= 0;
		rBranchTaken <= 1'b0;
		rVGAWritEnable <= 1'b0;
	end	
	//-------------------------------------	
	endcase	
end


endmodule
