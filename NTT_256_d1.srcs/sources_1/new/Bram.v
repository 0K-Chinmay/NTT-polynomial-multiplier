module bram#(
    parameter D_SIZE = 16, Q_DEPTH = 8, Q_SIZE = 1 << Q_DEPTH 
) (
    input clk,
    input wr_ena,
    input wr_enb,
    input [Q_DEPTH-1:0] wr_addr,
    input [D_SIZE-1:0] wr_din,
    
    input [Q_DEPTH-1:0] rd_addr,
    input [D_SIZE-1:0] rd_din,
    
    output reg [D_SIZE-1:0] wr_dout,
    output reg [D_SIZE-1:0] rd_dout
);

    reg [D_SIZE-1:0] ram [255:0];

    always @(posedge clk) begin
        if (wr_ena) begin
            ram[wr_addr] <= wr_din;
        end
        wr_dout <= ram[wr_addr];
    end
    
    always @(posedge clk) begin
        if (wr_enb) begin
            ram[rd_addr] <= rd_din;
        end
        rd_dout <= ram[rd_addr];
    end

endmodule