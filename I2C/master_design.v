`timescale 1ns/1ps//
module master(SDL,SCL,reset);

//localparam state=0;
input [7:0]data_in;
input [6:0]address_in;
reg oe;
output clk;
input reset;
inout  SDL;//Bidirectional SDA Line
output  SCL;//Bidirectional SCL Line

wire [7:0]data_in;
wire [6:0]address_in;
reg clk;
wire reset;
reg [7:0]data_memory;
reg [6:0]address_memory;
//reg SDL;
reg SCL;
//reg SCL_en=1;
//reg SDA_en=1;
reg SDA_tx;
wire SDA_rx;

integer i,j,k;
reg ADC_read;
reg ADC_data;
reg start;
integer state;

initial 
begin
    $display("MASTER COMMUNICATING");
    //reset=1;
    i=6;
    j=7;
    data_memory=8'b10101000;
    address_memory=8'b1010001;
    clk=0;
    state=0;
    start=0;
    oe=1;
    SCL=1;
    SDA_tx=1;
    $display("START---oe=%g,start=%g,state=%g,i=%g,j=%g,time=%g",oe,start,state,i,j,$time);
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
//----------------
//Address to Slave
//----------------
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
            if(ADC_read==1)
            begin
            state=3;
            $display("ACK Read=%b state=%g ACK to master time=%g",ADC_read,state,$time);
            end
//Conditions after acknowledgement
        end

//Data to Slave
    3:  begin
            oe=1;
            SDA_tx=data_memory[j];
            if(j==0) 
            begin
                $display("state=%g, time=%g",state,$time);
                state<=4;
            end
            else
            begin
                $display("Data %g bit sent=%b",j,data_memory[j]);
                j=j-1;
            end
        end

//Data ACK from Slave
    4:  begin
            oe=0;
            //ADC_data=SDA_rx;
            $display("ACK data from slave %g",$time);
            /* 
            if(ADC_data==1)
            begin
                $display("ACK Data Master %g",ADC_data);
                state=5;
                $display("state=%g, time=%g,----%b--- ACK data",state,$time,ADC_data);
            end
            */
        end

//STOP CASE
    5:  begin
            oe=1;
            SDA_tx=0;
            $display("adi &g",$time);
            #1900;
            SDA_tx=1;
            SCL=1;
            $display("state=%g, time=%g STOP ",state,$time);
            i=6;
            j=7;
            //state<=0;
            start=0;
            #1000;
            state=0;
            $display("STOP---oe=%g,start=%g,state=%g,i=%g,j=%g,time=%g",oe,start,state,i,j,$time);
        end
    endcase
end


always@(posedge SCL)
begin
    if(state==4)
    begin
            ADC_data=SDA_rx;
            if(ADC_data==1)
            begin
                $display("ACK Data Master %g, %g",ADC_data,$time);
                state=5;
                $display("state=%g, time=%g",state,$time);
            end
    end
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

  