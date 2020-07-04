`timescale 1ns/1ps

module slave(inout SDL, input SCL);

reg [7:0] slave_memory[127:0];
reg [7:0]address;
reg [7:0]data_memory;
reg [7:0]read_memory;
reg oe;
reg RW;
reg NACK;
reg reset;
reg data_txtb;


reg start;
reg state;
reg stop;
localparam idle_state=0;
localparam address_state=1;
localparam ACK_state=2;
localparam data_state=3;
localparam NACK_state=4;

integer addr_count;
integer data_count;
integer read_count;

wire SCL;

//-------------------
initial 
begin
    state=0;
    start=0;
    oe=1;
    $display("SLAVE COMMUNICATING");
    
end


//-------------------
assign SDL = (oe) ? 8'bz : data_txtb;


//-------------------

always@(negedge SDL)
begin
    if((SDL==0)&&(SCL==1))
    begin
        start<=1;
        state<=address_state;
        $display("START SLAVE---state=%g, time=%g",state,$time);
        addr_count=7;
        data_count=7;
        $display("Address Count=%g",addr_count);
    end
end

//-------------------
/////Slave FSM///////
//-------------------


always@(posedge SCL) 
begin
    if (start==1)
    begin
        case(state)
    //----------------
    //Address to Slave
    //----------------
        1:  begin
                address[addr_count]=SDL;
                if(addr_count==0)
                begin
                    $display("Address %g bit recieved=%b",addr_count,address[addr_count]);
                    $display("Address Recieved=%b",address);
                    state<=ACK_state;  
                end
                else
                begin
                    $display("Address %g bit recieved=%b",addr_count,address[addr_count]);
                    $display("Address data=%b",address);
                    addr_count=addr_count-1;
                end
            end

    //----------------
    //ACK to Master
    //----------------
        2:  begin
                oe=0;
                data_txtb=1;
                $display("ACK data=%g",data_txtb);
                state<=data_state;
            end
    //----------------
    //Write-Read to-from Slave
    //----------------    
        3:  begin
                
                RW=address[0];
                read_memory=slave_memory[address];
                if(RW==1)
                begin
                        oe=1;
                        data_memory[data_count]<=data_txtb;
                        slave_memory[address]=data_memory;
                        if(data_count==0)
                            state<=NACK_state;
                        else
                            data_count=data_count-1;
                end
                /*
                else if(RW==0)
                begin
                        enable=1;//Direction
                        SDL=read_memory[read_count];
                        if(read_count==0)
                        begin
                            enable=0;//Direction
                            state<=NACK_state;
                        end
                        else
                            read_count=read_count-1;
                            */
            end
//------------------
//NACK to master
//-------------------

        4:  begin
                RW=address[0];
                if(RW==1)
                begin
                    oe=0;
                    data_txtb=1;
                end
                /*
                else 
                begin
                NACK=SDL;//NACK in reading  or ACK in writing
                    if(NACK==1)
                    begin
                    ////
                        state<=stop_state;
                    end
                end
                */

            end
       
        5: begin
                oe=1;
                stop<=1;
            end
        endcase
    end
end

always@(posedge SCL)
begin
    if((SDL==0)&&(stop==1))
    begin
        start<=0;
        state<=idle_state;
    end
end


endmodule   