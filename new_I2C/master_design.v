`timescale 1ns/1ps
module master(inout SDA, output reg SCL);

integer start;

reg SDA_tx;
wire SDA_rx;
reg ACK_device;
reg clk;
reg enable;
reg [7:0] device_address;
reg [7:0] mem_address;
reg [7:0] slave_data;


integer i,j,k;

initial
begin
	enable=0;
    $display("Master Communicating");
end


assign SDA = enable ? SDA_tx : 1'hz;
assign SDA_rx = SDA;
pullup (SDA);

//---------------
//Clock Generation
//--------------

always@(posedge start) 
begin
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


//--------------
//SCL Generation
//---------------
always@(negedge clk or posedge clk)
begin
    SCL=~SCL;
end

//---------------
//Write Task
//-------------
task write_slave(input [7:0] slave_device,  input [7:0] slave_address, input [7:0]data);
begin
	device_address=slave_device;
	mem_address=slave_address;
	slave_data=data;
    
	start_i2c;
    	slave_device_i2c;
      //slave_address_i2c();
      //write_data_i2c();
      //stop_i2c();
end
endtask


task start_i2c;
begin
    SDA_tx=0;
    $display("START MASTER, time=%g",$time);
    //state<=1;
    #600;
    start<=1;
end
endtask

task slave_device_i2c;
begin
$display("//////////////////////////////////////");
$display("******Slave device address sending******");
$display("//////////////////////////////////////");
$display("Slave device address=%b",device_address);

for(k=7;k>=-1;k=k-1)
    begin
    	@(posedge clk);
        	$display("Device Address %g bit %g",k,$time);
        	SDA_tx=device_address[k];
            	$display("Device Address %g bit sent=%b,%g",k,device_address[k],$time);
            //i=i-1;
            if(k==-1)
            begin
                enable=0;
                @(negedge clk);
                ACK_device=SDA_rx;
                $display("ACK Recieved=%b",ACK_device,$time);
                if(ACK_device==1'b1)
                begin
                    $display("*******ACK Recieved********");
                end	
            end       
    end

end
endtask
endmodule
