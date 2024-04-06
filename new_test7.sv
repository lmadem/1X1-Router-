//new_test7 : This test is to send the stimulus packets of mixed-sizes and hit the coverage
`include "base_test.sv"
`include "new_packet7.sv"
//new_test7 extends from base_test
class new_test7 extends base_test;

  //new_pkt handle of type new_packet7
  new_packet7 new_pkt;
  string testname; //used to identify the testname in the environment
  
  //custom constructor with virtual interface handles as arguments.
  function new (input virtual router_if.tb_mod_port vif_in,
              input virtual router_if.tb_mon  vif_mon_in,
              input virtual router_if.tb_mon  vif_mon_out,
	          input string testname);
    
    super.new(vif_in, vif_mon_in, vif_mon_out, testname);
    this.testname = testname;
  
  endfunction
  
  //run method to start Verification environment.
  virtual task run();
    $display("[%s] run started at time=%0t", this.testname, $time);
    
    //Construct object for new_pkt handle.
    
    new_pkt = new();
    //Decide number of packets to generate in generator
    no_of_pkts = 100;
    //Construct objects for environment and connects intefaces.
    build();
    env.cov_status = 1;
    
    //Pass new_packet7 oject to Generator.
    //Handle assignment packet=new_packet(b=d);
    env.gen.ref_pkt = new_pkt;
    
    //Start the Verification Environment
    
    env.run();
    
    
    $display("[%s] run ended at time=%0t",this.testname, $time);
  endtask


endclass
