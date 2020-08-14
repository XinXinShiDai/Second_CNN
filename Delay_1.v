module Delay_1(
	input  aclk,
	input  aresetn,
	input  iStart,
	output oStart
);

reg Start_Delay; // 数据位宽决定了延时长度；

always @(posedge aclk or negedge aresetn) begin
    if(!aresetn) begin
        Start_Delay <= 0;
    end
    else begin
        Start_Delay <= iStart;
    end
end

assign oStart = Start_Delay;

endmodule