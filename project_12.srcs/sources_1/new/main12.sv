`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.08.2024 16:39:58
// Design Name: 
// Module Name: main
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

parameter N=128;
typedef enum logic [4:0] {
        IDLE     = 5'd0,
        LOAD     = 5'd1,
        PROCESS  = 5'd2,
        STORE    = 5'd3,
        DONE     = 5'd31
    } state_t;
module main12 
#()(
    input logic clk,
    output logic inttflag,
    input logic rst_n,
    input logic start,
    input logic intt,
    output logic [31:0] in_data1,
    output logic [31:0] in_data2,
    input logic [31:0] twdData,
    output logic [31:0] outFinal,
    output logic [$clog2(N)-1:0] read_addr1,
    output logic [$clog2(N)-1:0] read_addr2,
    output logic [$clog2(N)-1:0] write_addr1,
    output logic [$clog2(N)-1:0] twdAddr,
    output logic [$clog2(N)-1:0] write_addr2,
     output logic en,
     output logic twdEn,
    output logic pwc,  
    input logic [31:0] out_data1,
    input logic [31:0] out_data2,
    output logic done,
    output logic pe_start,
    output logic pe_done
);

    // Internal registers and wires
    logic [31:0] temp_a, temp_b; 
    logic [31:0] mod=1153;  
    logic [$clog2(N):0]  stage;
    logic [$clog2(N)-1:0]  level;
    logic [$clog2(N)-1:0]  p;
    
    state_t current_state, next_state;
    PE pe_inst (
         .intt(intt),
        .clk(clk),
        .rst_n(rst_n),
        .start(pe_start),
        .in_a(out_data1),
        .in_b(out_data2),
        .root(twdData),
        .mod(mod),
        .out_a(temp_a),
        .out_b(temp_b),
        .done(pe_done)
    );
    // State machine
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n | pwc)
            current_state <= IDLE;
        else
            current_state <= next_state;
    end
   logic[$clog2(N):0] z=0;
   logic[$clog2(N)-1:0] n=0; 
 
   always @(posedge clk) begin
   if (pwc & z<N) begin
                  // en=0;
                   read_addr1=z;
                   z=z+1;
   end
   end
   always@(posedge clk ) begin
   if(inttflag) begin
     read_addr1=n;
     outFinal=out_data1;
     n=n+1; 
     end
  end
 
   
   
    always_comb begin
        next_state = current_state;
        pe_start = 1'b0;
        done = 1'b0;

        case (current_state)
            IDLE: begin
                
                if (start) begin                  
                    stage = 5'd0;  
                      
                    if(intt) begin                
                      level =1;
                      twdAddr=N/2;//intt twiddle matrix starts from 64
                    end else begin
                      twdAddr=0; //ntt twiddle matrix starts from 0
                      level=$clog2(N);
                    end
                    p=0;
                     
                    next_state = LOAD;
                end
            end

            LOAD: begin  
                en=0;
                
                read_addr1=stage+p;
                read_addr2=stage+p+(1<<(level-1));
                twdEn=0;  // if 0 it will read the data and twdData will be set to root of pe
                pe_start=1;
                 
                next_state = PROCESS;
               
            end

            PROCESS: begin
                if (p < (1<<(level-1))) begin
                   in_data1 = temp_a ;
                    in_data2 = temp_b;
                    en=1;
                    twdEn=1;
                    write_addr1=stage+p;
                    write_addr2=stage+p+(1<<(level-1));
                    twdAddr=twdAddr+(1<< ($clog2(N)-level)); // applying the pattern to get required twiddle factor
                    // this if else is for manually cycling the twiddle factor values
                    //since we havent taken 2 seperate matricess its needed to get requires values
                    if(~intt & twdAddr>=N/2) begin
                         twdAddr=twdAddr+N/2;
                         end
                    else if(intt & twdAddr<N/2)begin
                         twdAddr= twdAddr+N/2;     
                         end                 
                    p=p+1;
                    next_state = LOAD;
                   
                end
                else if ((p >= (1<<(level-1)))) begin 
                   next_state = STORE;
                end
            end

            STORE: begin
                // Increment stage and check if done
                //if (stage < (N-2**level)) begin
                if (stage < (N-(1<<level))) begin
                    p=0;
                    stage = stage + (1<<level);  
                    next_state = LOAD;
                    
                end
                else if(level>1 & ~intt) begin 
                    
                    stage=0;
                    p=0;
                   // m=0;
                    twdAddr=0;
                    level= level -1;
                    next_state = LOAD;
                    
                end  else if(level<$clog2(N) & intt) begin 
               // $display("*********");      
                    stage=0;
                    p=0;
                  //  m=0;
                    twdAddr=N/2;
                    level= level +1;
                    next_state = LOAD;
                end else begin
                    next_state = DONE;
                end
            end

            DONE: begin
                
                  if(intt) begin
                    
                     inttflag=1;
                  end else begin
                   pwc=1;
                   en=0;
                   
                  end
                  done = 1'b1;
                next_state = IDLE;
            end

            default: next_state = IDLE;
        endcase
    end
   
endmodule

