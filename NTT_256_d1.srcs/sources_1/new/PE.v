
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06.10.2024 16:17:37
// Design Name: 
// Module Name: cBT
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

//(clk, ntt_state, in_a[0], in_b[0], w[0], bw[0], out_a[0], out_b[0]);
module cBT(clk,rst, in_a, in_b, w ,out_a, out_b,cbtCheck);

parameter W=16;
parameter [15:0] mod=3329;
//parameter root=2028

input clk,rst;
input  [W-1:0]in_a;
input  [W-1:0]in_b;
input cbtCheck;
input  [W-1:0]w; // no reason in taking 10:0 random
output reg [W-1:0]out_a;
output [W-1:0]out_b;

localparam V   = 37'd84552411147;

wire [W:0]subab;
wire [W-1:0]subba;
wire signed [W-1:0]subabq;
reg [2*W-1:0] temp;

reg [2*W-1:0]mulval;
reg flag;
reg [68:0] t ; 

assign subab = (in_a - in_b);
assign subabq = subab + (mod*16); // using this can be useful later while implementing mod algo

reduce dut (t, mulval, out_b);

assign subba = (subab[16] == 1'b0) ? subab[15:0] : subabq[15:0];
    
always@(posedge clk) begin
   if(rst) begin
      out_a <= 0;
      flag  <= 0;
      mulval <= 0;
      t <= 0;
   end else begin 
      if( cbtCheck ) begin  
         if(!flag) begin //ntt     
            out_a <= (in_a + in_b) > mod ? (in_a + in_b) - mod : (in_a + in_b) ;
            mulval <= (subba * w);
            flag <= 1;
         end else begin
            flag <= 0;
            t <= mulval * V;
         end 
      end 
   end
end




endmodule
