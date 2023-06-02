`timescale 1ns / 1ps
module ClockDivider(input fastClock, output reg slowClock);
    reg [1:0] counter;
    initial begin
        counter = 2'b00;
    end
    always @(posedge fastClock) begin
        if(counter == 2'b11)
            counter = 0;
        else 
            counter = counter + 1;
        slowClock = counter[1];
    end
endmodule