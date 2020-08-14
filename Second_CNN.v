module Second_CNN(
clk,
rst_n,
Din_Valid,
Cal_Valid,
Din,
Dout0,
Dout1,
Dout2,
Dout3,
Dout4,
Dout5,
Dout6,
Dout7,
);

parameter WIDTH = 8;

input clk;
input rst_n;
input Din_Valid;
input Cal_Valid;
input signed [WIDTH-1:0] Din; // 8-bit 输入图像；
output wire signed [2*WIDTH-1:0] Dout0,Dout1,Dout2,Dout3,Dout4,Dout5,Dout6,Dout7; // 卷积结果；

Second_CNN_Sub Second_CNN_Sub( .clk(clk), .rst_n(rst_n),
.Din(Din),.Din_Valid(Din_Valid),.Cal_Valid(Cal_Valid),
.Dout0(Dout0), .Dout1(Dout1),.Dout2(Dout2), .Dout3(Dout3),
.Dout4(Dout4), .Dout5(Dout5),.Dout6(Dout6), .Dout7(Dout7));

endmodule