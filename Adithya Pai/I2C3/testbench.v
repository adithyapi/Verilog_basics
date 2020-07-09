//`include "design.v"
//`include "slave.v"

module test_bench();

wire SDL;
wire SCL;

initial 
begin
    $dumpfile("master_tb.vcd");
    $dumpfile(1);
    $display("TESTBENCH RUNNING");

//dut.write_slave(8'b11001001,8'b11011011);  
//#100000;
/*
master_dut.read_slave(8'b11001001);
#100000;
*/
//aut.write_slave(8'b11001001,8'b11011011); 
    #300000 $finish;
end

master aut(.SDL(SDL),.SCL(SCL));
//slave dut(.SDL(SDL),.SCL(SCL));
endmodule
