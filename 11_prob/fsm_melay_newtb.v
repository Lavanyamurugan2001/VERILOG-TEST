module seq;
reg din;
reg clk;
reg rst;
wire dout;
seq_001001 uut(din,clk,rst,dout);
initial
begin
$dumpfile("new.vcd");
$dumpvars;
end
initial
begin
  clk =0;
  forever #5clk=~clk;
end
initial
 begin
  rst=1;
din =0;
#10 rst=0;
#10 din =0;
#10 din =0;
#10 din =1;
#10 din =0;
#10 din =0;
#10 din =1;
/*#10 din =1;
#10 din =1;
#10 din =1;
#10 din =1;
#10 din =1;
#10 din =1;*/


 #100 $finish;
end
always @(posedge clk)
begin 
$display("din=%d dout=%d",din,dout);
end
endmodule

