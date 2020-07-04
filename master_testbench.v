module master_tb();

//reg SDL;
//wire SCL;
wire SCL_in;
reg [7:0]data_in;
reg [7:0]address_in;
wire clk;
reg reset;
reg oe;
wire SDL;
reg data;

//-------------------------
wire    data_rx;
wire    data_io;
reg     data_tri;
reg     data_tx;
reg     data_txtb;
//--------------------------

//assign SDL = data;
//-----------------------
assign SDL = (oe) ? 8'bz : data_txtb;
//assign data_io = (data_tri) ? data_txtb : 1'bZ;
initial begin
    $dumpfile("master.vcd");
    $dumpvars(1);
    //data_in=8'h1;
    //address_in=8'h5;
    oe=1;
    //data=1;
    reset=1;
    #10000
    reset=0;
    #21400;
    oe=0;
    data_txtb=1;
    //SDA_rx=1;
    #1500;
    data_txtb=0;
    oe=1;
    //SDL=1;
    
    /*oe=0;
    data=1;
    #1000;
    data=1;
    oe=1;
    */
   #60000 $finish; 
end

/*
always begin 
clk = 0;
#1200;
clk = 1;
#1300;
  end 
  */

master DUT (SDL,SCL,reset);
endmodule