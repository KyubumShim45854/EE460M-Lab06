`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/14/2021 06:27:32 PM
// Design Name: 
// Module Name: systolic
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module systolic(
input[7:0] A00,A01,A02,A10,A11,A12,A20,A21,A22,
input [7:0] B00,B01,B02,B10,B11,B12,B20,B21,B22,
input clk, reset
    );
wire [7:0] Cwire[11:0];
wire [7:0] Bwire[11:0];
wire[7:0] out [8:0];



reg [7:0] ARow0 [3:1];
reg [7:0] BRow0 [3:1];
reg [7:0] ARow1 [4:1];
reg [7:0] BRow1 [4:1];
reg [7:0] ARow2 [5:1];
reg [7:0] BRow2 [5:1];
reg[3:0] count = 0;
// row 1

always@(A00,A01,A02,A10,A11,A12,A20,A21,A22,B00,B01,B02,B10,B12,B20,B21,B22)
begin
 ARow0[1] = A00;
 ARow0[2] = A01;
 ARow0[3] = A02;
 BRow0[1] = B00;
 BRow0[2] = B10;
 BRow0[3] = B20;
// row 2, first is a gap
 ARow1[1] = 0; // gap
 ARow1[2] = A10;
 ARow1[3] = A11;
 ARow1[4] = A12;
 BRow1[1] = 0;
 BRow1[2] = B01;
 BRow1[3] = B11;
 BRow1[4] = B21;
// row 3
 ARow2[1] = 0;
 ARow2[2] = 0;
 ARow2[3] = A20;
 ARow2[4] = A21;
 ARow2[5] = A22;
 BRow2[1] = 0;
 BRow2[2] = 0;
 BRow2[3] = B02;
 BRow2[4] = B12;
 BRow2[5] = B22;
end


always@(posedge clk)
begin
count <= count +1;
if(reset) count <= 0;


end


assign Bwire[0] = BRow0[count];
assign Bwire[1] = BRow1[count];
assign Bwire[2] = BRow2[count];
assign Cwire[0] = ARow0[count];
assign Cwire[1] = ARow1[count];
assign Cwire[2] = ARow2[count];


// mac goes (B,C, clk, outA,Bout,Cout)
// first pass  

    
    
mac mac00(Bwire[0],Cwire[0],clk,out[0],Bwire[3],Cwire[3]);
//second pass

mac mac01(Bwire[1],Cwire[3],clk,out[1],Bwire[5],Cwire[6]);
mac mac10(Bwire[3],Cwire[1],clk,out[2],Bwire[4],Cwire[4]);
// third pass

mac mac02(Bwire[2],Cwire[6],clk,out[3],Bwire[7],Cwire[9]);
mac mac20(Bwire[4],Cwire[2],clk,out[4],Bwire[9],Cwire[5]);
mac mac11(Bwire[5],Cwire[4],clk,out[5],Bwire[6],Cwire[7]);
// fourth pass
mac mac21(Bwire[6],Cwire[5],clk,out[6],Bwire[10],Cwire[8]);
mac mac12(Bwire[7],Cwire[7],clk,out[7],Bwire[8],Cwire[10]);
// fifth pass
mac mac22(Bwire[8],Cwire[8],clk,out[8],Bwire[11],Cwire[11]);

    
endmodule
