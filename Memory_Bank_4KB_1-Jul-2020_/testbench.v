
module memory_bank_tb();

integer SIM_LENGTH=5;//Nano Seconds

reg [7:0]din;
wire [7:0]dout;
wire [7:0]out;
reg [11:0]address;
reg CEB,RE,WR,clk,RESET;
reg [7:0]write_display;
reg [1:0]bank_sel;

initial 
begin
  $dumpfile("Memory.vcd");
  $dumpvars(1);
   DUT.VDD=1.8;
   DUT.VSS=0;
//----------------------------------------
//////Individual bank can write///////////
//----------------------------------------
    clk=1;
    CEB=1'b0;
    RESET=1'b0;
    RE=1'b0;
    WR=1'b1;
    address=12'h1F4;
    din=8'hA;
    #750;
    address=12'h4B0;
    din=8'hB;
    #750;
    address=12'hA8C;
    din=8'hC;
    #750;
    address=12'hDAC;
    din=8'hD;
    #800;
    WR=1'b0;
    #500;
//-------------------------------
////////Individual bank read/////
//-------------------------------
 	RE=1'b1;
    address=12'h1F4;
    #1500;
    address=12'h4B0;
    #1500;
    address=12'hA8C;
  	#1500;
  	address=12'hDAC;
    #3000;
    RE=1'b0;
    #1750;
//-----------------------------------------------------------
////Simultaneous read and write of multiple banks case 1/////
//-----------------------------------------------------------
  	RE=1'b1;
    address=12'h1F4;
    #1000;
    RE=1'b0;
  	#500;
   	WR=1'b1;
   	address=12'h4B0;
    din=8'he;
  	#1000;
  	WR=1'b0;
  	#500;
  	RE=1'b1;
  	address=12'hA8C;
    #1000;
  	RE=1'b0;
  	#1000;
  	WR=1'b1;
   	address=12'h1F4;
    din=8'hd;
  	#1000;
  	WR=1'b0;
  	#1000;
  	RE=1'b1;
  	address=12'hDAC;
  	#1000;
  	RE=1'b0;
  	#1000;
  	WR=1'b1;
   	address=12'hA8C;
    din=8'hF;
  	#1000;
  	WR=1'b0;
  	#2000;
//--------------------------------------------------
/////////continuous read and write of same bank//////
//--------------------------------------------------  
   	WR=1'b1;     ////Bank 1
   	address=12'h12C;
    din=8'ha;
  	#1000;
  	WR=1'b0;
  	RE=1'b1;
  	address=12'h12C;
    #2000;
  	RE=1'b0;
  	WR=1'b1;
   	address=12'h1f4;
    din=8'hb;
  	#1000;
  	WR=1'b0;
  	RE=1'b1;
  	address=12'h1f4;
 	#2000;
  	RE=1'b0;
  	WR=1'b1;
   	address=12'h258;
    din=8'hc;
  	#1000;
  	WR=1'b0;
  	RE=1'b1;
  	address=12'h258;
  	#1000;
  	RE=1'b0;
  	#4000;
 
  	WR=1'b1;     ////Bank 2
   	address=12'h460;
    din=8'ha;
  	#1000;
  	WR=1'b0;
  	RE=1'b1;
  	address=12'h460;
    #2000;
  	RE=1'b0;
  	WR=1'b1;
   	address=12'h578;
    din=8'hb;
  	#1000;
  	WR=1'b0;
  	RE=1'b1;
  	address=12'h578;
 	#2000;
  	RE=1'b0;
  	WR=1'b1;
   	address=12'h640;
    din=8'hc;
  	#1000;
  	WR=1'b0;
  	RE=1'b1;
  	address=12'h640;
  	#1000;
  	RE=1'b0;
  	#4000;
 
    WR=1'b1;     ////Bank 3
   	address=12'h898;
    din=8'ha;
  	#1000;
  	WR=1'b0;
  	RE=1'b1;
  	address=12'h898;
    #2000;
  	RE=1'b0;
  	WR=1'b1;
   	address=12'h960;
    din=8'hb;
  	#1000;
  	WR=1'b0;
  	RE=1'b1;
  	address=12'h960;
 	#2000;
  	RE=1'b0;
  	WR=1'b1;
   	address=12'hA28;
    din=8'hc;
  	#1000;
  	WR=1'b0;
  	RE=1'b1;
  	address=12'hA28;
  	#1000;
  	RE=1'b0;
  	#4000;
  
 	WR=1'b1;     ////Bank 4
   	address=12'hC80;
    din=8'ha;
  	#1000;
  	WR=1'b0;
  	RE=1'b1;
  	address=12'hC80;
    #2000;
  	RE=1'b0;
  	WR=1'b1;
   	address=12'hD48;
    din=8'hb;
  	#1000;
  	WR=1'b0;
  	RE=1'b1;
  	address=12'hD48;
 	#2000;
  	RE=1'b0;
  	WR=1'b1;
   	address=12'hDAC;
    din=8'hc;
  	#1000;
  	WR=1'b0;
  	RE=1'b1;
  	address=12'hDAC;
  	#1000;
  	RE=1'b0;
  	#4000;
//-------------------------------------------------------
/*Read is high and accessing some register for ex[1F4] after 1 clock cycle  with Read signal still high make Write signal high and accessing the same address 1F4 and writing some other data
*/
//-------------------------------------------------------
  	RE=1'b1;
  	address=12'hC80;
  	#1000;
  	WR=1'b1;
  	din=8'h88;
  	#2000;
  	WR=1'b0;
    RE=1'b0;
  	#1000;
  	RE=1'b1;
  	address=12'hA28;
  	#1000;
  	WR=1'b1;
  	din=8'h77;
  	#2000;
  	WR=1'b0;
    RE=1'b0;
  	#1000;
  	RE=1'b1;
  	address=12'h640;
    #1000;
  	WR=1'b1;
  	din=8'h99;
  	#2000;
  	WR=1'b0;
    RE=1'b0;
    #1000;
  	RE=1'b1;
  	address=12'h1F4;
  	#1000;
  	WR=1'b1;
  	din=8'h150;
  	#4000;

////Read Write Enable Memory Corrupt////
  	WR=1'b0;
  	RE=1'b0;
  	#1000;
  	RE=1'b1;
  	WR=1'b1;
  	#3000;
  	RE=1'b0;
  	WR=1'b0;
  	#2000;
  	RE=1'b1;
  	address=12'hC80;
  	#4000;
  	RE=1'b0;
  	WR=1'b0;
  	#1000;
  	RE=1'b1;
  	WR=1'b1;
  	#2000;
 
  
  
  
    #SIM_LENGTH $finish;
end
   
always  #500 clk=~clk;
memory_bank DUT(din,address,clk,dout,WR,RE,CEB,RESET);
  
endmodule 
