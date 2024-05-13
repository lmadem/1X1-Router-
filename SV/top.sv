module top;

//Variables for Port Connections Of DUT and TB.
logic clk;
  
//Clock initiliazation and Generation
initial clk=0;
always #5 clk=!clk;

//Instantiate interface
router_if router_if_inst(clk);

//DUT instantiation
router_dut dut_inst(.clk(clk),
.reset(router_if_inst.reset),
.dut_inp(router_if_inst.dut_inp),
.inp_valid(router_if_inst.inp_valid),
.dut_outp(router_if_inst.dut_outp),
.outp_valid(router_if_inst.outp_valid),
.busy(router_if_inst.busy),
.error(router_if_inst.error),
.wr(router_if_inst.wr),
.rd(router_if_inst.rd),
.addr(router_if_inst.addr),
.wdata(router_if_inst.wdata),
.rdata(router_if_inst.rdata)
);

//Program Block (TB) instantiation
testbench  tb_inst(.vif(router_if_inst));

 
//Dumping Waveform
initial begin
  $dumpfile("dump.vcd");
  $dumpvars(0,top.dut_inst); 
end

endmodule
