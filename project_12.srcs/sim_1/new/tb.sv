`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.08.2024 16:58:46
// Design Name: 
// Module Name: tb
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


module tb;
    // Parameters
    localparam N = 128;

    // Clock and Reset
    logic clk;
    logic rst_n;

    // Inputs to DUT
    logic start;
   
    //logic [31:0] readData2c;
    logic [15:0]  outFinal;
    logic done;
    logic pwcF=0;
    logic pwc;
    logic inttflag=0,intt=0;

    // DUT instantiation
    core dut (
         .inttflag(inttflag),
         .intt(intt),
        // .tem(tem),
         //.tem1(tem1),
        .pwc(pwc),
        .clk(clk),
        .rst_n(rst_n),
        .start(start),
        //.in_data(in_data),
        //.in_data1(in_data1),
        
        .done(done),
        .pwcF(pwcF),
        .outFinal(outFinal)
       // .readData1(readData1),
        //.readData2(readData2),
        // .readData1b(readData1b),
       // .readData2b(readData2b),
       // .readData1c(readData1c)
        //.readData2c(readData2c)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;  // 100 MHz clock
    end

    // Reset and input initialization
    initial begin
        rst_n = 0;
        pwc=0;
        start = 0;
        #10;
        rst_n = 1;
        #10;
        start = 1;
        #10;
        start = 0;
        wait(intt);
        #10;
         start = 1;
        #10;
        start = 0;
        // Wait for the operation to complete
        wait(pwcF);

        // Display results
       /* $display("NTT Result:");
        for (int i = 0; i < N; i++) begin
            $display("out_data[%0d] = %0d", i, out_data[i]);
        end
*/
        // Finish simulation
        #4000;
        $finish;
    end

endmodule

