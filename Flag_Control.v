module Flag_Control #(parameter ADDR_WIDTH = 5)(
	input                rst_n,
	input                read_clk,
	input                write_clk, 
	input [ADDR_WIDTH:0] sync_ReadAddr,
	input [ADDR_WIDTH:0] ReadAdrr,
	input [ADDR_WIDTH:0] sync_WriteAddr,
	input [ADDR_WIDTH:0] WriteAdrr,
	output   reg         Full,
	output   reg         Empty
);


always @(*) begin : Full_Flag_Control //negedge rst_n or sync_ReadAddr_internal or WriteAdrr_internal
    if (~rst_n) begin
        Full = 0;
    end
    else if ((WriteAdrr) == {~sync_ReadAddr[ADDR_WIDTH:ADDR_WIDTH-1],sync_ReadAddr[ADDR_WIDTH-2:0]}) begin
        Full = 1;
    end
    else begin
        Full = 0; 
    end     
end


always @(*) begin : Empty_Flag_Control //negedge rst_n or sync_WriteAddr_internal or ReadAdrr_internal
    if (~rst_n) begin
        Empty = 1;
    end
    else if (ReadAdrr == sync_WriteAddr) begin // address to read from == Next location to write in.
        Empty = 1;
    end
    else begin
        Empty = 0; 
    end     
end	




endmodule : Flag_Control
