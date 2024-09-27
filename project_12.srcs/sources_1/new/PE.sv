`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.08.2024 16:57:31
// Design Name: 
// Module Name: PE
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


module PE (
    input logic clk,
    input logic rst_n,
    input logic start,
    input logic [31:0] in_a,
    input logic [31:0] in_b,
    input logic [31:0] root,
    input logic [31:0] mod,
    input logic intt,
    output logic [31:0] out_a,
    output logic [31:0] out_b,
    output logic done
);
    // Internal registers
    logic [31:0] temp_a, temp_b;
    logic [31:0] varA,varB,out;
    int op;
    logic en;
    logic dmul;
    logic [15:0] modinv=577;
    modmul m1(
      .X(varA),
      .Y(varB),
      .Zout(out),
      .en(start),
      .done(dmul)
    );
    always@(*) begin
        if (!rst_n) begin
            out_a <= 32'd0;
            out_b <= 32'd0;
            done <= 1'b0;
            en=1;
        end else if (start) begin
            if(intt) begin      
             varA=in_b;
             varB=root;             
             temp_a = ((in_a+out)*modinv)%mod ;
            op=(int'(mod) + int'(in_a-out)*int'(modinv))%int'(mod);
            if(op<0) begin
                op=op+mod;
            end
                temp_b=op;
           
            end else begin
             varA=mod+in_a-in_b;
             varB=root; 
            temp_a = (in_a+in_b)% mod ;
            //temp_b = find_modulus((mod+in_a-in_b)*root,mod) ;
            op=(out)%(mod);
            //$display("%d------%d-------%d",in_a,in_b,root);
            if(op<0) begin
                op=op+mod;
            end
                temp_b=op;
            end
            out_a <= temp_a;
            out_b <= temp_b;
            done <= 1'b1;
        end
    end
endmodule

