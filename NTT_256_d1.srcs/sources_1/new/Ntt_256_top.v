`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06.10.2024 09:29:36
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


module Ntt_256_top#(parameter W = 16, Coeff = 256 ,N = $clog2(Coeff))
(
    input clk,
    input rst,
    input  [Coeff*W-1:0] A,
    output [Coeff*W-1:0] Output,
    output reg done
    );

    parameter idle = 0;
    parameter ntt = 1;
    parameter ntt2 = 2;
    parameter ntt3 = 3;
    parameter finish = 4;
    localparam const_shift = 1<<(N-1);
    
    reg wr_ena ; 
    reg wr_enb ; 
    wire [N:0]wr_addr;
    wire [N:0]rd_addr;
    reg [N-1:0]twaddrT;
    wire [W-1:0]wr_din;
    wire [W-1:0]rd_din;
    wire [W-1:0] wr_dout;
    wire [W-1:0] rd_dout;
    reg input_load;
    
    wire [W-1:0]in_a;
    wire [W-1:0]in_b;
    
    wire [W-1:0]w;
    wire [W-1:0]out_a;
    wire [W-1:0]out_b;
    reg enTWD;
    
    reg cbtCheck;
    
    reg [N:0]  stage;
    reg [N:0]  level;
    reg [N:0]  i;
    reg [N:0]  j; 
    reg [2:0]state;
    reg [W*Coeff - 1 : 0] out1;
    wire [N-1:0] shft;
    reg [N:0]k;
    
    twd_ram twd1(
    .clk(clk),
    .addr(twaddrT),
    .dout(w),
    .en(enTWD)
    );
    
    bram ram1(.clk(clk),
    .wr_ena(wr_ena),
    .wr_enb(wr_enb),
    .wr_addr(wr_addr),
    .rd_addr(rd_addr),
    .wr_din(wr_din),
    .wr_dout(wr_dout),
    .rd_dout(rd_dout),
    .rd_din(rd_din)
    );

    bit_reverse_reorder bitr_1(
    .data_in(out1),   
    .data_out(Output)   
    );

    cBT p1(
    .clk(clk),
    .rst(rst),
    .in_a(in_a),
    .in_b(in_b),
    .w(w),
    .out_a(out_a),
    .out_b(out_b),
    .cbtCheck(cbtCheck)
    );
    
    assign in_a=wr_dout;
    assign in_b=rd_dout;
    
    assign wr_din = input_load ? out_a : A[(j*16)+:15];
    assign rd_din = out_b;
    
    assign shft = 1<<(stage-1);
    wire k1 = stage >= 1 && i >= (const_shift)-1 && state == ntt3;
    
    assign wr_addr = input_load ? level + k : 255 - j ;
    assign rd_addr = level + k + (shft) ;
    
    always@(posedge clk) begin
        if(rst) begin
           stage <= N;
        end
        if(k1)begin
           stage <= stage - 1;
        end 
    end

    always@(posedge clk) begin
       if(rst) begin
         i <= 0;
       end 
       if((i < (const_shift)-1) && (state == ntt3) ) begin 
         i <= i + 1;
       end else if((state == ntt3)) 
         i <= 0;
    end
    
    always@(posedge clk) begin
       if(rst) begin
         k <= 0;
       end 
       if((k < (shft)-1) && (state == ntt3) ) begin 
         k <= k + 1;
       end else if((state == ntt3)) 
         k <= 0;
    end
//initial $monitor("k = %x",k);
    always@(posedge clk) begin
       if(rst) begin
         twaddrT <= 0;
       end 
       if((i < (const_shift)-1) && (state == ntt3) ) begin 
         twaddrT <= twaddrT + ( 1 << (N - (stage)));
       end else if((state == ntt3)) 
         twaddrT <= 0;
    end

    always@(posedge clk) begin
       if(state == idle) begin
         level <= 0;
       end else begin
         if(level < ((1 << (N))-(1 << stage)) && state == ntt3 &&  k >= (shft-1) )
           level <= level + (1<<stage);
         else if(stage >= 1 && k >= (shft-1) && state == ntt3 )  
           level<=0;
       end
    end

    reg flag;    

    always@(posedge clk) begin
      if(rst) begin
          enTWD <= 0;
          flag <= 0;
          cbtCheck <= 0;
          done <= 0;
          state <= 0;
          wr_enb <= 0;
          wr_ena <= 1;
          input_load <= 0;
          j <= 0;
      end else begin
          state <= state;
          case(state) 
              idle: begin                                              
                    if( j > 254) begin
                      wr_ena <= 0;
                      input_load <= 1;       
                      state <= ntt;
                    end else j <= j + 1;         
              end
              
              ntt: begin  // ntt only reading the data
                    enTWD = 1;
                    j <= 0;
                    cbtCheck = 1;
                    wr_ena = 0;     
                    state <= 5;
              end    
              
              5: state <= ntt2;
              
              ntt2: begin //writing the data and changing the increment values
                    wr_ena = 1;
                    cbtCheck=0;
                    wr_enb = 1;
                    state <= ntt3;
              end
              
              ntt3: begin 
                    wr_ena=0;
                    wr_enb=0;
                    if(stage == 1 && i >= (const_shift)-1) begin
                         input_load <= 0;
                         state <= finish;
                    end else state <= ntt;      
             end

             finish: begin                    
                    if( j > 255 ) begin   
                      done=1;   
                      out1[4095:4080] = rd_dout;                               
                    end else begin
                      flag <= 1;
                      if(flag) 
                         out1[16*(j-1) +: 16] = wr_dout;                     
                      j <= j + 1;                                              
                    end
             end
         
             default: begin
                     state <= idle;
             end
          endcase
      end
    end   
    
endmodule