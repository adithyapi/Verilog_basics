module test_bench();

wire SDL;
wire SCL;

initial 
begin
    $dumpfile("master_tb.vcd");
    $dumpfile(1);
    $display("TESTBENCH RUNNING");
/*
master_dut.write_slave(8'b11001001,8'b11011011);  
#100000;
master_dut.read_slave(8'b11001001);
#100000;
*/
    #200000 $finish;
end

//master dut(.SDL(SDL),.SCL(SCL));
//slave dut(.SDL(SDL),.SCL(SCL));
endmodule