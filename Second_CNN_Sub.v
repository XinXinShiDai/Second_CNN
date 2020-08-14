module Second_CNN_Sub(
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
    Dout7
);

    parameter WIDTH=8;

    input clk;
    input rst_n;
    input Din_Valid;
    input Cal_Valid;
    input  signed [WIDTH-1:0] Din;
    output signed [2*WIDTH-1:0] Dout0;
    output signed [2*WIDTH-1:0] Dout1;
    output signed [2*WIDTH-1:0] Dout2;
    output signed [2*WIDTH-1:0] Dout3;
    output signed [2*WIDTH-1:0] Dout4;
    output signed [2*WIDTH-1:0] Dout5;
    output signed [2*WIDTH-1:0] Dout6;
    output signed [2*WIDTH-1:0] Dout7;

    reg signed [311:0] line_buffer; // 18*18 特征图的行缓冲区；
    reg signed [WIDTH-1:0] window_buffer [8:0]; // 3*3 窗口的窗缓冲区；
    reg signed [WIDTH-1:0] weight_buffer [71:0];

    initial begin // 初始化权重；
        weight_buffer[0]=8'b00110100;
        weight_buffer[1]=8'b00011111;
        weight_buffer[2]=8'b11000100;
        weight_buffer[3]=8'b00111001;
        weight_buffer[4]=8'b00101100;
        weight_buffer[5]=8'b11111011;
        weight_buffer[6]=8'b00010010;
        weight_buffer[7]=8'b00110101;
        weight_buffer[8]=8'b00011010;
        weight_buffer[9]=8'b11101011;
        weight_buffer[10]=8'b00000000;
        weight_buffer[11]=8'b11111001;
        weight_buffer[12]=8'b11000111;
        weight_buffer[13]=8'b00001001;
        weight_buffer[14]=8'b00011000;
        weight_buffer[15]=8'b10110010;
        weight_buffer[16]=8'b11110110;
        weight_buffer[17]=8'b00110111;
        weight_buffer[18]=8'b00110011;
        weight_buffer[19]=8'b00011011;
        weight_buffer[20]=8'b11110110;
        weight_buffer[21]=8'b00000010;
        weight_buffer[22]=8'b00100100;
        weight_buffer[23]=8'b00001001;
        weight_buffer[24]=8'b11100100;
        weight_buffer[25]=8'b00100110;
        weight_buffer[26]=8'b00100001;
        weight_buffer[27]=8'b10111000;
        weight_buffer[28]=8'b11010010;
        weight_buffer[29]=8'b00001111;
        weight_buffer[30]=8'b10101001;
        weight_buffer[31]=8'b10110111;
        weight_buffer[32]=8'b00000010;
        weight_buffer[33]=8'b11011111;
        weight_buffer[34]=8'b10011100;
        weight_buffer[35]=8'b00000000;
        weight_buffer[36]=8'b11001111;
        weight_buffer[37]=8'b11101110;
        weight_buffer[38]=8'b00010111;
        weight_buffer[39]=8'b11001010;
        weight_buffer[40]=8'b10100101;
        weight_buffer[41]=8'b11010011;
        weight_buffer[42]=8'b11100011;
        weight_buffer[43]=8'b11101000;
        weight_buffer[44]=8'b11101110;
        weight_buffer[45]=8'b00001001;
        weight_buffer[46]=8'b00101100;
        weight_buffer[47]=8'b00011000;
        weight_buffer[48]=8'b11011110;
        weight_buffer[49]=8'b00000101;
        weight_buffer[50]=8'b00000110;
        weight_buffer[51]=8'b11010010;
        weight_buffer[52]=8'b11111111;
        weight_buffer[53]=8'b11111101;
        weight_buffer[54]=8'b10011100;
        weight_buffer[55]=8'b11001011;
        weight_buffer[56]=8'b00100001;
        weight_buffer[57]=8'b10011100;
        weight_buffer[58]=8'b10011100;
        weight_buffer[59]=8'b11100011;
        weight_buffer[60]=8'b11010011;
        weight_buffer[61]=8'b10011100;
        weight_buffer[62]=8'b11011101;
        weight_buffer[63]=8'b00100010;
        weight_buffer[64]=8'b00101001;
        weight_buffer[65]=8'b00000010;
        weight_buffer[66]=8'b11111000;
        weight_buffer[67]=8'b00010101;
        weight_buffer[68]=8'b11111100;
        weight_buffer[69]=8'b11011001;
        weight_buffer[70]=8'b00000110;
        weight_buffer[71]=8'b00000101;
    end

    // 窗口的例化连接；
    wire signed [WIDTH-1:0]
    window_buffer0,window_buffer1,window_buffer2,window_buffer3,
    window_buffer4,window_buffer5,window_buffer6,window_buffer7,
    window_buffer8,weight_buffer0,weight_buffer1,weight_buffer2,
    weight_buffer3,weight_buffer4,weight_buffer5,weight_buffer6,
    weight_buffer7,weight_buffer8,weight_buffer9,weight_buffer10,
    weight_buffer11,weight_buffer12,weight_buffer13,weight_buffer14,weight_buffer15,
    weight_buffer16,weight_buffer17,weight_buffer18,weight_buffer19,weight_buffer20, 
    weight_buffer21,weight_buffer22,weight_buffer23,weight_buffer24,weight_buffer25,
    weight_buffer26,weight_buffer27,weight_buffer28,weight_buffer29,weight_buffer30,
    weight_buffer31,weight_buffer32,weight_buffer33,weight_buffer34,weight_buffer35,
    weight_buffer36,weight_buffer37,weight_buffer38,weight_buffer39,weight_buffer40,
    weight_buffer41,weight_buffer42,weight_buffer43,weight_buffer44,weight_buffer45,
    weight_buffer46,weight_buffer47,weight_buffer48,weight_buffer49,weight_buffer50,
    weight_buffer51,weight_buffer52,weight_buffer53,weight_buffer54,weight_buffer55, 
    weight_buffer56,weight_buffer57,weight_buffer58,weight_buffer59,weight_buffer60,
    weight_buffer61,weight_buffer62,weight_buffer63,weight_buffer64,weight_buffer65,
    weight_buffer66,weight_buffer67,weight_buffer68,weight_buffer69,weight_buffer70,
    weight_buffer71;

    assign weight_buffer0=weight_buffer[0];   assign weight_buffer1=weight_buffer[1];		      
    assign weight_buffer2=weight_buffer[2];   assign weight_buffer3=weight_buffer[3];		        
    assign weight_buffer4=weight_buffer[4];   assign weight_buffer5=weight_buffer[5];		         
    assign weight_buffer6=weight_buffer[6];   assign weight_buffer7=weight_buffer[7];		       
    assign weight_buffer8=weight_buffer[8];   assign weight_buffer9=weight_buffer[9];		
    assign weight_buffer10=weight_buffer[10]; assign weight_buffer11=weight_buffer[11];            
    assign weight_buffer12=weight_buffer[12]; assign weight_buffer13=weight_buffer[13];            
    assign weight_buffer14=weight_buffer[14]; assign weight_buffer15=weight_buffer[15];            
    assign weight_buffer16=weight_buffer[16]; assign weight_buffer17=weight_buffer[17]; 
    assign weight_buffer17=weight_buffer[17]; assign weight_buffer18=weight_buffer[18]; 
    assign weight_buffer19=weight_buffer[19]; assign weight_buffer20=weight_buffer[20]; 
    assign weight_buffer21=weight_buffer[21]; assign weight_buffer22=weight_buffer[22]; 
    assign weight_buffer23=weight_buffer[23]; assign weight_buffer24=weight_buffer[24]; 
    assign weight_buffer25=weight_buffer[25]; assign weight_buffer26=weight_buffer[26]; 
    assign weight_buffer27=weight_buffer[27]; assign weight_buffer28=weight_buffer[28];            
    assign weight_buffer29=weight_buffer[29]; assign weight_buffer30=weight_buffer[30]; 
    assign weight_buffer31=weight_buffer[31]; assign weight_buffer32=weight_buffer[32];            
    assign weight_buffer33=weight_buffer[33]; assign weight_buffer34=weight_buffer[34];            
    assign weight_buffer35=weight_buffer[35]; assign weight_buffer36=weight_buffer[36]; 
    assign weight_buffer37=weight_buffer[37]; assign weight_buffer38=weight_buffer[38];            
    assign weight_buffer39=weight_buffer[39]; assign weight_buffer40=weight_buffer[40]; 
    assign weight_buffer41=weight_buffer[41]; assign weight_buffer42=weight_buffer[42];            
    assign weight_buffer43=weight_buffer[43]; assign weight_buffer44=weight_buffer[44];            
    assign weight_buffer45=weight_buffer[45]; assign weight_buffer46=weight_buffer[46]; 
    assign weight_buffer47=weight_buffer[47]; assign weight_buffer48=weight_buffer[48];            
    assign weight_buffer49=weight_buffer[49]; assign weight_buffer50=weight_buffer[50]; 
    assign weight_buffer51=weight_buffer[51]; assign weight_buffer52=weight_buffer[52]; 
    assign weight_buffer53=weight_buffer[53]; assign weight_buffer54=weight_buffer[54];            
    assign weight_buffer55=weight_buffer[55]; assign weight_buffer56=weight_buffer[56];            
    assign weight_buffer57=weight_buffer[57]; assign weight_buffer58=weight_buffer[58]; 
    assign weight_buffer59=weight_buffer[59]; assign weight_buffer60=weight_buffer[60];            
    assign weight_buffer61=weight_buffer[61]; assign weight_buffer62=weight_buffer[62]; 
    assign weight_buffer63=weight_buffer[63]; assign weight_buffer64=weight_buffer[64];
    assign weight_buffer65=weight_buffer[65]; assign weight_buffer66=weight_buffer[66];            
    assign weight_buffer67=weight_buffer[67]; assign weight_buffer68=weight_buffer[68]; 
    assign weight_buffer69=weight_buffer[69]; assign weight_buffer70=weight_buffer[70];            
    assign weight_buffer71=weight_buffer[71];               
    assign window_buffer0=window_buffer[0];   assign window_buffer1=window_buffer[1];                  
    assign window_buffer2=window_buffer[2];   assign window_buffer3=window_buffer[3];                    
    assign window_buffer4=window_buffer[4];   assign window_buffer5=window_buffer[5];                  
    assign window_buffer6=window_buffer[6];   assign window_buffer7=window_buffer[7];                    
    assign window_buffer8=window_buffer[8];
    
    // Data Buffer
    always @ (posedge clk or negedge rst_n) begin
        if (!rst_n)
            begin
                line_buffer      <= 312'd0;
                window_buffer[0] <= 8'd0;
                window_buffer[1] <= 8'd0;
                window_buffer[2] <= 8'd0;
                window_buffer[3] <= 8'd0;
                window_buffer[4] <= 8'd0;
                window_buffer[5] <= 8'd0;
                window_buffer[6] <= 8'd0;
                window_buffer[7] <= 8'd0;
                window_buffer[8] <= 8'd0;
            end
        else begin
            if(Din_Valid) begin
                line_buffer     <= {line_buffer[303:0],Din}; // 新输入的值放在最低的 8-bit，同时抛弃最高的 8-bit；
                window_buffer[8] <= line_buffer[311:304];
                window_buffer[7] <= line_buffer[303:296];
                window_buffer[6] <= line_buffer[295:288];
                window_buffer[5] <= line_buffer[167:160];
                window_buffer[4] <= line_buffer[159:152];
                window_buffer[3] <= line_buffer[151:144];
                window_buffer[2] <= line_buffer[23:16];
                window_buffer[1] <= line_buffer[15:8];
                window_buffer[0] <= line_buffer[7:0];               
            end
            else begin
                line_buffer <= line_buffer;
                window_buffer[0] <= window_buffer[0];
                window_buffer[1] <= window_buffer[1];
                window_buffer[2] <= window_buffer[2];
                window_buffer[3] <= window_buffer[3];
                window_buffer[4] <= window_buffer[4];
                window_buffer[5] <= window_buffer[5];
                window_buffer[6] <= window_buffer[6];
                window_buffer[7] <= window_buffer[7];
                window_buffer[8] <= window_buffer[9];                
            end
        end
                
    end
    
/**************例化8个乘加器**************/

Mul_Add Mul_Add0(.clk(clk),.rst_n(rst_n),.Cal_Valid(Cal_Valid),.Dout(Dout0),
.window_buffer0(window_buffer0),.window_buffer1(window_buffer1),.window_buffer2(window_buffer2),
.window_buffer3(window_buffer3),.window_buffer4(window_buffer4),.window_buffer5(window_buffer5),
.window_buffer6(window_buffer6),.window_buffer7(window_buffer7),.window_buffer8(window_buffer8),
.weight_buffer0(weight_buffer0),.weight_buffer1(weight_buffer1),.weight_buffer2(weight_buffer2),
.weight_buffer3(weight_buffer3),.weight_buffer4(weight_buffer4),.weight_buffer5(weight_buffer5),
.weight_buffer6(weight_buffer6),.weight_buffer7(weight_buffer7),.weight_buffer8(weight_buffer8)); 

Mul_Add Mul_Add1(.clk(clk),.rst_n(rst_n),.Cal_Valid(Cal_Valid),.Dout(Dout1),
.window_buffer0(window_buffer0),.window_buffer1(window_buffer1),.window_buffer2(window_buffer2),
.window_buffer3(window_buffer3),.window_buffer4(window_buffer4),.window_buffer5(window_buffer5),
.window_buffer6(window_buffer6),.window_buffer7(window_buffer7),.window_buffer8(window_buffer8),
.weight_buffer0(weight_buffer9),.weight_buffer1(weight_buffer10),.weight_buffer2(weight_buffer11),
.weight_buffer3(weight_buffer12),.weight_buffer4(weight_buffer13),.weight_buffer5(weight_buffer14),
.weight_buffer6(weight_buffer15),.weight_buffer7(weight_buffer16),.weight_buffer8(weight_buffer17));

Mul_Add Mul_Add2(.clk(clk),.rst_n(rst_n),.Cal_Valid(Cal_Valid),.Dout(Dout2),
.window_buffer0(window_buffer0),.window_buffer1(window_buffer1),.window_buffer2(window_buffer2),
.window_buffer3(window_buffer3),.window_buffer4(window_buffer4),.window_buffer5(window_buffer5),
.window_buffer6(window_buffer6),.window_buffer7(window_buffer7),.window_buffer8(window_buffer8),
.weight_buffer0(weight_buffer18),.weight_buffer1(weight_buffer19),.weight_buffer2(weight_buffer20),
.weight_buffer3(weight_buffer21),.weight_buffer4(weight_buffer22),.weight_buffer5(weight_buffer23),
.weight_buffer6(weight_buffer24),.weight_buffer7(weight_buffer25),.weight_buffer8(weight_buffer26));

Mul_Add Mul_Add3(.clk(clk),.rst_n(rst_n),.Cal_Valid(Cal_Valid),.Dout(Dout3),
.window_buffer0(window_buffer0),.window_buffer1(window_buffer1),.window_buffer2(window_buffer2),
.window_buffer3(window_buffer3),.window_buffer4(window_buffer4),.window_buffer5(window_buffer5),
.window_buffer6(window_buffer6),.window_buffer7(window_buffer7),.window_buffer8(window_buffer8),
.weight_buffer0(weight_buffer27),.weight_buffer1(weight_buffer28),.weight_buffer2(weight_buffer29),
.weight_buffer3(weight_buffer30),.weight_buffer4(weight_buffer31),.weight_buffer5(weight_buffer32),
.weight_buffer6(weight_buffer33),.weight_buffer7(weight_buffer34),.weight_buffer8(weight_buffer35));

Mul_Add Mul_Add4(.clk(clk),.rst_n(rst_n),.Cal_Valid(Cal_Valid),.Dout(Dout4),
.window_buffer0(window_buffer0),.window_buffer1(window_buffer1),.window_buffer2(window_buffer2),
.window_buffer3(window_buffer3),.window_buffer4(window_buffer4),.window_buffer5(window_buffer5),
.window_buffer6(window_buffer6),.window_buffer7(window_buffer7),.window_buffer8(window_buffer8),
.weight_buffer0(weight_buffer36),.weight_buffer1(weight_buffer37),.weight_buffer2(weight_buffer38),
.weight_buffer3(weight_buffer39),.weight_buffer4(weight_buffer40),.weight_buffer5(weight_buffer41),
.weight_buffer6(weight_buffer42),.weight_buffer7(weight_buffer43),.weight_buffer8(weight_buffer44));

Mul_Add Mul_Add5(.clk(clk),.rst_n(rst_n),.Cal_Valid(Cal_Valid),.Dout(Dout5),
.window_buffer0(window_buffer0),.window_buffer1(window_buffer1),.window_buffer2(window_buffer2),
.window_buffer3(window_buffer3),.window_buffer4(window_buffer4),.window_buffer5(window_buffer5),
.window_buffer6(window_buffer6),.window_buffer7(window_buffer7),.window_buffer8(window_buffer8),
.weight_buffer0(weight_buffer45),.weight_buffer1(weight_buffer46),.weight_buffer2(weight_buffer47),
.weight_buffer3(weight_buffer48),.weight_buffer4(weight_buffer49),.weight_buffer5(weight_buffer50),
.weight_buffer6(weight_buffer51),.weight_buffer7(weight_buffer52),.weight_buffer8(weight_buffer53));

Mul_Add Mul_Add6(.clk(clk),.rst_n(rst_n),.Cal_Valid(Cal_Valid),.Dout(Dout6),
.window_buffer0(window_buffer0),.window_buffer1(window_buffer1),.window_buffer2(window_buffer2),
.window_buffer3(window_buffer3),.window_buffer4(window_buffer4),.window_buffer5(window_buffer5),
.window_buffer6(window_buffer6),.window_buffer7(window_buffer7),.window_buffer8(window_buffer8),
.weight_buffer0(weight_buffer54),.weight_buffer1(weight_buffer55),.weight_buffer2(weight_buffer56),
.weight_buffer3(weight_buffer57),.weight_buffer4(weight_buffer58),.weight_buffer5(weight_buffer59),
.weight_buffer6(weight_buffer60),.weight_buffer7(weight_buffer61),.weight_buffer8(weight_buffer62));

Mul_Add Mul_Add7(.clk(clk),.rst_n(rst_n),.Cal_Valid(Cal_Valid),.Dout(Dout7),
.window_buffer0(window_buffer0),.window_buffer1(window_buffer1),.window_buffer2(window_buffer2),
.window_buffer3(window_buffer3),.window_buffer4(window_buffer4),.window_buffer5(window_buffer5),
.window_buffer6(window_buffer6),.window_buffer7(window_buffer7),.window_buffer8(window_buffer8),
.weight_buffer0(weight_buffer63),.weight_buffer1(weight_buffer64),.weight_buffer2(weight_buffer65),
.weight_buffer3(weight_buffer66),.weight_buffer4(weight_buffer67),.weight_buffer5(weight_buffer68),
.weight_buffer6(weight_buffer69),.weight_buffer7(weight_buffer70),.weight_buffer8(weight_buffer71));

endmodule