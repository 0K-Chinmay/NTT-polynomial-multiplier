(* use_dsp = "true" *)
module reduce (
    input wire [68:0] t,
    input  wire [31:0] in,
    output wire [15:0] out
);
    localparam Q  = 3329;

    localparam K  = 48;
    localparam V  = 37'd84552411147;
            
    wire [20:0] m  = t >> K;             
    
    wire [32:0] mq = m * Q;              
    wire [32:0] r0 = {1'b0, in} - mq;    
    
    
    //wire [32:0] r1 = (r0 >= Q) ? (r0 - Q) : r0;
    //wire [32:0] r2 = (r1 >= Q) ? (r1 - Q) : r1; enable for double security

    assign out = r0[15:0];  
                 
endmodule
