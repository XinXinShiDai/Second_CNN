module Mul_Add(
clk,
rst_n,
Cal_Valid,
window_buffer0,
window_buffer1,
window_buffer2,
window_buffer3,
window_buffer4,
window_buffer5,
window_buffer6,
window_buffer7,
window_buffer8,
weight_buffer0,
weight_buffer1,
weight_buffer2,
weight_buffer3,
weight_buffer4,
weight_buffer5,
weight_buffer6,
weight_buffer7,
weight_buffer8,
Dout
);

  parameter WIDTH=8;
  input clk;
  input rst_n;
  input Cal_Valid;
  input signed [WIDTH-1:0] 
    window_buffer0,
    window_buffer1,
    window_buffer2,
    window_buffer3,
    window_buffer4,
    window_buffer5,
    window_buffer6,
    window_buffer7,
    window_buffer8,
    weight_buffer0,
    weight_buffer1,
    weight_buffer2,
    weight_buffer3,
    weight_buffer4,
    weight_buffer5,
    weight_buffer6,
    weight_buffer7,
    weight_buffer8;
  output reg signed [2*WIDTH-1:0] Dout; 
  reg signed [2*WIDTH-1:0] 
    channel_mul0,
    channel_mul1,
    channel_mul2,
    channel_mul3,
    channel_mul4,
    channel_mul5,
    channel_mul6,
    channel_mul7,
    channel_mul8;
  reg signed [2*WIDTH-1:0] channel_add [10:0];

  always @ (posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      channel_mul0   <= 0;
      channel_mul1   <= 0;
      channel_mul2   <= 0;
      channel_mul3   <= 0;
      channel_mul4   <= 0;
      channel_mul5   <= 0;
      channel_mul6   <= 0;  
      channel_mul7   <= 0;
      channel_mul8   <= 0;
      channel_add[0] <= 0;
      channel_add[1] <= 0;
      channel_add[2] <= 0;
      channel_add[3] <= 0;
      channel_add[4] <= 0;
      channel_add[5] <= 0;
      channel_add[6] <= 0;
      channel_add[7] <= 0;
      channel_add[8] <= 0;
      Dout           <= 0;
    end
    else begin
      if(Cal_Valid) begin
        channel_mul0 <= window_buffer0 * weight_buffer8;
        channel_mul1 <= window_buffer1 * weight_buffer7;
        channel_mul2 <= window_buffer2 * weight_buffer6;
        channel_mul3 <= window_buffer3 * weight_buffer5;
        channel_mul4 <= window_buffer4 * weight_buffer4;
        channel_mul5 <= window_buffer5 * weight_buffer3;
        channel_mul6 <= window_buffer6 * weight_buffer2;
        channel_mul7 <= window_buffer7 * weight_buffer1;
        channel_mul8 <= window_buffer8 * weight_buffer0;

        channel_add[0] <= channel_mul0 + channel_mul1;
        channel_add[1] <= channel_mul2 + channel_mul3;
        channel_add[2] <= channel_mul4 + channel_mul5;
        channel_add[3] <= channel_mul6 + channel_mul7;
        channel_add[4] <= channel_mul8;

        channel_add[5] <= channel_add[0] + channel_add[1];
        channel_add[6] <= channel_add[2] + channel_add[3];
        channel_add[7] <= channel_add[4];

        channel_add[8] <= channel_add[5] + channel_add[6];
        channel_add[9] <= channel_add[7];

        channel_add[10]<= channel_add[8] + channel_add[9];

        Dout           <= channel_add[10];
      end
      else begin
        channel_mul0   <= 0;
        channel_mul1   <= 0;
        channel_mul2   <= 0;
        channel_mul3   <= 0;
        channel_mul4   <= 0;
        channel_mul5   <= 0;
        channel_mul6   <= 0;  
        channel_mul7   <= 0;
        channel_mul8   <= 0; 
        channel_add[0] <= 0;
        channel_add[1] <= 0;
        channel_add[2] <= 0;
        channel_add[3] <= 0;
        channel_add[4] <= 0;
        channel_add[5] <= 0;
        channel_add[6] <= 0;
        channel_add[7] <= 0;
        channel_add[8] <= 0;
        Dout           <= 0;
      end
    end 
  end

endmodule