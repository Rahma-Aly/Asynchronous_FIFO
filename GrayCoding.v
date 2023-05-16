module GrayCoding #(parameter ADDR_WIDTH = 5)(
	input                      clk,
	input                      rst_n,
	input       [ADDR_WIDTH:0] BinaryVal,
	output reg  [ADDR_WIDTH:0] GrayVal
);

 
always @(negedge rst_n or posedge clk) begin
     if (~rst_n) begin
        GrayVal <= 0;
    end
    else begin
            GrayVal <= BinaryVal ^ (BinaryVal >> 1);
    end
end

//   genvar i;
//   assign GrayVal [ADDR_WIDTH] = BinaryVal [ADDR_WIDTH];
//   
//   generate 
//   for (i = ADDR_WIDTH-1; i>=0 ; i = i - 1) begin
//       assign GrayVal [i] = BinaryVal[i]^BinaryVal[i+1];
//   end
//   endgenerate 
   
	
endmodule : GrayCoding
