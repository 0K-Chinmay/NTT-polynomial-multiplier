


module twd_ram#
(parameter N = 7,
 parameter Wd = 16) 
(
  input                    clk,
  input en,
  input [N-1:0] addr,
  output reg  [Wd-1:0] dout
) ; 

  (* ram_style = "block" *) reg [Wd-1:0] w[0:(1<<N)];
  initial $readmemh("W256.mem", w);
  
  always @ (negedge clk) begin
   if(en) begin
      dout <= w[addr];
   end 
  end
  
endmodule