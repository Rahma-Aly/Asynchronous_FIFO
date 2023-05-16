module Synchronizer#(parameter Num_Stages = 2, Bus_Width = 1, RST_VAL = 0)(
    input                      clk,
    input                      rst_n,
    input      [Bus_Width-1:0] Async_Bits,
    output reg [Bus_Width-1:0] Sync_Bits
);

reg [Num_Stages-1:0] Q [Bus_Width-1:0];
integer i;

    always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        for (i = 0; i < Bus_Width ; i = i + 1 ) begin
            Q[i] <= RST_VAL;
        end
    end
    else begin
            for (i = 0; i < Bus_Width ; i = i + 1 ) begin
                Q[i] <= {Q[i][Num_Stages-2:0],Async_Bits[i]};
            end
        end
    end
    
    always@(*) begin
        for (i = 0; i < Bus_Width ; i = i + 1 ) begin
            Sync_Bits[i] = Q[i][Num_Stages-1];
        end
    end
    
endmodule : Synchronizer
