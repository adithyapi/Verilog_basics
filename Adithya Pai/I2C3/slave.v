`timescale 1ns/1ps
module slave(inout SDL, input SCL);

reg [7:0]slave_memory[127:0];
reg [6:0]address;
reg [7:0]data_memory;
reg [7:0]read_memory;
reg oe;
reg RW;
reg NACK;
reg reset;
reg data_txtb;
wire data_rx;
reg test;
reg [7:0]write_display;

integer start;
integer state;
reg stop;
localparam idle_state=0;
localparam address_state=1;
localparam ACK_state=2;
localparam data_state=3;
localparam NACK_state=4;

integer addr_count;
integer data_count;
integer read_count;
integer pratham;
//wire SCL;

//-------------------
initial 
begin

    state=0;
    start=0;
    oe=1;
    test=1;
    $display("SLAVE COMMUNICATING");

 /*  
#21600;
    oe=0;
    data_txtb=1;
  
#2500;
	oe=1;
	#20000;

	$display("DATA time=%g",$time);
	oe=0;
	data_txtb=1;
#2500;
oe=0;
*/
#200000;

   $finish;

end


//-------------------
assign SDL = (oe) ? 1'bz : data_txtb;
assign data_rx = SDL;
//-------------------

always@(negedge SDL)
begin
    if((SDL==0)&&(SCL==1)&&(test<=2))
    begin
        //test=0;
        start<=1;
        state=address_state;
        $display("START SLAVE---state=%g, time=%g",state,$time);
        addr_count=7;
        data_count=7;
	read_count=7;
	test=test+1;
        $display("Address Count=%g",addr_count);
    end
end


//-------------------
/////Slave FSM///////
//------------------
always@(negedge SCL) 
begin
    if (start==1)
    begin
        case(state)
    //----------------
    //Address to Slave
    //----------------
        1:  begin
		@(posedge SCL);
                address[addr_count]=data_rx;
                if(addr_count==0)
                begin
                    $display("Address %g bit recieved=%b time=%g",addr_count,address[addr_count],$time);
                    $display("Address Recieved=%b",address);
                    state<=ACK_state;  
                end
                else
                begin
                    $display("Address %g bit recieved=%b time=%g",addr_count,address[addr_count],$time);
                    $display("Address data=%b",address);
                    addr_count=addr_count-1;
                end
          end
	
	//----------------
    //ACK to Master
    //----------------
        2:  begin
                oe=0;
                data_txtb=0;
                $display("ACK data=%g time=%g",data_txtb,$time);
                state=data_state;
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
			@(posedge SCL); 
                        data_memory[data_count]=data_rx;
                        slave_memory[address]=data_memory;
			$display("tx_tb=%b time=%g",data_rx,$time);
                        if(data_count==0)
                            state<=NACK_state;
                        else
                            data_count=data_count-1;
                	end
               /*
                else if(RW==0)
                begin
                        oe=0;//Direction
			@(posedge SCL);
                        data_txtb=data_memory[read_count];
                        if(read_count==0)
                        begin
                            oe=0;//Direction
                            state<=NACK_state;
                        end
                        else
                            read_count=read_count-1;
                            
            	end
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
                    $display(" ACK Data=%g , time=%g",data_txtb,$time); 
                    state=5;
                end
end

5: begin
                oe=1;
               // $display("SLAVE state 5 %g",$time);
		$display("DATA memory %b",data_memory);
                stop=1;
            end

endcase



end
end
endmodule   
