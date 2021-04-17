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
    reg [4:0] smExp, lgExp, dfExp, sumExp;
    reg[4:0] smSig, lgSig;
    reg[5:0] sumSig;
    reg smSign, lgSign, sumSign;
    reg largeCount=0;
    reg diffSignWhichBigger=0;
    //For loop for different signed
    reg [3:0] indexCount;
    reg [7:0] blank;
    reg [3:0] outSig;
    reg flag;

    reg [7:0] compReg1, compReg2;
    
    
    assign z={sumSign,sumExp[2:0],outSig[3:0]};
always@(*) begin
//1. If both inputs are zero, sum is zero
    zeroCase[0]=((aExp==0)&&(aSig==0))?1:0;
    zeroCase[1]=((bExp==0)&&(bSig==0))?1:0;
    //All zeros
    if(zeroCase==2'b11) begin outSig=0;sumExp=0;sumSign=0; end
    //b=0
    else if(zeroCase==2'b10) begin outSig=aSig; sumExp=aExp;sumSign=aSign; end
    //a=0
    else if(zeroCase==2'b01) begin outSig=bSig; sumExp=bExp; sumSign=bSign;end
    else begin
    //2. Determine bigger input by comparing exponenets and mantissas
        //Different Signs
//        if(aSign!=bSign) begin
//            //sumSign will be set later for this case
//            //if a is neg         
//            if(aSign) begin  smSign=aSign; lgSign=bSign; smExp=aExp;lgExp=bExp;smSig=aSig;lgSig=bSig; largeCount=0; sumSign=0;  end
//            else begin smSign=bSign; lgSign=aSign; smExp=bExp;lgExp=aExp; smSig=bSig; lgSig=aSig; largeCount=1;  sumSign=0; end
//        end
        //Same sign, differnt exponents
        //else
         if(aExp!=bExp) begin
            sumSign=aSign;
            if(aExp<bExp) begin smSign=aSign; lgSign=bSign; smExp=aExp;lgExp=bExp;smSig=aSig;lgSig=bSig; largeCount=0;  end
            else begin smSign=bSign; lgSign=aSign; smExp=bExp;lgExp=aExp; smSig=bSig; lgSig=aSig; largeCount=1;  end
        end
        //Same sign and exponents, different Sig?
        else begin
            sumSign=aSign;
            if(aSig<=bSig) begin  smSign=aSign; lgSign=bSign;smExp=aExp;lgExp=bExp;smSig=aSig;lgSig=bSig; largeCount=0;  end
            else begin smSign=bSign; lgSign=aSign; smExp=bExp;lgExp=aExp; smSig=bSig; lgSig=aSig; largeCount=1;  end
        end  
        
        smSig[4]=1;
        lgSig[4]=1;       
        //3. Determine difference in exponents and shift smaller Sig right to diff
        //Dc about truncated values anyways
        dfExp=(lgExp>smExp)?lgExp-smExp:smExp-lgExp;
          
        smSig=smSig>>dfExp;
        sumExp=lgExp;

    //if diff in Exp >3, no need to do calc.
//        if(dfExp<=8) begin
            //4. If same sign, add big& shifted sig, if >1, shift sig sum right 1 bit and increment exp
            if(aSign==bSign) begin    
                sumSig=lgSig+smSig;
                if(sumSig[5])begin
                    flag=1;
                    sumSig=sumSig>>1;
                    sumExp=lgExp+1;
                end
              outSig[3:0]=sumSig[3:0];
              end//end 4.
       
            //5. If diff signs, subtract bigger and smaller so result is positive,
            // shift mant until high bit set, decrement exp, sign is of bigger input   .
            else begin
            flag=1;
            //if X+(-X)
                if((lgSig==smSig)&&(dfExp==0)) begin flag=1; outSig=4'b0000; sumSign=0; sumExp=3'b000; end
                else begin
                    //check unsigned larger value
                    //Positive result
                    sumSig=lgSig-smSig;
                    flag=1;
                    
                    sumSign=(lgSign==0)?0:1;
                    compReg1=sumSig;                
                    //Loop for normalizing
                    for (indexCount=4;indexCount!=0;indexCount=indexCount-1) begin
                        //Need for normalizing
                        if(sumSig[4]==0) begin
                            //Cant normalize if exp=0
                            if(sumExp>0) begin
                                sumSig=sumSig<<1;
                                sumExp=sumExp-1;
                            end
                        end//Outer if
                        //For cases in which difference is too small to show eg. 0.125->0&-0.125->0 instead of 80
    
                    end//For                    
                if(sumExp==0&&sumSig==0) sumSign=0;
                outSig[3:0]=sumSig[3:0];
                end//inner else begin              
            end//end 5.
//            end//end 3.if diffExp<3
//            else begin
//                if(!largeCount) begin outSig=bSig;sumExp=bExp;sumSign=bSign; end
//                else begin outSig=aSig; sumExp=aExp; sumSign=aSign; end
//            end//end else loop
        end//nonzero loop
end      
endmodule
