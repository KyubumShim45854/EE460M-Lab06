`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/14/2021 04:46:08 PM
// Design Name: 
// Module Name: mac
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


module mac(
input [7:0] B,
input [7:0] C,
input clk,
output [7:0] outA,
output [7:0] outB,outC
    );
    
    reg [7:0] Bout, Cout;
    reg [7:0] A = 0;
    assign outB = Bout;
    assign outC = Cout;
    assign outA = A;
  
    always@(posedge clk)begin
    if(B && C) begin
    A <= A + B*C;
    Bout <=B;
    Cout <=C;
    end
    else if (B == 0)begin
    Bout <=0;
    Cout <=C;
    end
    else if (C == 0) begin
    Bout <= B;
    Cout <= 0;
    end
    else begin
    Bout <= 0;
    Cout <= 0;
    end
    
    end
    
    
    
    
    
        
    
    
    
   
endmodule
