module FIFObuffertb;
reg Clk;
reg [31:0]dataIn;
reg RD,WR,EN,Rst;
wire EMPTY,FULL;
wire [31:0]dataOut;

 // Instantiate the Unit Under Test (UUT)

 FIFObuffer uut (

                  .Clk(Clk), 

                  .dataIn(dataIn), 

                  .RD(RD), 

                  .WR(WR), 

                  .EN(EN), 

                  .dataOut(dataOut), 

                  .Rst(Rst), 

                  .EMPTY(EMPTY), 

                  .FULL(FULL)

                  );
initial
begin
 $dumpfile("fifo.vcd");
$dumpvars;
end
initial
begin
 Clk=0;
 forever #5Clk=~Clk;
end
 initial begin

  // Initialize Inputs

  Clk  = 1'b0;

  dataIn  = 32'h0;

  RD  = 1'b0;

  WR  = 1'b0;

  EN  = 1'b0;

  Rst  = 1'b1;

  // Wait 100 ns for global reset to finish

  #100;        

  // Add stimulus here

  EN  = 1'b1;

  Rst  = 1'b1;

  #20;

  Rst  = 1'b0;

  WR  = 1'b1;

  dataIn  = 32'h0;

  #20;

  dataIn  = 32'h1;

  #20;

  dataIn  = 32'h2;

  #20;

  dataIn  = 32'h3;

  #20;

  dataIn  = 32'h4;

  #20;

  WR = 1'b0;

  RD = 1'b1;  
#100 $finish;

 end 

always @(posedge Clk)
begin
$display("dataIn=%d dataOut =%d ",dataIn,dataOut);
end
endmodule

