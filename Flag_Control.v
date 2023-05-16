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

reg [ADDR_WIDTH:0] sync_ReadAddr_internal,
                   sync_WriteAddr_internal,
                   ReadAdrr_internal,
                   WriteAdrr_internal;

//always @(negedge rst_n or posedge write_clk) begin :Registering_SyncReadAddr_Write
//    if (~rst_n) begin
//        sync_ReadAddr_internal <= 0;
//        WriteAdrr_internal <= 0;
//    end
//    else begin
//            sync_ReadAddr_internal <= sync_ReadAddr;
//            WriteAdrr_internal <= WriteAdrr;
//    end
//        
//end
//
//always @(negedge rst_n or posedge read_clk) begin :Registering_SyncWriteAddr
//    if (~rst_n) begin
//        sync_WriteAddr_internal <= 0;
//        ReadAdrr_internal <= 0;
//    end
//    else begin
//        sync_WriteAddr_internal <= sync_WriteAddr;
//        ReadAdrr_internal <= ReadAdrr;
//    end
//        
//end

always @(*) begin : Full_Flag_Control //negedge rst_n or sync_ReadAddr_internal or WriteAdrr_internal
    if (~rst_n) begin
        Full = 0;
    end
    else if ((WriteAdrr+1) == {~sync_ReadAddr[ADDR_WIDTH:ADDR_WIDTH-1],sync_ReadAddr[ADDR_WIDTH-2:0]}) begin
//        if ((WriteAdrr[ADDR_WIDTH-1:0] == sync_ReadAddr[ADDR_WIDTH-1:0])&&(WriteAdrr[ADDR_WIDTH] != sync_ReadAddr[ADDR_WIDTH])) begin // address to write in == Next location to read from.
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
