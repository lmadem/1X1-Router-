//new_test1 : The purpose of this test is to override the constraints and alter the number of packets in the environment
`include "base_test.sv"
`include "new_packet1.sv"
//new_test1 extends from base_test
class new_test1 extends base_test;

  //new_pkt handle of type new_packet1
  new_packet1 new_pkt;
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
    $display("[%s] run started at time=%0t", testname, $time);
    
    //Construct object for new_pkt handle.
    
    new_pkt = new();
    //Decide number of packets to generate in generator
    no_of_pkts = 5;
    //Construct objects for environment and connects intefaces.
    build();
    
    //Pass new_packet1 oject to Generator.
    //Handle assignment packet=new_packet(b=d);
    env.gen.ref_pkt = new_pkt;
    
    //Start the Verification Environment
    
    env.run();
    
    $display("[%s] run ended at time=%0t",testname, $time);
  endtask


endclass
