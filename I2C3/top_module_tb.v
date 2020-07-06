`timescale 1ns/1ps
module top_module_tb;

reg reset;
wire SDL,SCL;

master dut(.SDL(SDL), .SCL(SCL));
slave uut(.SDL(SDL),.SCL(SCL));


initial
begin
    $dumpfile("top.vcd");
    $dumpvars(1);
    $display("TESTBENCH");
    $display("%d", uut.oe);
    #100000;
    $finish;
end
endmodule