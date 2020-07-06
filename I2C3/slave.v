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
wire SCL;

//-------------------
initial 
begin
    state=0;
    start=0;
    oe=1;
    test=1;
    $display("SLAVE COMMUNICATING");
    #21600;
    oe=0;
    data_txtb=1;
    #2000;
    $finish;
end


//-------------------
assign SDL = (oe) ? 8'bz : data_txtb;





endmodule   