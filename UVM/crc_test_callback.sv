//crc_test_callback goal is to inject error into DUT by adding actual callback object to driver to corrupt CRC
class crc_test_callback extends uvm_test;
  //register crc_test_callback into factory
  `uvm_component_utils(crc_test_callback)
  
  virtual router_if vif;
  bit [31:0] dropped_pkt_count;
  bit [31:0] exp_pkt_count;  
  environment env;
  
  function new (string name="crc_test_callback",uvm_component parent=null);
    super.new(name, parent);
  endfunction
  
  //define extern methods
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void end_of_elaboration_phase(uvm_phase phase);
  extern virtual task main_phase (uvm_phase phase);
  extern virtual task shutdown_phase (uvm_phase phase);
  extern virtual function void report_phase(uvm_phase phase);

endclass	
    
//Build-phase   
function void crc_test_callback::build_phase(uvm_phase phase);
  super.build_phase(phase);
  exp_pkt_count=10;
  env=environment::type_id::create("env",this);
  
  uvm_config_db#(virtual router_if)::get(this,"","vif",vif);
  
  uvm_config_db#(virtual router_if.tb_mod_port)::set(this,"env.m_agent","drvr_if",vif.tb_mod_port);
  
  uvm_config_db#(virtual router_if.tb_mon)::set(this,"env.m_agent","iMon_if",vif.tb_mon);
  
  uvm_config_db#(virtual router_if.tb_mon)::set(this,"env.s_agent","oMon_if",vif.tb_mon);

  uvm_config_db#(int)::set(this,"env.*", "item_count", exp_pkt_count);
  
  uvm_config_db#(uvm_object_wrapper)::set(this,"env.m_agent.seqr.reset_phase","default_sequence",reset_sequence::get_type());
  
  uvm_config_db#(uvm_object_wrapper)::set(this,"env.m_agent.seqr.configure_phase","default_sequence",config_sequence::get_type());
  
  uvm_config_db#(uvm_object_wrapper)::set(this,"env.m_agent.seqr.main_phase","default_sequence",sa1da1_sequence::get_type());

  uvm_config_db#(bit)::set(this,"env","enable_report",1'b1); 
endfunction
    
//Implement end_of_elaboration_phase to add callbacks       
function void crc_test_callback::end_of_elaboration_phase(uvm_phase phase);
  //handle drv_err_cb of type err_inject_drv_cb
  crc_err_inject_drv_cb crc_drv_err_cb;
  super.end_of_elaboration_phase(phase);
  
  //Construct callback object crc_drv_err_cb
  crc_drv_err_cb = new();
  
  //Add callback object crc_drv_err_cb to driver
  uvm_callbacks #(driver, driver_callback_facade_crc)::add(this.env.m_agent.drvr, crc_drv_err_cb);
  
  uvm_callbacks #(driver, driver_callback_facade_crc)::display();
   
endfunction

//main phase
task crc_test_callback::main_phase(uvm_phase phase);
  uvm_objection objection;
  super.main_phase(phase);
  objection=phase.get_objection();
  objection.set_drain_time(this,2500ns);
  //The drain time is the amount of time to wait once all objections have been dropped
endtask

//Run shutdown sequence in shutdown phase to read drooped count from DUT
task crc_test_callback::shutdown_phase(uvm_phase phase);
  //Instantiate and construct shutdown sequence
  crc_shutdown_sequence seq;
  seq = crc_shutdown_sequence::type_id::create("seq", this);
  phase.raise_objection(this, "Raised objection from CRC callback test");
  //Start the shutdown seq on sequencer
  seq.start(this.env.m_agent.seqr);
  
  //Get the dropped count from seq which helps in deciding test pass or fail
  dropped_pkt_count = seq.dropped_pkt_count;
  phase.drop_objection(this, "Dropped objection from CRC callback test");
endtask
      
//report_phase to print test PASS or FAIL results.
function void crc_test_callback::report_phase(uvm_phase phase);
  //Check if total pkts dropped by dut equal to pkts driven into DUT 
  if(exp_pkt_count != dropped_pkt_count) begin

    `uvm_info("FAIL", "****************Test FAILED******************", UVM_NONE);
    `uvm_info("FAIL","Test Failed due to packet count MIS_MATCH",UVM_NONE); 
    `uvm_info("FAIL",$sformatf("exp_pkt_count=%0d Dropped_pkt_count=%0d ",exp_pkt_count,dropped_pkt_count),UVM_NONE); 
    `uvm_fatal("FAIL","******************Test FAILED ************");
  end
  //Test Passed as all packets dropped by DUT.
  else begin
    `uvm_info("PASS", "******************Test PASSED ***************",UVM_NONE);
    `uvm_info("PASS",$sformatf("exp_pkt_count=%0d Dropped_pkt_count=%0d ",exp_pkt_count,dropped_pkt_count),UVM_NONE); 
    `uvm_info("PASS","******************************************",UVM_NONE);
  end
endfunction



