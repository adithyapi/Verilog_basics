module top_module_tb;

reg reset;
wire SDL,SCL;

master dut(.SDL(SDL), .SCL(SCL), .reset(reset));
slave uut(.SDL(SDL),.SCL(SCL));


initial
begin
    $dumpfile("top.vcd");
    $dumpvars(1);
    $display("TESTBENCH");
    reset=1;
    #10000;
    reset=0;
    #60000;
    reset=1;
    #1000;
end
endmodule