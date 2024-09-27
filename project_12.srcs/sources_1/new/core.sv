`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.08.2024 10:23:32
// Design Name: 
// Module Name: core
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


module core
#(parameter N=128)(
input logic clk,
    input logic rst_n,
    input logic start,
    output logic done,
    output logic pwc,
    output logic pwcF,
   output logic [31:0]  outFinal,
   output logic inttflag,
   output logic pe_start, 
   output logic pe_done,
   output logic intt
    );
    logic [31:0]  readData1;
    logic [31:0] readData2;
    logic [31:0]  readData1b;
    logic [31:0] readData2b;
    logic [31:0]  readData1c;
    logic [31:0] readData2c;
    
    
    logic [$clog2(N)-1:0] readAddr1, readAddr2;
    logic [$clog2(N)-1:0]  writeAddr1v2, writeAddr2v2;
    logic [$clog2(N)-1:0]  writeAddr1, writeAddr2;
   logic [31:0] writeData1, writeData2;
   logic [31:0] twdData1;
   logic [$clog2(N)-1:0] twdAddr1;
   logic twdEn;

   logic [$clog2(N)-1:0] twdAddr1b;
   logic twdEnb;

   logic [$clog2(N)-1:0] twdAddr1c;
   logic twdEnc;
   logic  writeEn;
     logic [$clog2(N)-1:0]  writeAddr1b, writeAddr2b;
    logic [$clog2(N)-1:0] readAddr1b, readAddr2b;
   logic [$clog2(N)-1:0]  writeAddrb1v2, writeAddr2bv2;
   logic [31:0] writeData1b, writeData2b;
   logic  writeEnb;
    logic [$clog2(N)-1:0]  writeAddr1cv2, writeAddr2cv2;
   logic [31:0] writeData1c, writeData2c;
   logic [31:0] writeData1cv2, writeData2cv2;
   logic  writeEnc;
   logic  writeEncv2;
    logic [$clog2(N):0] i=0;
    int y=0,z=0;
    
    main12 main12A (
        .clk(clk),
        .inttflag(inttflag),
        .rst_n(rst_n),
        .start(start),
        .intt(intt),
        .in_data1(writeData1),
        .in_data2(writeData2),
        .read_addr1(readAddr1),
        .read_addr2(readAddr2),
        .write_addr1(writeAddr1),
        .write_addr2(writeAddr2),
        .en(writeEn),
        .pwc(pwc),
        .out_data1(readData1),
        .out_data2(readData2),
        .done(done),
        .outFinal(outFinal), 
        .twdData(twdData1),
        .twdAddr(twdAddr1),
        .twdEn(twdEn),
        .pe_done(pe_done),
        .pe_start(pe_start)
    );
    main12 main12B (
        .clk(clk),
        .inttflag(inttflag),
        .rst_n(rst_n),
        .start(start),
        .intt(intt),
        .in_data1(writeData1b),
        .in_data2(writeData2b),
        .read_addr1(readAddr1b),
        .read_addr2(readAddr2b),
        .write_addr1(writeAddr1b),
        .write_addr2(writeAddr2b),
        .en(writeEnb),
        .pwc(pwc),
        .out_data1(readData1b),
        .out_data2(readData2b),
        .done(done),
        .outFinal(outFinal),
        .twdData(twdData1),//using data 1 line itself coz data is same for both ntt
        .twdAddr(twdAddr1b),//not using same address line coz it will add extra values messing up the address
        .twdEn(twdEn),
        .pe_done(pe_done),
        .pe_start(pe_start)
    );
     main12 main12C (
        .clk(clk),
        .inttflag(inttflag),
        .rst_n(rst_n),
        .start(start),
        .intt(intt),
        .in_data1(writeData1c),
        .in_data2(writeData2c),
        .read_addr1(readAddr1c),
        .read_addr2(readAddr2c),
        .write_addr1(writeAddr1c),
        .write_addr2(writeAddr2c),
        .en(writeEnc),
        .pwc(pwc),
        .out_data1(readData1c),
        .out_data2(readData2c),
        .done(done),
        .outFinal(outFinal),
         .twdData(twdData1),//since it carries the twiddle factor
        .twdAddr(twdAddr1c),//same as aboce
        .twdEn(twdEnc),
        .pe_done(pe_done),
        .pe_start(pe_start)
    );

 logic[$clog2(N)-1:0] q=N-1;
always@(posedge clk) begin
      if(pwc) begin
        writeEncv2=1;
        writeAddr1cv2= q;    
        writeData1cv2= (readData1*readData1b)%1153;   
        //$display("=======%d",writeData1cv2);
         q=q+1;
         i=i+1;
      end   
end 
always@(posedge clk) begin 
      if(i>N)begin 
       writeEncv2=0;
        i=0;
        pwc=0;
        intt=1;
      end
end
always@(posedge clk) begin
      if(inttflag) begin 
         pwcF=1;
      end
end 
memory #(32,N,"ok.txt",$clog2(N))mem1 (
        .readAddr1(readAddr1),
        .writeAddr1(writeAddr1),
        .writeAddr1v2(writeAddr1v2),
        .writeData1(writeData1),
       .writeData1v2(writeData1v2),
        .readData1(readData1),
        .readAddr2(readAddr2),
        .writeAddr2(writeAddr2),
        .writeAddr2v2(writeAddr2v2),
        .writeData2(writeData2),
        //.writeData2v2(writeData2v2),
        .readData2(readData2),
        .writeEn(writeEn),
       // .writeEnV2(writeEnv2),
        .CLK(clk)
    );
memory#(32,N,"ok1.txt",$clog2(N)) mem2 (
        .readAddr1(readAddr1b),
        .writeAddr1(writeAddr1b),
        .writeAddr1v2(writeAddr1bv2),
        .writeData1(writeData1b),
       .writeData1v2(writeData1bv2),
        .readData1(readData1b),
        .readAddr2(readAddr2b),
        .writeAddr2(writeAddr2b),
        .writeAddr2v2(writeAddr2bv2),
        .writeData2(writeData2b),
        .writeData2v2(writeData2bv2),
        .readData2(readData2b),
        .writeEn(writeEnb),
        .writeEnV2(writeEnbv2),
        .CLK(clk)
    );
  memory#(32,N,"",$clog2(N)) mem3 (
        .readAddr1(readAddr1b),
        .writeAddr1(writeAddr1b),
        .writeAddr1v2(writeAddr1cv2),
        .writeData1(writeData1c),
        .writeData1v2(writeData1cv2),
        .readData1(readData1c),
        .readAddr2(readAddr2b),
        .writeAddr2(writeAddr2b),
        .writeAddr2v2(writeAddr2cv2),
        .writeData2(writeData2c),
        .writeData2v2(writeData2cv2),
        .readData2(readData2c),
        .writeEn(writeEnc),
        .writeEnV2(writeEncv2),
        .CLK(clk)
    );
    //removed the below assign statements since i have directly wired the data lines
   //assign twdData1b=twdData1;// as both twiddle factors will be same for ntt 
  // assign twdData1c=twdData1;// since we r taking twiddle factors from the same line
   assign twdAddr1= intt ? twdAddr1c:twdAddr1; // for intt we will have different address
   twdmem twdl (
        .readAddr1(twdAddr1),
        .readData1(twdData1),
        .writeEn(twdEn),
        .CLK(clk)
   );


endmodule
