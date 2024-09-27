`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.09.2024 16:02:58
// Design Name: 
// Module Name: wrapper
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

module wrapper (
    input  logic clk,
    input  logic rst_a,
    input  logic rst_b,
    input  logic en_a,
    input  logic en_b,
    input  logic [0:0] we_a,
    input  logic [0:0] we_b,
    input  logic [4:0] addr_a,
    input  logic [4:0] addr_b,
    input  logic [31:0] din_a,
    input  logic [31:0] din_b,
    output logic [31:0] dout_a,
    output logic [31:0] dout_b,
    output logic rsta_busy,
    output logic rstb_busy
);

    blk_mem_gen_0 u1 (
        .clka(clk),        // Clock for port A
        .rsta(rst_a),      // Reset for port A
        .ena(en_a),        // Enable for port A
        .wea(we_a),        // Write enable for port A
        .addra(addr_a),    // Address for port A
        .dina(din_a),      // Data input for port A
        .douta(dout_a),    // Data output for port A

        .clkb(clk),        // Clock for port B
        .rstb(rst_b),      // Reset for port B
        .enb(en_b),        // Enable for port B
        .web(we_b),        // Write enable for port B
        .addrb(addr_b),    // Address for port B
        .dinb(din_b),      // Data input for port B
        .doutb(dout_b),    // Data output for port B

        .rsta_busy(rsta_busy),  // Reset busy for port A
        .rstb_busy(rstb_busy)   // Reset busy for port B
    );

endmodule
