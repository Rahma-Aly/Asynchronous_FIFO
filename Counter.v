module Counter#(parameter ADDR_WIDTH = 5)(
	input                       En,
	input                       rst_n,
	input                       clk,
	output reg [ADDR_WIDTH:0]   Binary_out
);



always @(negedge rst_n or posedge clk) begin
    if (~rst_n) begin
        Binary_out <= 0;
    end
    else if (En) begin
         Binary_out <= Binary_out + 1; 
    end
    else begin
            Binary_out <= Binary_out;
    end
end






	
endmodule : Counter
