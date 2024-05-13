//scoreboard by extending from uvm_scoreboard.
class scoreboard extends uvm_scoreboard;
  //Register scoreboard into factory
  `uvm_component_utils(scoreboard);
  
  //analysis port to receive packet from iMonitor
  uvm_analysis_port #(packet) mon_in;
  
  //analysis port to receive packet from oMonitor
  uvm_analysis_port #(packet) mon_out;
  
  //Instantiate UVM in-built comparator component typed to packet
  uvm_in_order_class_comparator #(packet) m_comp;
  
  //custom constructor
  function new (string name = "scoreboard", uvm_component parent=null);
    super.new(name, parent);
  endfunction
  
  
  //build_phase to construct object for m_comp and analysis ports
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    //Construct object for comparator component
    m_comp = uvm_in_order_class_comparator#(packet)::type_id::create("m_comp", this);
    
    //Construct object for mon_in analysis port
    mon_in = new("mon_in", this);
    
    //Construct object for mon_out analysis port
    mon_out = new("mon_out", this);
  
  endfunction
  
  
  //connect_phase to connect analysis ports to comparator
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    //Connect mon_in port to comparator's before_export
    mon_in.connect(m_comp.before_export);
    //Connect mon_out port to comparator's after_export
    mon_out.connect(m_comp.after_export);
  endfunction
  
  //Implement extract_phase to send matched/mis_matched count to environment
  virtual function void extract_phase(uvm_phase phase);
    //use uvm_config_db::set to send matched count to environment
    uvm_config_db#(int)::set(null,"uvm_test_top.env", "matched", m_comp.m_matches);
    //use uvm_config_db::set to send mis_matched count to environment
    uvm_config_db#(int)::set(null,"uvm_test_top.env", "mis_matched", m_comp.m_mismatches);
  endfunction
  
  //report_phase to print matched/mis_matched count.
  function void report_phase(uvm_phase phase);
    `uvm_info("SCB", $sformatf("Scoreboard completed with matches=%0d mismatches=%0d", m_comp.m_matches, m_comp.m_mismatches), UVM_NONE);
  endfunction 

endclass


