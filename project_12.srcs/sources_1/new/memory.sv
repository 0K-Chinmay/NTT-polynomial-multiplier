`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.09.2024 10:28:04
// Design Name: 
// Module Name: memory
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
module memory
#(
     parameter integer BIT_WIDTH = 32, 
     parameter integer SIZE = 8,
     parameter INITIALIZATION_FILENAME = "",
     parameter integer ADDR_WIDTH = $clog2(SIZE)
     )
   
    (
    input  logic [ADDR_WIDTH-1:0] readAddr1,
    input  logic [ADDR_WIDTH-1:0] writeAddr1,
    input  logic [ADDR_WIDTH-1:0] writeAddr1v2,
    input  logic [BIT_WIDTH-1:0] writeData1,
    input  logic [BIT_WIDTH-1:0] writeData1v2,
    output logic [BIT_WIDTH-1:0] readData1,
    input  logic [ADDR_WIDTH-1:0] readAddr2,
    input  logic [ADDR_WIDTH-1:0] writeAddr2,
    input  logic [ADDR_WIDTH-1:0] writeAddr2v2,
    input  logic [BIT_WIDTH-1:0] writeData2,
    input  logic [BIT_WIDTH-1:0] writeData2v2,
    output logic [BIT_WIDTH-1:0] readData2,
    input  logic writeEn,
    input  logic writeEnV2,
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
     if(writeEn) begin
       
 //    $display("%d--------%d",write)
       mem[writeAddr1]  <= writeData1;
       mem[writeAddr2]  <= writeData2;
      
       end
     else  begin
      //$display("%d--------=========%d",readData1,readAddr1);
        readData1 <= mem[readAddr1];
        readData2 <= mem[readAddr2]; 
        end
    end
    always @(CLK) begin
     if(writeEnV2 ) begin 
       //$display("%d--------%d",writeData1v2,writeAddr1v2);
       mem[writeAddr1v2]  <= writeData1v2;
       mem[writeAddr2v2]  <= writeData2v2;
       end
    end
    
    
    //the read write addresses have unequal parity, make two block memories saving each
endmodule

