`include "master_design.v"
`include "slave_design.v"
module top_module(reset);

input reset;
//inout SDL;
//output SCL;
wire SCL,SDL;

master dut(.SDL(SDL), .SCL(SCL), .reset(reset));
slave uut(.SDL(SDL),.SCL(SCL));

endmodule

/*
top_module

       ----------           -----------
       |   M    |           |    S    |          
       |     SDA|-----------|SDA      |
       |     SCL|-----------|SCL      |
       |        |           |         |
       |        |           |         |
       ----------           -----------

*/