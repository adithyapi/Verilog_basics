module master(SDL,SCL);

inout  SDL;//Bidirectional SDA Line
output  SCL;//Bidirectional SCL Line

reg [7:0]data_memory;
reg [7:0]address_memory;

reg SCL;
reg oe;
//reg SCL_en=1;
//reg SDA_en=1;
reg SDA_tx;
reg clk;
wire SDA_rx;
integer i,j,k;
reg ADC_read;
reg ADC_data;
reg start;
integer state;

//`include "write_slave.v";

initial 
begin
    $display("MASTER COMMUNICATING");
    //reset=1;
    i=7;
    j=7;
    //data_memory=8'b10101000;
    //address_memory=8'b1010001;
    clk=0;
    state=0;
    start=0;
    oe=1;
    SCL=1;
    SDA_tx=1;
    #1000;
    //start=1;
    write_slave(8'b10101000,8'b10101010);
    #100000;
    $display("START---oe=%g,start=%g,state=%g,i=%g,j=%g,time=%g",oe,start,state,i,j,$time);
end

assign SDL= oe ? SDA_tx :8'hz;
assign SDA_rx = SDL;

always@(negedge clk or posedge clk)
begin
    SCL=~SCL;
end


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

/*
always@(*)
begin
    //start_task();
    $display("******START******");
    //write_slave();
    //write_task(8'hB);
    //write_task(8'hA1);
    //stop_task();
end
*/

task write_slave(input [7:0]address, input [7:0]data);
begin
        /*
        
        $display ("%g Write task with address : %h Data : %h",$time, address,data);
        SDA_tx=address[i];
        if(i==0)
        begin
            $display("Address %g bit sent =%b",i,address[i]);
            $display("Address sent=%b",address);
            //state<=2;
        end
        else 
        begin
            $display("Address %g bit sent=%b",i,address[i]);
            i=i-1;
        end
*/
        SDA_tx=0;
        $display("START MASTER---state=%g, time=%g",state,$time);
        state<=1;
        #600;
        start<=1;        

    for(i=7;i>=-1;i=i-1)
    begin
    @(posedge clk);
            $display("Address %g bit %g",i,$time);
            SDA_tx=address[i];
            $display("Address %g bit sent=%b,%g",i,address[i],$time);
            //i=i-1;
            if(i==-1)
            begin
                oe=0;
                @(negedge clk);
                ADC_read=SDA_rx;
                $display("ACK Recieved=%b",ADC_read,$time);
                if(ADC_read==1)
                begin
                    $display("ACK Recieved");
                end
            end
        end




end
endtask

/*

Write_slave_task()
begin
    start_task()
    address_send_task()
    ack_read_task()
    data_slave_task()
    ack_read_task()
    stop_task()
end


Read_slave_task()
begin
    start_task()
    address_send_task()
    ack_send_task()
    data_master_task()
    ack_send_task()
    stop_task()
end
*/

endmodule