`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.09.2024 15:02:47
// Design Name: 
// Module Name: twdmem
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module twdmem
#(
     parameter integer BIT_WIDTH = 32, 
     parameter integer SIZE = 128,
     parameter INITIALIZATION_FILENAME = "twd.txt",
     parameter integer ADDR_WIDTH = $clog2(SIZE)
     )
   
    (
    input  logic [ADDR_WIDTH-1:0] readAddr1,
    output logic [BIT_WIDTH-1:0] readData1,
    input  logic writeEn,
    input  logic          CLK
    );

   logic [BIT_WIDTH-1:0]         mem[SIZE-1:0];

   //load given filename
   initial begin 
    if(INITIALIZATION_FILENAME != "")
     $readmemh(INITIALIZATION_FILENAME, mem);
   end
     
   //assign readData  = mem[readAddr];
   always @(CLK) begin
    // $display("%d-----RRRRRRRRRRRR",mem[64]);
     if(~writeEn) begin
        readData1 <= mem[readAddr1];
        end
    end
    
    
    //the read write addresses have unequal parity, make two block memories saving each
endmodule
