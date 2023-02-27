module melaytb;
reg rst;
reg clk;
reg din;
wire dout;
melay uut (clk,rst,din,dout);
initial
begin
$dumpfile("melay.vcd");
$dumpvars(0,melaytb);
end
initial
begin
   clk=0;
   rst=0;
   din=0;
#5 din = 1'b0;
#5 din = 1'b0;
#5 din = 1'b1;
#5 din = 1'b0;
#5 din = 1'b0;
#5 din = 1'b1;
#200 $finish;
end
always #5 clk=~clk;
endmodule

