module FIFO #(parameter ADDR_WIDTH = 5, DATA_WIDTH = 8 )(
    input                       clk_read,
    input                       clk_write,
    input                       rst_n, /*when high, the control functions are cleared , output remains
                                        in the state of the last word shifted out*/
    input [DATA_WIDTH-1:0]      DataIn,   /*Parallel data input*/
    input                       Wr_enable, /*1-> Data is loaded into reg , shift data in*/
    input                       Read_enable, /*1 -> empties locations, shift data out*/
    output     [DATA_WIDTH-1:0] DataOut,  /*Data Output*/
    output                      Empty, /*empty signal synchronized with the read clk
//                                         High when the read addr = that of the write addr*/
    output                      Full /*full signal synchronized with the write clk
//                                       High when the write addr = that of the read addr*/
);
	
	parameter  Num_Stages = 2,
	           Bus_Width  = ADDR_WIDTH +1; 
	
	wire [ADDR_WIDTH:0] w_addr_binary, /*Memory addr of incoming data*/
	                    r_addr_binary; /*Memory addr of data to be read out*/
	
	wire [ADDR_WIDTH:0] w_addr_Gray, /*Memory addr of incoming data - Gray encoded*/
                          r_addr_Gray; /*Memory addr of data to be read out - Gray encoded*/
	  
	wire [ADDR_WIDTH:0] sync_w_addr_Gray, 
                          sync_r_addr_Gray; 
                          
    wire Empty_internal, Full_internal;
	                     /*after reset both indicate the same memory location*/

	
	RAM #(
	    .ADDR_WIDTH(ADDR_WIDTH),
	    .DATA_WIDTH(DATA_WIDTH)
	) RAM_instance(
	    .r_clk(clk_read),
	    .w_clk(clk_write),
	    .rst_n(rst_n),
	    .Write_EN(Wr_enable && ~Full_internal),
	    .Read_EN(Read_enable && ~Empty_internal),
	    .read_addr(r_addr_binary[ADDR_WIDTH-1:0]),
	    .write_addr(w_addr_binary[ADDR_WIDTH-1:0]),
	    .DataIn(DataIn),
	    .DataOut(DataOut)
	);
	
	Counter #(
	    .ADDR_WIDTH(ADDR_WIDTH)
	) Write_Counter(
	    .En(Wr_enable && ~Full_internal),
	    .rst_n(rst_n),
	    .clk(clk_write),
	    .Binary_out(w_addr_binary)
	);
     GrayCoding #(
    .ADDR_WIDTH(ADDR_WIDTH)
    ) write_GrayCoding(
    .clk(clk_read),
    .rst_n(rst_n),
    .BinaryVal(w_addr_binary),
    .GrayVal(w_addr_Gray)
    );
	Counter #(
	    .ADDR_WIDTH(ADDR_WIDTH)   
	) Read_Counter(
	    .En(Read_enable && ~Empty_internal),
        .rst_n(rst_n),
	    .clk(clk_read),
	    .Binary_out(r_addr_binary)
	);
	
	GrayCoding #(
    .ADDR_WIDTH(ADDR_WIDTH)
    ) Read_GrayCoding(
    .clk(clk_read),
    .rst_n(rst_n),
    .BinaryVal(r_addr_binary),
    .GrayVal(r_addr_Gray)
    );
    
	Synchronizer #(
	    .Num_Stages(Num_Stages),
	    .Bus_Width(Bus_Width)
	) Write_Synchronizer(
	    .clk(clk_write),
	    .rst_n(rst_n), 
	    .Async_Bits(r_addr_Gray),
	    .Sync_Bits(sync_r_addr_Gray)
	);
	
	Synchronizer #(
	    .Num_Stages(Num_Stages),
	    .Bus_Width(Bus_Width)
	) Read_Synchronizer(
	    .clk(clk_read),
	    .rst_n(rst_n),
	    .Async_Bits(w_addr_Gray),
	    .Sync_Bits(sync_w_addr_Gray)
	);
	
	Flag_Control #(
	    .ADDR_WIDTH(ADDR_WIDTH)
	) Flag_Control_instance(
	    .rst_n(rst_n),
	    .read_clk(clk_read),
	    .write_clk(clk_write),
	    .sync_ReadAddr(sync_r_addr_Gray),
	    .ReadAdrr(r_addr_Gray),
	    .sync_WriteAddr(sync_w_addr_Gray),
	    .WriteAdrr(w_addr_Gray),
	    .Full(Full_internal),
	    .Empty(Empty_internal)
	); 

//    Synchronizer #(
//        .Num_Stages(Num_Stages),
//        .Bus_Width(1),
//        .RST_VAL(1'b1)
//    ) Empty_Synchronizer(
//        .clk(clk_read),
//        .rst_n(rst_n),
//        .Async_Bits(Empty_internal),
//        .Sync_Bits(Empty)
//    );
//    
//    Synchronizer #(
//        .Num_Stages(Num_Stages),
//        .Bus_Width('b1)
//    ) Full_Synchronizer(
//        .clk(clk_write),
//        .rst_n(rst_n),
//        .Async_Bits(Full_internal),
//        .Sync_Bits(Full)
//    );
 
assign Empty = Empty_internal;
assign Full = Full_internal;
	
endmodule : FIFO
