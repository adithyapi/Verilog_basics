/*-----------------------------------------------------
  File Name : design.v (Memory_bank_4KB)
  Function : Memory bank of 4KB each bank containing 1KB 
  Language: Verilog 
*/-----------------------------------------------------

/*
 0000-3FF  Bank 0
 400-800   Bank 1
 801-C00   Bank 2
 C01-1000  Bank 3
*/

`timescale 1ns/1ps//Change the time scale

module memory_bank(din,address,clk,dout,WR,RE,CEB,RESET);

//---------------------------
  ///Input Ports/////////
  //------------------------
input [11:0]address;//Address bits
input [7:0]din;//Input bits
input RESET,CEB,RE,WR,clk;//Chip Enable, Read Enable, Write Enable, Clock
  
  
wire [7:0]din;//Input bits
wire [11:0]address;
wire RESET,CEB,RE,WR,clk;

  //---------------------
  ///////Output Ports////
  //---------------------
output [7:0]dout;//Output bits

reg [7:0]dout;//Output bits
reg [7:0]out;
reg [7:0] memory1[4095:0];//Memory register
reg [7:0] memory[3:0][1024:0];


integer i,j,k,add_sec;
reg [11:0]read_latch;//Read Latch address Register
reg [11:0]write_latch;//Write Latch address Register
reg [7:0]write_latch_data;//Write Latch data Register
real VDD,VSS;//Power variables
reg [1:0]bank_sel;
reg [9:0]bank_reg;
reg [7:0]write_display;
reg corrupt; 

initial 
begin
   i=0;// Loop variables
   j=0;
end

  //-------------------------
///////Write Task////////////
  //-------------------------

task memory_write(input [11:0]add ,input Write_Enable,Read_Enable,input [7:0] data_in,output [7:0]data_out);
begin
    bank_sel=add[11:10];//Bank Select
    bank_reg=add[9:0];// Bank address select
    memory[bank_sel][bank_reg]=data_in;
    write_display=memory[bank_sel][bank_reg];
    //memory[add] = data_in;
    $display("Bank Selected= %h",bank_sel);
    $display("Data written= %d",write_display);
    $display("Writing in---address=%d,din=%d,time=%g",add,data_in,$time);
end
endtask

  //------------------------
//////Read Task/////////////
  //------------------------

task memory_read(input [11:0]add ,input Write_Enable,Read_Enable,input [7:0] data_in,output [7:0]data_out);
begin
  	bank_sel=add[11:10];//Bank Select
    bank_reg=add[9:0];// Bank address Select
    data_out=memory[bank_sel][bank_reg];
    //data_out = memory[add];  //Indivisual clock cycles
    $display("Reading from---address=%d,dout=%d,time=%g",add,data_out,$time);
end
endtask

  //--------------------------
/////////Power Down////////////
  //--------------------------
always@(*) 
begin
    if((VDD-VSS)<=1.79) //VDD VSS Check for below 1.8V
    begin
	    $display("INFO: Power Insufficient---Underthreshold= %gV",VDD);
        dout=8'bx;
    end
end

 //--------------------
///////Reset///////////
  //------------------
always@(posedge clk && (VDD-VSS)>=1.79) 
begin
    if(RESET)
    begin
        for(i=0;i<4;i=i+1) //Bank selection for loop
        begin
	        for(j=0;j<1024;j=j+1)// Bank address selection for loop
            begin
	            memory[i][j]=1'b0;
                dout=memory[i][j];// Clear all memory to 0
            end
        end
    end
end

  //-------------------------------
/////Read-Write to memory///////////
  //-------------------------------
always@(posedge clk && (VDD-VSS)>1.79) 
begin
  if (WR==1 && RE==0)
    begin
        write_latch=address;//Latches write address in 1st cycle
        write_latch_data=din;//Latches write data in 1st cycle
        $display("INFO:Write latch address=%h",write_latch);
        @(posedge clk);//Second edge check
        memory_write(write_latch,WR,RE,write_latch_data,dout);//Map to write task
    end
  else if (RE==1 && WR==0) 
    begin
        read_latch=address;//Latches read address in 1st cycle
        $display("INFO: Reading 1-clk");
        @(posedge clk);//Second cycle check
            $display("INFO: Reading 2-clk");
        @(posedge clk);
            $display("INFO:Read latch address=%h",read_latch);
        memory_read(read_latch,WR,RE,din,dout);//Map to read task
    end
end

  //----------------------------------------
/////Read Write Enable Memory Corrupt////////
  //-----------------------------------------
  always@(posedge RE)
    begin
      #0.1;    //Delay for Write signal to change
      corrupt=WR;//Write Enable signal check
      if(corrupt>0)
        begin
      		dout<=8'hx; //Corrupt or display dout as unknown
          	$display("INFO: CORRUPT DUE TO READ and WRITE ENABLE IS HIGH--%d",corrupt);
          	corrupt=0; //Reset the value for next read write enable check
		end
    end
 
//---------------------------- 
///////Low Chip Enable////////
//----------------------------
always@(posedge CEB && (VDD-VSS)>1.79)
begin
    bank_sel=address[11:10];   // Bank Select
    bank_reg=address[9:0];      //Bank Address
    memory[bank_sel][bank_reg]=8'hx;// Corrupt the selected address
    $display("INFO: CORRUPT---address=%h,memory=%d",address,memory[bank_sel][bank_reg]);
end


endmodule

        
