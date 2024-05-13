// base_test : The purpose of this test is to verify the basic functionality of the design through self-checking mechanism. This includes standard packet sequences as per the design
`include "environment.sv"
//Define test class
class base_test;
  //Stimulus packet count
  bit [31:0] no_of_pkts;
  string testname; //used to identify the testname in the environment
  
  //virtual interface handles required for Driver,iMonitor and oMonitor
  virtual router_if.tb_mod_port vif;
  virtual router_if.tb_mon vif_mon_in;
  virtual router_if.tb_mon vif_mon_out;
  
  //enviroment class handle
  environment env;
  
  //custom constructor with virtual interface handles as arguments.
  function new (input virtual router_if.tb_mod_port vif_in,
              input virtual router_if.tb_mon  vif_mon_in,
              input virtual router_if.tb_mon  vif_mon_out,
	          input string testname);
    this.vif = vif_in;
    this.vif_mon_in = vif_mon_in;
    this.vif_mon_out = vif_mon_out; 
    this.testname = testname;
  endfunction
  
  
  //Build Verification environment and connect them.
  function void build();
    //Construct object for environment and connect interfaces
    env = new(vif, vif_mon_in, vif_mon_out, this.testname, no_of_pkts);
    //Call env build method which contruct its internal components and connects them
    env.build();
  endfunction
  
  
  //run method to start Verification environment.
  virtual task run();
    $display("[%s] run started at time=%0t",this.testname, $realtime);
    //Decide number of packets to generate in generator
    no_of_pkts = 10;
    //Construct objects for environment and connects interfaces
    build();
    //Start the Verification Environment
    env.run();
    $display("[%s] run ended at time=%0t",this.testname, $realtime);
  endtask

endclass
