`timescale 1ns / 1ps

module Multiplier(
    input [7:0] a,b,
    output [7:0]outFin
    );
     reg outSign;
     reg [3:0] outSig,outExp;
     
     wire aSign, bSign;
     wire [3:0] aSig, bSig,  aExp, bExp, sumExp; 
     
     wire [7:0] multOut;
     wire [7:0]fMult;
         
    //assign val for easier tracking         
     assign aSign=a[6]; assign bSign=b[6];
     assign aExp={1'b0,a[6:4]}; assign bExp={1'b0, b[6:4]};
     assign aSig=a[3:0]; assign bSig=b[3:0];
    
    //Add exp
    assign sumExp=aExp+bExp;
    //Do mult (unsigned?)
    Mult2Vals US(aSig, bSig, fMult);


    assign outFin={outSign, outExp, outSig};
    
    
always @(*) begin
//1.If either is 0, return 0, ignoring denorm, if need denorm::: if((aSig[3]==0)||(bSig[3]==0)||sumExp<3) 
//2. If sum of exp is less than 3 then underflow bc already offset by 3
    if((aSig==0)||(bSig==0)||(sumExp<3)) begin outExp=0; outSig=0; outSign=0; end
//3. If both inputs are nonzero and exp dont overflow, then product of amntisa will be in range
//from just less than 1 down to 0.25?
//3.1 Sig1*SIg2 high bit set-> top 5? outSig, outExp=exp1+exp2-3
    if(fMult[7]==1) begin
        outExp=sumExp-3;
        outSig=fMult[7:4];
    end
//3.2 2nd bit set bc outSig>=0.25, sig is top 5? bits shifted left once, outExp=e1+e2-3-1
    else begin
        outExp=sumExp-4;
        outSig=fMult[6:3];
    end
//4. sign=^
    outSign=aSign^bSign;
 
end//end comb
 endmodule


module Mult2Vals(
    input [3:0] a,b,
    output [7:0] c
    );
    reg [7:0] sum;
always @(*) begin
    sum=0;
    sum=sum+((b[3])?a:0); sum=sum<<1;
    sum=sum+((b[2])?a:0); sum=sum<<1;
    sum=sum+((b[1])?a:0); sum=sum<<1;
    sum=sum+((b[0])?a:0);
end
    assign c=sum;
endmodule
