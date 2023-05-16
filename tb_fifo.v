`timescale 1ns/1ns
module tb_fifo 
#(parameter Addr_Width = 5,
            Data_Width = 8)
();
    reg                         Wr_enable, clk_read, clk_write, rst_n, Read_enable;
    reg     [Data_Width-1:0]    DataIn;
    wire    [Data_Width-1:0]    DataOut;
    wire                        Empty,Full;
    integer i;

    // clock configuration
    initial begin
       clk_write = 1'b0;
        forever  #5 clk_write = !clk_write;       
    end
    initial begin
       clk_read = 1'b0;
        forever  #8 clk_read = !clk_read;       
    end

    //Instantiation
    FIFO #(
        .ADDR_WIDTH(Addr_Width),
        .DATA_WIDTH(Data_Width)
    ) FIFO_instance(
        .clk_read(clk_read),
        .clk_write(clk_write),
        .rst_n(rst_n),
        .DataIn(DataIn),
        .Wr_enable(Wr_enable),
        .Read_enable(Read_enable),
        .DataOut(DataOut),
        .Empty(Empty),
        .Full(Full)
    );

       //Initial block
    initial begin
        rst_n = 1'b1;
        Wr_enable = 1'b0;
        Read_enable = 1'b0;
        DataIn = 'd0;
        #10
        rst_n = 1'b0;
        #10
        rst_n = 1'b1;
        //-----------------------case 1----------------------------//
        //--------------check the read of the empty fifo-----------//
        #17
        if( Empty == 1'b1)
        begin
            $display("The FIFO is empty");
        end
        else
        begin
            $display("The FIFO is not empty");
        end
        //-----------------------case 2-----------------------//
        //------------write two data in the fifo--------------//
        #10
        Read_enable = 1'b0;
        Wr_enable = 1'b1;
        DataIn = 'b01010101;
        #10
        DataIn = 'b10000001;
        #10
        Wr_enable = 1'b0;
        #20
        Read_enable = 1'b1;
        //------------------------------case 3----------------------------------//
        //--------------read the two data in the fifo to make it empty---------//
        #15
        if (DataOut == 'b01010101) begin
            $display("The first output is correct");
        end
        else
        begin
            $display("The first output is incorrect");
        end
        #10
        if (DataOut == 'b10000001) begin
            $display("The second output is correct");
        end
        else
        begin
            $display("The second output is incorrect");
        end
        #10
        Read_enable = 1'b0;
        #10
        //-------------------------case 4----------------------------//
        //----------------Fill the fifo to rise the full flag-------//
        for (i=0 ; i<(2**Addr_Width);i=i+1 ) 
        begin
            Wr_enable = 1'b1;
            DataIn = 'b00000000+i;
            #10;
        end
        //----------------check the full flag-------------//
        #30
        Wr_enable = 1'b0;
        if (Full == 1'b1) begin
            $display("The FIFO is full");
        end
        else
        begin
            $display("The FIFO is not full");
        end
        //-------------------------case 5-----------------------------//
        //-------------read all the fifo and check the empty----------//
        #10
        Read_enable = 1'b1;
        #520
        Read_enable = 1'b0;
        if (Empty == 1'b1) begin
            $display("The FIFO is empty");
        end
        else
        begin
            $display("The FIFO is not empty");
        end
// $stop;
    end
endmodule