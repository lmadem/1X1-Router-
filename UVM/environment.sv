//environment by extending from uvm_env
class environment extends uvm_env;
  //Register environment into factory
  `uvm_component_utils(environment);
  
  //testname
  string name;
  
  //variable exp_pkt_count to keep track of total packets generated by sequence
  bit [31:0] exp_pkt_count; //from test
  
  //variable to keep track of matching packets
  bit [31:0] m_matched, mis_matched;
  
  //variable tot_cov_score to keep track of full coverage score
  real tot_cov_score;
  
  //variable ports_cov_score to keep track of coverage score for ports
  real ports_cov_score;
  
  //variable size_cov_score to keep track of coverage score for sizes
  real size_cov_score;
  
  //signal to enable/disable report method
  bit enable_report;
  
  
  //Instantiate master_agent component
  master_agent m_agent;
  
  //Instantiate slave_agent component
  slave_agent s_agent;
  
  //Instantiate scoreboard component
  scoreboard scb;
  
  //Instantiate coverage component
  coverage cov_comp;
  
  //custom constructor
  function new (string name="environment", uvm_component parent);
    super.new(name, parent);
  endfunction
  
  //extern methods
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void report_phase(uvm_phase phase);
  extern virtual function void extract_phase(uvm_phase phase);
	
endclass	
    

//build_phase to construct child components
function void environment::build_phase(uvm_phase phase);
  
  //Construct object for master_agent component
  m_agent = master_agent::type_id::create("m_agent", this);
  //Construct object for slave_agent component
  s_agent = slave_agent::type_id::create("s_agent", this);
  //Construct object for scoreboard component
  scb = scoreboard::type_id::create("scb", this);
  //Construct object for coverage component
  cov_comp = coverage::type_id::create("cov_comp", this);
endfunction

//connect_phase to connect components
function void environment::connect_phase(uvm_phase phase);
  //Connect master_agent's pass through port to scoreboard
  m_agent.pass_through_ap_port.connect(scb.mon_in);
  //Connect slave_agent's pass through port to scoreboard
  s_agent.pass_through_ap_port.connect(scb.mon_out);
  //Connect master_agent's pass through port to coverage
  m_agent.pass_through_ap_port.connect(cov_comp.analysis_export);
endfunction
    
//extract_phase to extract data from child components
function void environment::extract_phase(uvm_phase phase);
  //use uvm_config_db::get to extract test_name from test
  uvm_config_db#(string)::get(this, "cov_comp", "test_name", name);
  
  //use uvm_config_db::get to extract expected pkt count from test
  uvm_config_db#(int)::get(this, "m_agent.seqr.*", "item_count", exp_pkt_count);
  
  //use uvm_config_db::get to extract coverage number from coverage component
  uvm_config_db#(real)::get(this, "", "cov_score_ports", ports_cov_score);
  
  //use uvm_config_db::get to extract coverage number from coverage component
  uvm_config_db#(real)::get(this, "", "cov_score_size", size_cov_score);
  
  //use uvm_config_db::get to extract coverage number from coverage component
  uvm_config_db#(real)::get(this, "", "cov_score_full", tot_cov_score);
  
  //use uvm_config_db::get to extract matched pkt count from scoreboard 
  uvm_config_db#(int)::get(this, "", "matched", m_matched);
  
  //use uvm_config_db::get to extract mis_matched pkt count from scoreboard
  uvm_config_db#(int)::get(this, "", "mis_matched", mis_matched);
endfunction

//report_phase to print test PASS or FAIL results
function void environment::report_phase(uvm_phase phase);
  bit [31:0] tot_scb_cnt;
  //Calculate total packets processed by scoreboard
  tot_scb_cnt = m_matched + mis_matched;
  uvm_config_db#(bit)::get(this,"","enable_report",enable_report); 
  //$display("check :: scoreboard");
  //$display(m_matched);
  //$display(mis_matched);
  if(!enable_report) begin
    //Check if total pkts processed by scoreboard equal to pkts driven into DUT 
    if(exp_pkt_count != tot_scb_cnt) 
      begin
        `uvm_info("PASS", $sformatf("******************[%s] FAILED*********************",name), UVM_NONE);
        `uvm_info("FAIL", "Test Failed due to packet count MIS_MATCH", UVM_NONE);
        `uvm_info("FAIL", $sformatf("exp_pkt_count = %0d received_in_scb = %0d", exp_pkt_count, tot_scb_cnt), UVM_NONE);
        `uvm_fatal("FAIL", "******************TEST FAILED******************");
      end
    
    //Check if there are any mis_matched pkt count from scoreboard
    else if(mis_matched != 0)
      begin
        `uvm_info("PASS", $sformatf("******************[%s] FAILED*********************",name), UVM_NONE);
        `uvm_info("FAIL", "Test Failed due to mis_matched packets in scoreboard", UVM_NONE);
        `uvm_info("FAIL", $sformatf("matched_pkt_count = %0d  mis_matched_pkt_count = %0d", m_matched, mis_matched), UVM_NONE);
        `uvm_fatal("FAIL", "******************TEST FAILED******************");
      end
    
    //Test Passed as all packets matched and total pkts received
    else
      begin
        `uvm_info("PASS", $sformatf("******************[%s] PASSED*********************",name), UVM_NONE);
        `uvm_info("PASS", $sformatf("exp_pkt_count = %0d received_in_scb = %0d", exp_pkt_count, tot_scb_cnt), UVM_NONE);
        `uvm_info("PASS", $sformatf("matched_pkt_count = %0d  mis_matched_pkt_count = %0d", m_matched, mis_matched), UVM_NONE);
        `uvm_info("PASS", $sformatf("******************[%s] PASSED*********************",name), UVM_NONE);
      end
  end
  
  if(name == "test_sa_da")
    begin
      `uvm_info("COV_ENV", $sformatf("coverage_score = %0d", ports_cov_score), UVM_NONE);
    end
  else if(name == "test_mixed_size")
    begin
      `uvm_info("COV_ENV", $sformatf("coverage_score = %0d", size_cov_score), UVM_NONE);
    end
  else
    begin
      `uvm_info("COV_ENV", $sformatf("coverage_score = %0d", tot_cov_score), UVM_NONE);
    end

 
endfunction
