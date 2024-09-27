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

parameter N=8;
typedef enum logic [4:0] {
        IDLE     = 5'd0,
        LOAD     = 5'd1,
        PROCESS  = 5'd2,
        STORE    = 5'd3,
        DONE     = 5'd31
    } state_t;

module main 
(
    input logic clk,
    output logic inttflag,
    input logic rst_n,
    input logic start,
    input logic intt,
    input logic [31:0] in_data[N-1:0],
    output logic pwc,  
    output logic [31:0] out_data[N-1:0],
    output logic done
);

    // Internal registers and wires
    logic [31:0] data[N-1:0];
    logic [31:0] dataO[N-1:0];
    logic [31:0] temp_a, temp_b,in_a,in_b;
    logic [31:0] Twf[N/2-1:0];
    logic [31:0] iTwf[N/2-1:0];  
    logic [31:0] mod=17;  
    logic [$clog2(N):0]  stage;
    logic [$clog2(N)-1:0]  level;
    logic [$clog2(N)-1:0]  p;
    logic [15:0] root=9;
    logic [15:0] rootinv=2;
    logic pe_start, pe_done;
    logic [$clog2(N/2)-1:0]m=0;
    logic [31:0]power;
    state_t current_state, next_state;
    initial begin
           for (int j=0;j<N/2;j++) begin
                    power = 1;
                    for (int k = 0; k <j; k++) begin
                        power=(power * root)%mod;
                        
                    end
                    Twf[j] = (power)%mod;                
           end
           end
    initial begin
          
           for (int j=0;j<N/2;j++) begin
                    power = 1;
                    for (int k = 0; k <j; k++) begin
                        power=(power * rootinv)%mod;
                    end
                    iTwf[j] = (power)%mod;                
           end
           end       
    // PE instantiation
    /*PE pe_inst (
         .intt(intt),
        .clk(clk),
        .rst_n(rst_n),
        .start(pe_start),
        .in_a(data[stage+p]),
        .in_b(data[stage+p+2**(level-1)]),
        .root(Twf[m]),
        .mod(mod),
        .out_a(temp_a),
        .out_b(temp_b),
        .done(pe_done)
    );*/
    // State machine
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            current_state <= IDLE;
        else
            current_state <= next_state;
    end

    always_comb begin
        next_state = current_state;
        pe_start = 1'b0;
        done = 1'b0;

        case (current_state)
            IDLE: begin
                if (start) begin
                    data = in_data;
                    stage = 5'd0;     
                    if(intt) begin   
                      
                      level =1;
                      Twf=iTwf;
                    end else begin
                      level=$clog2(N);
                    end
                    p=0;
                     
                    next_state = LOAD;
                end
            end

            LOAD: begin 
                root=Twf[m];
                in_a=data[stage+p];
                in_b=data[stage+p+2**(level-1)];
                pe_start=1;
                 
                next_state = PROCESS;
               
            end

            PROCESS: begin
                if (p < 2**(level-1)) begin
                    data[stage+p] = temp_a ;
                    data[stage+p+2**(level-1)] =temp_b;
                    p=p+1;
                    m=m+(2 ** ($clog2(N)-level));
                    next_state = LOAD;
                   
                end
                else if ((p >= 2**(level-1))) begin 
                   next_state = STORE;
                end
            end

            STORE: begin
                // Increment stage and check if done
                if (stage < (N-2**level)) begin
                    p=0;
                    stage = stage + 2**level;  
                    next_state = LOAD;
                    
                end
                else if(level>1 & ~intt) begin 
                    stage=0;
                    p=0;
                    m=0;
                    level= level -1;
                    next_state = LOAD;
                    
                end  else if(level<$clog2(N) & intt) begin       
                    stage=0;
                    p=0;
                    m=0;
                    level= level +1;
                    next_state = LOAD;
                end else begin
                    next_state = DONE;
                end
            end

            DONE: begin
                out_data = data;
                if(intt) begin
                     inttflag=1;
                  end else begin
                   pwc=1;
                  end
                  done = 1'b1;
                next_state = IDLE;
            end

            default: next_state = IDLE;
        endcase
    end

endmodule

