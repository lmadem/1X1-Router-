//interface with clk as input
interface router_if(input clk);
  
  logic reset;
  logic [7:0] dut_inp;
  logic inp_valid;
  logic [7:0]dut_outp;
  logic outp_valid;
  logic busy;
  logic error;

  //CSR related signals
  logic wr,rd; 
  logic [7:0]  addr;
  logic [31:0] wdata;
  logic [31:0] rdata;
  
  //clocking block
  clocking cb@(posedge clk);
    output dut_inp;//Direction are w.r.t TB
    output inp_valid;
    output wr,rd;
	output addr;
	output wdata;
    input dut_outp;
    input outp_valid;
    input busy;
    input error;
	input rdata;
  endclocking
  
  
  //clocking block for monitors
  clocking mcb@(posedge clk);
    input dut_inp;
    input inp_valid;
    input dut_outp;
    input outp_valid;
	input busy;
    input error;
  endclocking
  
  
  //modport for TB Driver
  modport tb_mod_port (clocking cb , output reset);
    
  //modport for TB Monitors
  modport tb_mon (clocking mcb);

endinterface
