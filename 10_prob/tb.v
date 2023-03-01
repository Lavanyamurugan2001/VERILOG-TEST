module test;


///////////////////////////////////////////////////////////////////
//
// Local IOs and Vars
//

reg		clk;
reg		rd_clk, wr_clk;
reg		rst;

///////////////////////////////////////////////////////////////////
//
// Test Definitions
//


///////////////////////////////////////////////////////////////////
//
// Misc test Development vars
//

integer		n,x,rwd;
reg		we, re;
reg	[7:0]	din;
reg		clr;
wire	[7:0]	dout;
wire		full, empty;
wire		full_r, empty_r;
wire		full_n, empty_n;
wire		full_n_r, empty_n_r;
wire	[1:0]	level;
reg	[7:0]	buffer[0:1024000];
integer		wrp, rdp;

///////////////////////////////////////////////////////////////////
//
// Initial Startup and Simulation Begin
//

real		rcp;

initial
   begin
      $dumpfile("dc.vcd");
      $dumpvars ;
end
initial
begin
	rcp=5;
   	clk = 0;
   	rd_clk = 0;
   	wr_clk = 0;
   	rst = 1;

	we = 0;
	re = 0;
	clr = 0;

	rwd=0;
	wrp=0;
	rdp=0;

   	repeat(5)	@(posedge clk);
   	rst = 0;
   	repeat(5)	@(posedge clk);
   	rst = 1;
   	repeat(5)	@(posedge clk);

	if(1)
	   begin
		//test_sc_fifo;
		test_dc_fifo;
	   end
	else
	   begin

		rwd=4;
		wr_dc(6);
		rd_dc(6);
		
	   end

	repeat(50)	@(posedge clk);

$display("rdp=%0d, wrp=%0d delta=%0d", rdp, wrp, wrp-rdp);

   	$finish;
   end

task test_dc_fifo;
begin


$display("\n\n");
$display("*****************************************************");
$display("*** DC FIFO Sanity Test                           ***");
$display("*****************************************************\n");

for(rwd=0;rwd<3;rwd=rwd+1)	// read write delay
for(rcp=5;rcp<10;rcp=rcp+10.0)
   begin
	$display("rwd=%0d, rcp=%0f",rwd, rcp);

	$display("pass 0 ...");
	for(x=0;x<10;x=x+1)
	   begin
		wr_dc(1);
	   end
	$display("pass 1 ...");
	for(x=0;x<10;x=x+1)
	   begin
		rd_dc(1);
	   end
	$display("pass 2 ...");
	for(x=0;x<10;x=x+1)
	   begin
		wr_dc(1);
	   end
	$display("pass 3 ...");
	for(x=0;x<10;x=x+1)
	   begin
		rd_dc(1);
	   end
   end

$display("");
$display("*****************************************************");
$display("*** DC FIFO Sanity Test DONE                      ***");
$display("*****************************************************\n");
end
endtask

///////////////////////////////////////////////////////////////////
//
// Data tracker
//

always @(posedge clk)
	if(we & !full)
	   begin
		buffer[wrp] = din;
		wrp=wrp+1;
	   end

always @(posedge clk)
	if(re & !empty)
	   begin
		#3;
		if(dout != buffer[rdp])
			$display("ERROR: Data (%0d) mismatch, expected %h got %h (%t)",
			 rdp, buffer[rdp], dout, $time);
		rdp=rdp+1;
	   end

always @(posedge wr_clk)
	if(we & !full)
	   begin
		buffer[wrp] = din;
		wrp=wrp+1;
	   end

always @(posedge rd_clk)
	if(re & !empty)
	   begin
		#3;
		if(dout != buffer[rdp] | ( ^dout )===1'bx)
			$display("ERROR: Data (%0d) mismatch, expected %h got %h (%t)",
			 rdp, buffer[rdp], dout, $time);
		rdp=rdp+1;
	   end

///////////////////////////////////////////////////////////////////
//
// Clock generation
//

always #5 clk = ~clk;
always #10 rd_clk = ~rd_clk;
always #25 wr_clk = ~wr_clk;

generic_fifo_dc #(8,8,9) u1(
		.rd_clk(	rd_clk		),
		.wr_clk(	wr_clk		),
		.rst(		rst		),
		.clr(		clr		),
		.din(		din		),
		.we(		(we & !full)	),
		.dout(		dout		),
		.re(		(re& !empty)	),
		.full(		full	),
		.empty(		empty	),
		.full_n(	full_n	),
		.empty_n(	empty_n	),
		.level(		level	)
		);

///////////////////////////////////////////////////////////////////
//
// Test and test lib 
//


task wr_dc;
input	cnt;
integer	n, cnt;

begin
@(posedge wr_clk);
for(n=0;n<cnt;n=n+1)
   begin
	#1;
	we = 1;
	din = $random;
	@(posedge wr_clk);
	#1;
	we = 0;
	din= 8'hxx;
	repeat(rwd)	@(posedge wr_clk);
   end
end
endtask


task rd_dc;
input	cnt;
integer	n, cnt;
begin
@(posedge rd_clk);
for(n=0;n<cnt;n=n+1)
   begin
	#1;
	re=1;
	@(posedge rd_clk);
	#1;
	re = 0;
	repeat(rwd)	@(posedge rd_clk);
   end
end
endtask
endmodule

