`timescale 1ns/1ps
module test_bench();

wire SDA;
wire SCL;

initial 
begin
    //$dumpfile("testbench.vcd");
    //$dumpfile(1);
    $display("TESTBENCH RUNNING");

dut.write_slave(8'b10101010,8'b11001001,8'b11011011);  
//#100000;

//master_dut.read_slave(8'b11001001);
//#100000; 
    #300000 $finish;
end

master dut(.SDA(SDA),.SCL(SCL));
//slave dut(.SDA(SDA),.SCL(SCL));
endmodule
