//melay 001001 nonoverlap
module seq_001001(input din,clk,rst,output reg dout);
parameter S0 =0,S1=1,S2=2,S3=3,S4=4,S5=5,S6=6;
reg [2:0] state,nextstate;
always @(*)
begin
case(state)
 S0: nextstate = din ? S1:S0;
 S1: nextstate = din ? S2:S0;
 S2: nextstate = din ? S3:S1;
 S3: nextstate = din ? S4:S0;
 S4: nextstate = din ? S5:S0;
 S5: nextstate = din ? S0:S1;
default :nextstate =S0;
endcase
end
always@(posedge clk)
begin
 if(rst)
    state<=2'b00;
    else state<= nextstate;
end
always @(posedge clk)
begin
  if(rst)
   dout<=1'b0;
  else begin
   if(din&(state == S5))
     dout<=1'b1;
   else
     dout<= 1'b0;
end
end
endmodule
  
