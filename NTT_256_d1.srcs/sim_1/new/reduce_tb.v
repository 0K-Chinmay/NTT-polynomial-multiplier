module tb_montgomery_reduction_3329;
    
    reg  [31:0] x_in;
    wire [15:0] result_out;
    
    // Instantiate the module
    reduce dut (
        x_in,
        result_out
    );
    
    // Test vectors
    initial begin
        $dumpfile("montgomery_reduction.vcd");
        $dumpvars(0, tb_montgomery_reduction_3329);
        
        $display("Testing Montgomery Reduction for mod 3329");
        $display("==========================================");
        
        // Test cases matching the Python implementation
        $display("Input\t\t\tOutput\t\tExpected");
        $display("-----\t\t\t------\t\t--------");
        
        // Test case 1: 0x12345678

        // Test case 2: 0x00003329
        x_in = 32'h00003329;
        #1;
        $display("0x%08X\t\t%d\t\t%d", x_in, result_out,x_in%3329);
        
        // Test case 3: 0x00006658
        x_in = 32'h00006658;
        #1;
        $display("0x%08X\t\t%d\t\t%d", x_in, result_out,x_in%3329);
        
        // Test case 4: 0x0000FFFF
        x_in = 32'h0000FFFF;
        #1;
        $display("0x%08X\t\t%d\t\t%d", x_in, result_out,x_in%3329);
        
        
        // Test case 6: 0x0001E240
        x_in = 32'h0001E240;
        #1;
        $display("0x%08X\t\t%d\t\t%d", x_in, result_out,x_in%3329);
        
        // Additional edge cases
        x_in = 32'h00000000;
        #1;
        $display("0x%08X\t\t%d\t\t%d", x_in, result_out,x_in%3329);
        
        x_in = 32'h00000D01;  // 3329 in hex
        #1;
        $display("0x%08X\t\t%d\t\t%d", x_in, result_out,x_in%3329);
        #100
        x_in = 32'hfffFffff;
        #1;
        $display("0x%08X\t\t%d\t\t%d", x_in, result_out,x_in%3329);
        x_in = 32'h12345678;
        #1;
        $display("0x%08X\t\t%d\t\t%d", x_in, result_out,x_in%3329);
        
        $finish;
    end
    
endmodule