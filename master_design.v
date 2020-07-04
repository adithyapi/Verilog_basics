`timescale 1ns/1ps//
module master(SDL,SCL,reset);

//localparam state=0;
input [7:0]data_in;
input [7:0]address_in;
reg oe;
output clk;
input reset;
inout  SDL;//Bidirectional SDA Line
output  SCL;//Bidirectional SCL Line

wire [7:0]data_in;
wire [7:0]address_in;
reg clk;
wire reset;
reg [7:0]data_memory;
reg [7:0]address_memory;
//reg SDL;
reg SCL;
//reg SCL_en=1;
//reg SDA_en=1;
reg SDA_tx;
wire SDA_rx;

integer i,j,k;
reg ADC_read;
reg start;
integer state;

initial 
begin
    $display("MASTER COMMUNICATING");
    //reset=1;
    i=7;
    j=7;
    data_memory=8'b10100000;
    address_memory=8'b10100010;
    clk=0;
    state=0;
    start=0;
    oe=1;
    SCL=1;
    SDA_tx=1;

    //#10000;
    //reset=0;
    //#60000 $finish;
end

assign SDL= oe ? SDA_tx :8'hz;
assign SDA_rx = SDL;

//assign SCL= oe ? SDA_tx : 8'bZ ;

/*specify 
  specparam 
  tsu = 600, thd = 600;
  $setup(SCL, negedge SDL, thd);
  //$hold(posedge Clk, Data, THold);
  //$width(negedge Clk, 10.5, 0.5);

  //assign #(10,40) SCL_in=~SCL_in;
   //$setup(SDL, SCL, 600);
*/

/*
always@(data_in || address_in) begin
    data_memory<=data_in;
    address_memory<=address_in;
    $display("time=%g,data_in=%h, address_in=%h",$time,data_in,address_in);
    //SDL=~SDL;
    //#800;
    //$display("time=%g,data_memory=%h, address_memory=%h",$time,data_memory,address_memory);
end
*/

always@(negedge clk or posedge clk)
begin
    SCL=~SCL;
end

/*
always@(posedge clk)begin
    clk1=1;
    #100 clk1=0;
end
*/
/*
always@(negedge reset) begin
#600;
clk= 1;
    forever begin
clk = 1;
#1300;
clk = 0;
#1200;
    end
end
*/

always@(posedge start) 
begin
    //#600;
    //clk=1;
    //else 
    //begin
        while(start==1)
        begin
        //forever 
        //begin
            clk = 1;
            #1300;
            clk = 0;
            #1200;
        end
end


always@(posedge clk or negedge reset) 
begin

    case(state)
//START CASE
    0:  begin
            SDA_tx<=0;
            $display("START MASTER---state=%g, time=%g",state,$time);
            state<=1;
            #600;
            start<=1;
        end
//---------------
//Address to Slave
//---------------
    1:  begin
            SDA_tx<=address_memory[i];
            if(i==0)
            begin
                $display("Address %g bit sent =%b",i,address_memory[i]);
                $display("Address sent=%b",address_memory);
                state<=2;
            end
            else 
            begin
                $display("Address %g bit sent=%b",i,address_memory[i]);
                i=i-1;
            end
        end
//----------------------
//Address ACK from Slave
//----------------------
    2:  begin
            oe=0;
            ADC_read=SDA_rx;
            state=3;
            $display("ADC=%b state=%g, time=%g  ACK to master, %b",ADC_read,state,$time,SDA_rx);
//Conditions after acknowledgement
        end

//Data to Slave
    3:  begin
            if(j>0)
            begin
                oe=1;
                SDA_tx<=data_memory[j];
                j=j-1;
                $display("data acq---time=%g, %g",$time,j);
            end
            else 
            begin
                $display("state=%g, time=%g",state,$time);
                state<=4;
            end
        end

//Data ACK from Slave
    4:  begin
          
            ADC_read=SDA_rx;
            //$display("%g ACK",ADC_read);
            state<=5;
            $display("state=%g, time=%g,----%b--- ACK data",state,$time,ADC_read);
        end

//STOP CASE
    5:  begin
            #1900;
            SDA_tx=1;
            SCL=1;
            $display("state=%g, time=%g STOP ",state,$time);
            i=7;
            j=7;
            //state<=0;
            start=0;
            #1000;
            state<=0;
            $display("------%g--------",oe);
        end
    endcase
end


/*
always@(negedge SDL) begin
    #600 SCL=~SCL;
    $display("time=%g,SCL=%b",$time,SCL);
end
*/

/*
always@(negedge SCL)begin
    #1300 SCL=0;
    #1200 SCL=1;
end
*/

endmodule

  
