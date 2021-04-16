`timescale 1ns / 1ps

module Multiplier(
    input [7:0] a,b,
    output [7:0]outFin
    );
     reg outSign;
     reg [2:0] outExp;
     
     wire aSign, bSign;
     wire [4:0] aSig, bSig,  aExp, bExp, sumExp; 
     reg[3:0] outFrac= 0;
     wire [7:0] multOut;
     wire [9:0]fMult;
         
    //assign val for easier tracking         
     assign aSign=a[7]; assign bSign=b[7];
     assign aExp={1'b0,a[6:4]}; assign bExp={1'b0, b[6:4]};
     assign aSig={1'b1,a[3:0]}; assign bSig={1'b1,b[3:0]};
    
    //Add exp
    assign sumExp=aExp+bExp;
  // fix exp with a reg and then adjust the fmult otherwise we might be good
    
    //Do mult (unsigned?)
    Mult2Vals US(aSig, bSig, fMult);


    assign outFin={outSign, outExp, outFrac};
    
    
always @(*) begin
   if(sumExp<5'd3) begin outExp = 0;
   outFrac = 0;
   outSign = 0;
   end
   else begin
    
    outSign = aSign^bSign;
    if(fMult[9]) begin
    outExp = sumExp - 4'd2;
        outFrac=fMult[8:5];
    end
//3.2 2nd bit set bc outSig>=0.25, sig is top 5? bits shifted left once, outExp=e1+e2-3-1
    else
    if(fMult[8]) begin
        outExp = sumExp - 4'd3;
        outFrac=fMult[7:4];
    end

//4. sign=^
   
 
end//end comb
end
 endmodule


module Mult2Vals(
    input [4:0] a,b,
    output [9:0] c
    );
    
    assign c = a*b;
endmodule
