//`include "design.v"
//`include "slave.v"
//`include "top_module_tb.v"
`timescale 1ns/1ps

module top_module();

//input reset;
//inout SDL;
//output SCL;
wire SCL,SDL;

master dut(.SDL(SDL),.SCL(SCL));
slave uut(.SDL(SDL),.SCL(SCL));

//top_module_tb AUT(.SDL(SDL),.SCL(SCL));

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
