`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/17/2021 02:17:46 PM
// Design Name: 
// Module Name: FPMAC
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


module FPMAC(input [7:0] B,
input [7:0] C,
input clk,reset,
output [7:0] outA,
output [7:0] outB,outC

    );
    
    reg [7:0] Bout, Cout;
    reg [7:0] A = 0;
    assign outB = Bout;
    assign outC = Cout;
    assign outA = A;
    wire[7:0] multout;
    wire[7:0] addout;
    Multiplier multiplication(B,C,multout);
    Adder addition(outA,multout,addout);
    
    
    always@(posedge clk) begin
    if(reset) A <= 0; else begin
    if(B && C) begin
    A<=addout;
    Bout <=B;
    Cout <=C;
    end
    else if (B == 0)begin
    Bout <=0;
    Cout <=C;
    end
    else if (C == 0) begin
    Bout <=B;
    Cout <= 0;
    end
    else begin
    Bout <= 0;
    Cout <= 0;
    end
    end
    end
endmodule


