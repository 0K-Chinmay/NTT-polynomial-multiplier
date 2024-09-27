`timescale 1ns / 1ps
/////////////////////////////

module modmul(
    input logic [31:0] X,     // 32-bit input for X
    input logic [31:0] Y,     // 32-bit input for Y
    output logic [31:0] Zout ,
    input logic en, // 32-bit output for Zout
    output logic done
);

    // Declare variables
    logic [15:0] x1, x0, y1, y0; 
    logic [63:0] z0, z2;    
    logic [63:0] z1;             
    logic [63:0] Z0;              
    logic [63:0] z_0, z_1, z_2;   
    logic [63:0] Z1;              

    // Parameter or constant values
    logic [31:0] delta = 523;
    logic [31:0] q=1153;         // Calculate modulus q

    always@(*) begin
        q = (1 << (2 * 16)) - delta;

        x1 = X[31:16];
        x0 = X[15:0];
        y1 = Y[31:16];
        y0 = Y[15:0];
        z0 = x0 * y0;
        z2 = x1 * y1;
        z1 = (x1 + x0) * (y1 + y0) - z0 - z2;

        // Calculate Z0
        Z0 = z0 + (z1 << 32) + z2 * delta;
        z_0 = Z0 % (1 << 32);
        z_1 = (Z0 >> 32) % (1 << 16);
        z_2 = Z0 >> 48;

        // Compute final value Z1
        Z1 = z_0 + z_1 * delta + z_2 * delta * (1 << 16);
           Zout = (Z1 >= q) ? Z1-q : Z1;
        done=1; 
       
    end

endmodule
