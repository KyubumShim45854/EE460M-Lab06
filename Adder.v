`timescale 1ns / 1ps

module Adder(
    input[7:0] a,b,
    output [7:0] z
    );
    
    
    wire aSign, bSign;
    assign aSign=a[7]; assign bSign=b[7];
    //Pass in Exponents as offset by 3 so no negative exponents leave
    wire [2:0] aExp, bExp;
    assign aExp=a[6:4]; assign bExp=b[6:4];
    wire [3:0] aSig,bSig;
    assign aSig=a[3:0]; assign bSig=b[3:0];    
    
    //Skip for if either are 0
    reg [1:0] zeroCase;
    //Simplify equations
    reg [4:0] smExp;
    reg [4:0] lgExp;
    reg [4:0] dfExp;
    reg [4:0] sumExp;
    reg[3:0] smSig;
    reg[3:0] lgSig;
    reg[4:0] sumSig;
    reg largeCount=0;
    //For loop for different signed
    reg [3:0] indexCount;

always@(*) begin

//1. If both inputs are zero, sum is zero
    zeroCase[0]=((aExp==0)&&(aSig==0))?1:0;
    zeroCase[1]=((bExp==0)&&(bSig==0))?1:0;
    //All zeros
    if(zeroCase==2'b11) begin sumSig=0;sumExp=0; end
    //b=0
    else if(zeroCase==2'b10) begin sumSig=aSig; sumExp=aExp; end
    //a=0
    else if(zeroCase==2'b01) begin sumSig=bSig; sumExp=bExp; end
    else begin
    //2. Determine bigger input by comparing exponenets and mantissas
        //Different Signs
        if(aSign!=bSign) begin
            //if a is neg
            if(aSign) begin  smExp=aExp;lgExp=bExp;smSig=aSig;lgSig=bSig; largeCount=0;  end
            else begin smExp=bExp;lgExp=aExp; smSig=bSig; lgSig=aSig; largeCount=1;  end
        end
        //Same sign, differnt exponents
        else if(aExp!=bExp) begin
            if(aExp<bExp) begin  smExp=aExp;lgExp=bExp;smSig=aSig;lgSig=bSig; largeCount=0;  end
            else begin smExp=bExp;lgExp=aExp; smSig=bSig; lgSig=aSig; largeCount=1;  end
        end
        //Same sign and exponents, different Sig?
        else begin
            if(aSig<=bSig) begin  smExp=aExp;lgExp=bExp;smSig=aSig;lgSig=bSig; largeCount=0;  end
            else begin smExp=bExp;lgExp=aExp; smSig=bSig; lgSig=aSig; largeCount=1;  end
        end  
        
    //3. Determine difference in exponents and shift smaller Sig right to diff
    //Dc about truncated values anyways
        dfExp=lgExp-smExp;  
        sumSig=smSig>>dfExp;
        sumExp=lgExp;
        //if diff in Exp >3, no need to do calc.
        if(dfExp<3) begin
        //4. If same sign, add big& shifted sig, if >1, shift sig sum right 1 bit and increment exp
            if(aSign==bSign) begin    
                sumSig=lgSig+smSig;
                if(sumSig[4])begin
                    sumSig=sumSig>>1;
                    sumExp=lgExp+1;
                end
           end//end 4.
        //5. If diff signs, subtract bigger and smaller so result is positive,
        // shift mant until high bit set, decrement exp, sign is of bigger input   .
            else begin
                sumSig=lgSig-smSig;
                for (indexCount=4;indexCount!=0;indexCount=indexCount-1) begin
                    if(sumSig[4]==sumSig[3]) begin
                        sumSig=sumSig<<1;
                        sumExp=sumExp-1;
                    end
                end
            end//end 5.
        end//end 3.if diffExp<3
        else begin
            if(largeCount) begin sumSig=bSig;sumExp=bExp; end
            else begin sumSig=aSig; sumExp=aExp; end
        end//end else loop
    end//nonzero loop
end      
endmodule
