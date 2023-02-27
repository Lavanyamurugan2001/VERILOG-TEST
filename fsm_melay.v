module melay(clk,rst,din,dout);
input rst;
input clk; 
input din;
output reg dout;
parameter S0=000;
parameter S1=001;
parameter S2=010;
parameter S3=011;
parameter S4=100;
parameter S5=101;
parameter S6=110;
parameter S7=111;
reg [2:0] state;
always @ (posedge clk or posedge rst)
begin
if(rst)
	begin
        dout<=1'b0;
        state<= S0;
end
else begin
   case(state)
   S0:
begin
    if(~din)
     	begin
		state<= S1;
		dout<= 1'b0;
        end
    else
    begin
                state<=S0;
	        dout<=1'b0;
    end
end
S1:
begin
    if(~din)
        begin 
		state<= S2;
		dout<= 1'b0;
        end
    else
    begin
		state<=S0;
		dout<=1'b0;
    end
end
S2: 
begin
    if (din)
       begin
 		state<=S3;
		dout<= 1'b0;
       end
    else
	begin
		state<=S1;
		dout<= 1'b0;
        end
end
S3: 
begin
    if(~din)
      begin
                state<= S4;
		dout<= 1'b0;
      end
    else    
	begin    
		state<=S0;
		dout<= 1'b0;
        end
end
S4: 
begin
    if(~din)
      begin
   		state <= S5;
                dout <= 1'b0;
      end
    else
    begin
		state<=S0;
                dout<= 1'b0;
    end
end
 S5: 
begin
     if (din)
	begin
             state<= S0;
             dout<=1'b1;
        end
     else
    begin
	     state<=S1;
             dout<= 1'b0;
    end
end
endcase
end
end
endmodule

   

 


