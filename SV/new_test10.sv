//error injection test
//new_test10 : This test is to inject invalid crc in the packet and see the behaviour of the test
`include "base_test.sv"
`include "new_packet10.sv"
//new_test10 extends from base_test
class new_test10 extends base_test;

  //new_pkt handle of type new_packet10
  new_packet10 new_pkt;
  string testname; //used to identify the testname in the environment
  bit [15:0] dropped_pkt_cnt; //used to read the status register from design
  
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
    no_of_pkts = 10;
    //Construct objects for environment and connects intefaces.
    build();
    env.env_disable_EOT = 1;
    env.env_disable_report = 1;
    
    //Pass new_packet10 oject to Generator.
    //Handle assignment packet=new_packet(b=d);
    env.gen.ref_pkt = new_pkt;
    
    //Start the Verification Environment
    
    env.run();
    if(env.env_disable_EOT == 1)
      wait(no_of_pkts == env.iMon.no_of_pkts_recvd);
    
    repeat(200) @(vif.cb); //drain time
    read_dut_csr();
    report();
    
    $display("[%s] run ended at time=%0t",this.testname, $time);
  endtask
  
  
  virtual task read_dut_csr();
    $display("[%s] Reading DUT Status registers Started at time=%0t", testname, $time);
    @(vif.cb);
    vif.cb.rd <= 1;
    vif.cb.addr <= 'h28; //csr_pkt_dropped_count; //addr='h32;
    @(vif.cb.rdata);
    dropped_pkt_cnt = vif.cb.rdata;
    $display("\n\n*********************************");
    $display("***** CSR DUT Status*****************");
    $display("csr_pkt_dropped_count=%0d ",vif.cb.rdata);
    $display("\n\n*********************************");
    vif.cb.rd <= 0;
    repeat(2) @(vif.cb);
    $display("[%s] Reading DUT Status registers Ended at time=%0t",testname, $time);
  endtask
  
  function void report();
    $display("\n[%s] ****** Report Started **********", testname); 
    //Call report method of iMon,oMon and scoreboard
    env.iMon.report();
    env.oMon.report();
    env.scb.report();
    $display("[CSR] Status csr_pkt_dropped_count=%0d at time=%0t ",dropped_pkt_cnt, $realtime);
    $display("\n*******************************"); 
    //Check the results and print test Passed or Failed
    if(no_of_pkts == dropped_pkt_cnt)
      $display("***********[%s] PASSED ************",testname); 
    else 
      begin
        $display("*********[%s] FAILED ************",testname);  
        $display("******dropped_pkt_count = %0d *********",dropped_pkt_cnt);
      end
    $display("*************************\n"); 
    $display("[Environment]*********Report ended**********\n"); 
  endfunction

endclass
