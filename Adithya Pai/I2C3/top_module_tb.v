//`include "design.v"
//`include "slave.v"


`timescale 1ns/1ps

module top_module_tb;


//reg reset;
wire SDL,SCL;

master dut(.SDL(SDL), .SCL(SCL));
slave uut(.SDL(SDL),.SCL(SCL));

//dut.write_slave(8'b11001001,8'b11011011); 
//dut.write_task(address,data);

initial
begin

    //$dumpfile("top.vcd");
    //$dumpvars(1);
    $display("TESTBENCH");
    $display("%d", uut.oe);
	//dut.write_slave(8'b11001001,8'b11011011); 
    #150000;
    $finish;
end

endmodule
