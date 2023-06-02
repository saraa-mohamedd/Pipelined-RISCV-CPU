module BCD (

input [12:0] num,
output reg [3:0] Thousands,
output reg [3:0] Hundreds,
output reg [3:0] Tens,
output reg [3:0] Ones
);

integer i;
always @(num)
begin
    //initialization
     Thousands = 4'd0;
     Hundreds = 4'd0;
     Tens = 4'd0;
     Ones = 4'd0;
    for (i = 12; i >= 0 ; i = i-1 )
    begin
        if(Thousands >= 5 )
            Thousands  = Thousands  + 3;
        if(Hundreds >= 5 )
            Hundreds = Hundreds + 3;
        if (Tens >= 5 )
             Tens = Tens + 3;
            if (Ones >= 5)
             Ones = Ones +3;
             //shift left one
             Thousands = Thousands << 1;
             Thousands [0] = Hundreds[3];
             Hundreds = Hundreds << 1;
             Hundreds [0] = Tens [3];
             Tens = Tens << 1;
             Tens [0] = Ones[3];
             Ones = Ones << 1;
             Ones[0] = num[i];
    end
end
endmodule