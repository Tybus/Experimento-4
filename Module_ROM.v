`timescale 1ns / 1ps
`include "Defintions.v"

`define LOOP 8'd8

module ROM
(
	input  wire[15:0]  		iAddress,
	output reg [27:0] 		oInstruction
);	
always @ ( iAddress )
begin
	case (iAddress)
/*
	0: oInstruction = { `NOP ,24'd4000    };
	1: oInstruction = { `STO , `R7,16'b0001 };
	2: oInstruction = { `STO ,`R3,16'h1     }; 
	3: oInstruction = { `STO, `R4,16'd1000 };
	4: oInstruction = { `STO, `R5,16'd0     };  //j
//LOOP2:
	5: oInstruction = { `LED ,8'b0,`R7,8'b0 };
	6: oInstruction = { `STO ,`R1,16'h0     }; 	
	7: oInstruction = { `STO ,`R2,16'd65000 };
//LOOP1:	
	8: oInstruction = { `ADD ,`R1,`R1,`R3    }; 
	9: oInstruction = { `BLE ,`LOOP1,`R1,`R2 }; 
	
	10: oInstruction = { `ADD ,`R5,`R5,`R3    };
	11: oInstruction = { `BLE ,`LOOP2,`R5,`R4 };	
	12: oInstruction = { `NOP ,24'd4000       }; 
	13: oInstruction = { `ADD ,`R7,`R7,`R3    };
	14: oInstruction = { `JMP ,  8'd2,16'b0   };
*/
	0: oInstruction = { `NOP ,24'd4000 };
	1: oInstruction = { `STO , `R1,16'd0 };
	2: oInstruction = { `STO , `R2,16'd0 };
	3: oInstruction = { `STO , `R5,16'd255 };
	4: oInstruction = { `STO , `R6,16'd39 };
	5: oInstruction = { `STO , `R7,16'd16 };
	6: oInstruction = { `STO , `R3,16'd1 };
	7: oInstruction = { `NOP , 24'd4000 };
//LOOP:
	8: oInstruction = { `VGA , `COLOR_RED, `R1, `R2 };
	9: oInstruction = { `NOP ,24'd4000 };
	10: oInstruction = { `NOP ,24'd4000 };	
	11: oInstruction = { `ADD , `R2, `R3, `R2 };
	12: oInstruction = { `NOP ,24'd4000 };
	13: oInstruction = { `NOP ,24'd4000 };	
	14: oInstruction = { `BLE , `LOOP, `R5, `R2 };
	15: oInstruction = { `STO , `R2 , 16'd0 };
	16: oInstruction = { `ADD , `R1, `R3, `R1 };
	17: oInstruction = { `NOP ,24'd4000 };
	18: oInstruction = { `NOP ,24'd4000 };
	19: oInstruction = { `BLE , `LOOP, `R6, `R1 };
	20: oInstruction = { `STO , `R2 , 16'd0 };
	21: oInstruction = { `VGA , `COLOR_RED, `R1, `R2 };
	22: oInstruction = { `NOP ,24'd4000 };
	23: oInstruction = { `NOP ,24'd4000 };	
	24: oInstruction = { `ADD , `R2, `R3, `R2 };
	25: oInstruction = { `NOP ,24'd4000 };
	26: oInstruction = { `NOP ,24'd4000 };
	27: oInstruction = { `BLE , 8'd21 , `R7, `R2 };
	
	
	default:
		oInstruction = { `LED ,  24'b10101010 };		//NOP
	endcase	
end
	
endmodule
